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
        query.spaces = "appDataFolder"
        query.q = "name contains '\(Constants.my)' and name contains '\(Constants.favorites)'"
        
        driveService.executeQuery(query)
    }
}

//func uploadFile() {
//    let file = GTLRDrive_File()
//    file.name = "test.json"
//    file.parents = ["appDataFolder"]
//
//    let json = ["test": "value"]
//    guard let data = try? JSONSerialization.data(withJSONObject: json) else { return }
//
//    let parameters = GTLRUploadParameters(data: data, mimeType: "application/json")
//    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: parameters)
//
//    googleDriveService.executeQuery(query) { (_, result, error) in
//        self.getFile()
//    }
//}
//
//func getFile() {
//    let query = GTLRDriveQuery_FilesList.query()
//    query.spaces = "appDataFolder"
//
//    googleDriveService.executeQuery(query) { _, result, error in
//        let files = result as? GTLRDrive_FileList
//
//        guard let file = files?.files?.first else {
//            return
//        }
//
//        let getFileQuery = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: file.identifier!)
//        getFileQuery.completionBlock = { ticket, object, error in
//            guard let data = (object as? GTLRDataObject)?.data else { return }
//
//            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
//
//            guard let json = jsonObject as? [String: Any] else { return }
//
//            print(json)
//        }
//        self.googleDriveService.executeQuery(getFileQuery)
//
////            if let id = files?.files?.first?.identifier {
////                self.deleteFiles(id: id)
////            }
//    }
//}
