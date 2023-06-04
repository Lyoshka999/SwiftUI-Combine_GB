//
//  GameInfoVM.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import SwiftUI
import Combine

final class GameInfoVM: ObservableObject {
    typealias asteroids = (key: String, value: [NearEarthObject])

    @Published var gameInfoModels: [GameInfoModels] = []
    @Published var error: NetworkService.APIError? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var networkService = NetworkService()
    
    
    func fetchGameInfo(startDate: String, endDate: String) {
        gameInfoModels.removeAll()
        networkService.fetchSkyInfo(startDate: startDate, endDate: endDate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let error):
                    self.gameInfoModels = []
                    self.error = error
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] apod, asteroid in
                guard let self = self else { return }
                self.gameInfoModels.append(GameInfoModels(apod: apod, new: asteroid))
                self.error = nil
            }
        )
        .store(in: &cancellables)
    }
}

