//
//  GameSlotsVM.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import SwiftUI
import Combine

final class GameSlotsVM: ObservableObject {
    @Published var isGameStarted: Bool = false
    @Published var firstSlot: String = "🤖"
    @Published var secondSlot: String = "🤖"
    @Published var thirdSlot: String = "🤖"
    @Published var textTitle = ""
    @Published var buttonText = ""
    @Published var justForRemember: Bool = false
    
    private let runLoop = RunLoop.main
    private var cancellables = Set<AnyCancellable>()
    // TODO: Привязать изменение слотов к таймеру через share или multicast
    private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    private let arrayEmoji = ["🤪", "😎", "😜", "🥶", "😷", "🤯"]
     
    init() {
        timer
            .receive(on: runLoop)
            .sink { [weak self] _  in self?.random() }
            .store(in: &cancellables)
        
        $isGameStarted
            .receive(on: runLoop)
            .combineLatest($justForRemember)
            .compactMap { [weak self] isRun, remember in
                guard let self = self else { return nil }
                guard !isRun && remember else { return "Let's play!" }
                return (
                    self.firstSlot == self.secondSlot
                    && self.firstSlot == self.thirdSlot ? "You won!" : "You lose!"
                )
            }
            .assign(to: &$textTitle)
        
        $isGameStarted
            .receive(on: runLoop)
            .map { $0 == true ? "Catch it!" : "Start" }
            .assign(to: &$buttonText)
    }
    
    private func random() {
        guard isGameStarted else { return }
        firstSlot = arrayEmoji.randomElement() ?? ""
        secondSlot = arrayEmoji.randomElement() ?? ""
        thirdSlot = arrayEmoji.randomElement() ?? ""
    }
}

