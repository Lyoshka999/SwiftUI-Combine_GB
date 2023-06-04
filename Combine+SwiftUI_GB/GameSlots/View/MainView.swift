//
//  MainView.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import SwiftUI

enum Tabs: String {
    case GameInfo = "Game Info"
    case GameSlots = "Game Slots"
}

enum Icon: String {
    case GameInfo = "moon.stars.fill"
    case GameSlots = "gamecontroller.fill"
}

struct MainView: View {
    private let GameInfoViewModel = GameInfoVM()
    private let GameSlotsViewModel = GameSlotsVM()
    
    @State private var selectedTab: Tabs = .GameInfo
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                GameInfoView(viewModel: GameInfoViewModel)
            }
            .tabItem {
                Label(Tabs.GameInfo.rawValue,
                      systemImage: Icon.GameInfo.rawValue)
            }
            .tag(Tabs.GameInfo)
            
            NavigationView {
                GameSlots(viewModel: GameSlotsViewModel)
            }
            .tabItem {
                Label(Tabs.GameSlots.rawValue,
                      systemImage: Icon.GameSlots.rawValue)
            }
            .tag(Tabs.GameSlots)
        }
        .navigationTitle(selectedTab.rawValue)
        .navigationBarBackButtonHidden(true)
        // fix constraints errors
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDisplayName("MainView")
            .previewDevice("iPhone 13 mini")
    }
}

