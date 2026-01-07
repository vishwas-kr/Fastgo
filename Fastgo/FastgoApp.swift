//
//  FastgoApp.swift
//  Fastgo
//
//  Created by vishwas on 12/25/25.
//

import SwiftUI

@main
struct FastgoApp: App {
    @StateObject private var appState = AppStateManager.shared
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .task {
                    await appState.initializeApp()
                }
        }
    }
}


struct RootView: View {
    @EnvironmentObject var appState: AppStateManager
    
    var body: some View {
        currentView
            .animation(.easeInOut, value: appState.currentFlow)
    }
    
    @ViewBuilder
    private var currentView: some View {
        switch appState.currentFlow {
        case .loading:
            LoadingView()
            
        case .onboarding:
            OnboardingView(appState: appState)
            
        case .signIn, .verifyOTP:
            AuthFlowView()
            
        case .basicInfo:
            BasicInfoView()
            
        case .home:
            HomeView()
        }
    }
}


struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                
                Text("Fastgo")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
}
