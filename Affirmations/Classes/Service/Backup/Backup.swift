//
//  Backup.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 16.09.2023.
//

import RxSwift
import RxCocoa
import GoogleSignIn
import GoogleAPIClientForREST

final class Backup {
    static let shared = Backup()
    
    private lazy var driveService = GTLRDriveService()
    
    private lazy var isSignInTrigger = BehaviorRelay<Bool>(value: false)
    
    private lazy var contentManager = ContentManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private init() {
        isSignInTrigger.accept(checkSignIn())
    }
}

// MARK: Public
extension Backup {
    enum Constants {
        static let favorites = "favorites.json"
        static let my = "user_affirmation.json"
        static let syncTimestamp = "sync_timestamp"
        static let lastUpdateFavorites = "last_update_favorites_key"
        static let lastUpdateMy = "last_update_my_key"
    }
    
    func initialize() {
        restorePreviousSignIn()
        
        isSignIn
            .filter { $0 }
            .asObservable()
            .take(1)
            .bind(to: Binder(self) { base, void in
                base.startSyncContent()
            })
            .disposed(by: disposeBag)
    }
    
    var isSignIn: Signal<Bool> {
        isSignInTrigger.asSignal(onErrorSignalWith: .never())
    }
    
    func signIn(presenting: UIViewController) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presenting,
            hint: nil,
            additionalScopes: [
                kGTLRAuthScopeDriveAppdata,
                kGTLRAuthScopeDriveFile
            ]
        ) { result, error in
            if let user = result?.user {
                Self.shared.driveService.authorizer = user.fetcherAuthorizer
            }
            
            Self.shared.isSignInTrigger.accept(Self.shared.checkSignIn())
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        isSignInTrigger.accept(checkSignIn())
    }
}

// MARK: Private
private extension Backup {
    enum Sync {
        case merge, upload
    }
    
    func restorePreviousSignIn() {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else { return }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            self?.driveService.authorizer = user?.fetcherAuthorizer
            self?.isSignInTrigger.accept(Self.shared.checkSignIn())
        }
    }
    
    func checkSignIn() -> Bool {
        GIDSignIn.sharedInstance.hasPreviousSignIn() && (GIDSignIn.sharedInstance.currentUser != nil)
    }
    
    func startSyncContent() {
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "files(id,name,modifiedTime)"
        query.spaces = "appDataFolder"
        query.completionBlock = { [weak self] ticket, object, error in
            guard let self, let files = (object as? GTLRDrive_FileList)?.files else {
                return
            }
            
            let favoritesFile = files.first(where: { $0.name == Constants.favorites })
            let myFile = files.first(where: { $0.name == Constants.my })

            self.sync(
                file: favoritesFile,
                lastUpdateKey: Constants.lastUpdateFavorites,
                name: Constants.favorites,
                replace: { affirmations -> Single<Void> in
                    self.contentManager
                        .replace(favorites: affirmations)
                },
                upload: {
                    self.contentManager
                        .obtainFavoritesAffirmations()
                }
            )

            self.sync(
                file: myFile,
                lastUpdateKey: Constants.lastUpdateMy,
                name: Constants.my,
                replace: { affirmations -> Single<Void> in
                    self.contentManager
                        .replace(my: affirmations)
                },
                upload: {
                    self.contentManager
                        .obtainMyAffirmations()
                }
            )
        }
        
        driveService.executeQuery(query)
    }
    
    func sync(
        file: GTLRDrive_File?,
        lastUpdateKey: String,
        name: String,
        replace: @escaping ([Affirmation]) -> Single<Void>,
        upload: @escaping () -> Single<[Affirmation]>
    ) {
        var sync: Sync {
            let lastUpdateDate = UserDefaults.standard.value(forKey: lastUpdateKey) as? Date
            
            if lastUpdateDate == nil && file == nil {
                return .upload
            }
            
            guard let lastUpdateDate else {
                return .merge
            }
            
            guard let modifiedDate = file?.modifiedTime?.date else {
                return .upload
            }
            
            return modifiedDate > lastUpdateDate ? .merge : .upload
        }
        
        switch sync {
        case .merge:
            guard let id = file?.identifier else {
                return
            }
            
            let mergeQuery = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: id)
            mergeQuery.completionBlock = { [weak self] ticket, object, error in
                guard
                    let self = self,
                    let data = (object as? GTLRDataObject)?.data,
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                    let jsonArray = jsonObject as? [[String: Any]]
                else {
                    return
                }
                
                self.saveLastUpdate(name: name, lastUpdateKey: lastUpdateKey)
                
                let affirmations = self.map(jsonArray: jsonArray)
                
                replace(affirmations)
                    .subscribe()
                    .disposed(by: disposeBag)
            }
            
            driveService.executeQuery(mergeQuery)
        case .upload:
            upload()
                .subscribe(onSuccess: { [weak self] affirmations in
                    guard let self else { return }
                    
                    let array = affirmations.map { affirmation -> [String: Any] in
                        [
                            "id": affirmation.id,
                            "message": affirmation.message,
                            "time": affirmation.date.timeIntervalSince1970
                        ]
                    }
                    
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) else {
                        return
                    }
                    
                    let uploadFile = GTLRDrive_File()
                    uploadFile.name = name
                    uploadFile.parents = ["appDataFolder"]
                    
                    let parameters = GTLRUploadParameters(data: jsonData, mimeType: "application/json")
                    
                    var uploadQuery: GTLRQueryProtocol {
                        guard let fileId = file?.identifier else {
                            let createQuery =  GTLRDriveQuery_FilesCreate.query(withObject: uploadFile, uploadParameters: parameters)
                            createQuery.completionBlock = { ticket, object, error in
                                guard error == nil else { return }
                                
                                self.saveLastUpdate(name: name, lastUpdateKey: lastUpdateKey)
                            }
                            return createQuery
                        }
                        
                        let deleteQuery = GTLRDriveQuery_FilesDelete.query(withFileId: fileId)
                        deleteQuery.completionBlock = { ticket, object, error in
                            guard error == nil else { return }
                            
                            let createQuery = GTLRDriveQuery_FilesCreate.query(withObject: uploadFile, uploadParameters: parameters)
                            createQuery.completionBlock = { ticket, object, error in
                                guard error == nil else { return }
                                
                                self.saveLastUpdate(name: name, lastUpdateKey: lastUpdateKey)
                            }
                            
                            self.driveService.executeQuery(createQuery)
                        }
                        
                        return deleteQuery
                    }
                    self.driveService.executeQuery(uploadQuery)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func saveLastUpdate(name: String, lastUpdateKey: String) {
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "files(id,name,modifiedTime)"
        query.spaces = "appDataFolder"
        query.completionBlock = { ticket, object, error in
            let files = (object as? GTLRDrive_FileList)?.files ?? []
            if let time = files.first(where: { $0.name == name })?.modifiedTime {
                UserDefaults.standard.set(time.date, forKey: lastUpdateKey)
            }
        }
        driveService.executeQuery(query)
    }
    
    func map(jsonArray: [[String: Any]]) -> [Affirmation] {
        jsonArray.compactMap { json -> Affirmation? in
            guard
                let id = json["id"] as? Int,
                let message = json["message"] as? String,
                let time = json["time"] as? TimeInterval
            else {
                return nil
            }
            
            return Affirmation(
                id: id,
                message: message,
                date: Date(timeIntervalSince1970: time)
            )
        }
    }
}
