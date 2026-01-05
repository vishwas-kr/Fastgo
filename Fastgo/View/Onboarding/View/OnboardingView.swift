//
//  OnboardingView.swift
//  Fastgo
//
//  Created by vishwas on 12/25/25.
//

import SwiftUI

struct OnboardingView : View {
    @EnvironmentObject private var router : Router
    @EnvironmentObject private var appState : AppStateManager
    @StateObject private var viewModel: OnboardingViewModel
    
    init(appState: AppStateManager, router: Router) {
        _viewModel = .init(
            wrappedValue: OnboardingViewModel(
                appState: appState,
                router: router
            )
        )
    }
    
    var body : some View {
        ZStack{
            VStack {
                Image("on2")
                    .resizable()
                    .frame(width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height * 0.65)
                    .ignoresSafeArea()
                
                Spacer()
            }
            VStack{
                Spacer()
                RoundedRectangle(cornerRadius: 40)
                    .frame(height: UIScreen.main.bounds.height * 0.35)
                    .foregroundStyle(.white)
                    .overlay(
                        VStack{
                            pageIndicator
                            
                            onboardingPages
                            
                            actionButton
                        }.padding()
                    )
            }
        }
    }
    private var pageIndicator: some View {
        HStack{
            ForEach(0..<viewModel.totalPages,id:\.self) {index in
                Circle()
                    .fill(viewModel.currentPage == index ? Color.pink : Color(.systemGray4))
                    .frame(width: viewModel.currentPage == index ? 12 : 8)
                    .animation(.spring(), value:viewModel.currentPage)
            }
        }.padding()
    }
    
    private var onboardingPages: some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                OnboardingText(page: page)
                    .tag(page.rawValue)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .allowsHitTesting(false)
    }
    
    private var actionButton: some View {
        Button(action:viewModel.nextButton){
            Text(viewModel.buttonTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height:55)
                .background(.green)
                .clipShape(Capsule())
            
        }
    }
}


#Preview {
    OnboardingView(appState: AppStateManager.shared, router: Router())
}

