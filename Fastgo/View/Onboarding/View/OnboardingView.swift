//
//  OnboardingView.swift
//  Fastgo
//
//  Created by vishwas on 12/25/25.
//

import SwiftUI

struct OnboardingView : View {
    @State private var currentPage = 0
    @State private var navigateToSignIn = false
    @EnvironmentObject private var router : Router
    var body : some View {
        // NavigationStack {
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
                            HStack{
                                ForEach(0..<OnboardingPage.allCases.count,id:\.self) {index in
                                    Circle()
                                        .fill(currentPage == index ? Color.pink : Color(.systemGray4))
                                        .frame(width: currentPage == index ? 12 : 8)
                                        .animation(.spring(), value:currentPage)
                                }
                            }.padding()
                            
                            TabView(selection: $currentPage){
                                ForEach(OnboardingPage.allCases, id: \.rawValue){ page in
                                    OnboardingText(page: page)
                                        .tag(page.rawValue)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .allowsHitTesting(false)
                            
                            
                            Button(action:{
                                if currentPage < OnboardingPage.allCases.count-1 {
                                    currentPage+=1
                                } else {
                                   // navigateToSignIn = true
                                    router.navigate(to: .signIn)
                                }
                            }){
                                Text(currentPage < OnboardingPage.allCases.count-1 ? "Next" : "Get Started")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(height:55)
                                    .background(.green)
                                    .clipShape(Capsule())
                                
                            }
                        }.padding()
                    )
            }
        }
        //            .navigationDestination(isPresented: $navigateToSignIn){
        //                SignInView()
        //            }
        // }
    }
}


#Preview {
    OnboardingView()
}

