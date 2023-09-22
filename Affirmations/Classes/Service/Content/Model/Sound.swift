//
//  Sound.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

enum Sound: Codable, Hashable, CaseIterable {
    case not
    case acmeSiren
    case bicycle
    case chimes
    case coin
    case correct
    case domino
    case drop
    case drums
    case frog
    case galaxy
    case magicWand
    case messenger
    case positive
    case spaceship
    case tada
    case videoGame
    
    var name: String {
        switch self {
        case .not:
            return "Sounds.Not".localized
        case .acmeSiren:
            return "Sounds.AcmeSiren".localized
        case .bicycle:
            return "Sounds.Bicycle".localized
        case .chimes:
            return "Sounds.Chimes".localized
        case .coin:
            return "Sounds.Coin".localized
        case .correct:
            return "Sounds.Correct".localized
        case .domino:
            return "Sounds.Domino".localized
        case .drop:
            return "Sounds.Drop".localized
        case .drums:
            return "Sounds.Drums".localized
        case .frog:
            return "Sounds.Frog".localized
        case .galaxy:
            return "Sounds.Galaxy".localized
        case .magicWand:
            return "Sounds.MagicWand".localized
        case .messenger:
            return "Sounds.Messenger".localized
        case .positive:
            return "Sounds.Positive".localized
        case .spaceship:
            return "Sounds.Spaceship".localized
        case .tada:
            return "Sounds.Tada".localized
        case .videoGame:
            return "Sounds.VideoGame".localized
        }
    }
    
    var file: String? {
        switch self {
        case .not:
            return nil
        case .acmeSiren:
            return "acme_siren"
        case .bicycle:
            return "bicycle"
        case .chimes:
            return "chimes"
        case .coin:
            return "coin"
        case .correct:
            return "correct"
        case .domino:
            return "domino"
        case .drop:
            return "drop"
        case .drums:
            return "drums"
        case .frog:
            return "frog"
        case .galaxy:
            return "galaxy"
        case .magicWand:
            return "magic_wand"
        case .messenger:
            return "messenger"
        case .positive:
            return "positive"
        case .spaceship:
            return "spaceship"
        case .tada:
            return "tada"
        case .videoGame:
            return "video_game"
        }
    }
}
