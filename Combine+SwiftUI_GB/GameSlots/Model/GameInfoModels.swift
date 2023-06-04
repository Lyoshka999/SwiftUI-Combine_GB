//
//  GameInfoModels.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import Foundation

struct GameInfoModels: Identifiable {
    typealias Asteroids = (key: String, value: [NearEarthObject])
    
    let id = UUID()
    let apod: APOD
    let new: Asteroids
}
