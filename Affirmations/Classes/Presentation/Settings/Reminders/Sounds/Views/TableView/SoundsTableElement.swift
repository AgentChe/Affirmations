//
//  SoundsTableElement.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

final class SoundsTableElement {
    let sound: Sound
    var marked: Bool
    
    init(sound: Sound, marked: Bool) {
        self.sound = sound
        self.marked = marked
    }
}
