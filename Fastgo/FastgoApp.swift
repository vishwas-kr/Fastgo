//
//  FastgoApp.swift
//  Fastgo
//
//  Created by vishwas on 12/25/25.
//

import SwiftUI

@main
struct FastgoApp: App {
    @ObservedObject private var router = Router()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath){
                OnboardingView()
                    .navigationDestination(for: Router.AuthFlow.self){ destination in
                        switch destination {
                        case .onboarding: OnboardingView()
                        case .signIn: SignInView()
                        case .verifyOTP: OPTVerifyView()
                        case .newOnboardingSuccess : NewOnboardingSuccessView()
                        case .basicInfo : BasicInfoView()
                        case .home: HomeView()
                        }
                    }
            } .environmentObject(router)
        }
    }
}
