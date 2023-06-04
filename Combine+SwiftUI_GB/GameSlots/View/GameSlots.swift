//
//  GameSlots.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import SwiftUI

struct GameSlots: View {
    @ObservedObject private var viewModel: GameSlotsVM
    
    init(viewModel: GameSlotsVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(.all, edges: .top)
            VStack {
                Text(viewModel.textTitle)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack {
                    Text(viewModel.firstSlot)
                    Text(viewModel.secondSlot)
                    Text(viewModel.thirdSlot)
                    
                }
                .font(.system(size: 80))
                
                Spacer()
                
                Button(viewModel.buttonText) {
                    print("tapped")
                    viewModel.isGameStarted.toggle()
                    viewModel.justForRemember = true
                }
                .foregroundColor(.white)
                .font(.system(size: 60))
                .padding(.bottom, 10)
            }
        }
    }
}

struct GameSlots_Previews: PreviewProvider {
    static var previews: some View {
        GameSlots(viewModel: GameSlotsVM())
            .previewDisplayName("GameSlots")
            .previewDevice("iPhone 13 mini")
    }
}
