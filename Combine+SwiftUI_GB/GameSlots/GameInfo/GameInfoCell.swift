//
//  GameInfoCell.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import SwiftUI

struct GameInfoCell: View {

// MARK: - Properties
    
    let gameInfo: GameInfoModels
    
// MARK: - Body
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: self.gameInfo.apod.hdurl ?? self.gameInfo.apod.url),
                       transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .transition(.scale(scale: 0.1, anchor: .center))
                case .failure:
                    Image(systemName: "wifi.slash")
                        .frame(width: 44, height: 44, alignment: .center)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text("\(self.gameInfo.apod.explanation)")
                .font(.caption)
        }
        .listRowSeparatorTint(Color.blue)
    }
}
