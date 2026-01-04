//
//  BasicInfoView.swift
//  Fastgo
//
//  Created by vishwas on 12/29/25.
//

import SwiftUI

struct BasicInfoView: View {
    @State private var currentPage : BasicInfo = .name
    @State private var navigateToSuccsees : Bool = false
    @EnvironmentObject private var router : Router
    var body: some View {
        //  NavigationStack {
        VStack{
            HStack{
                ForEach(0...BasicInfo.allCases.count-1, id:\.self){index in
                    Rectangle()
                        .foregroundColor(index <= currentPage.rawValue ? .green : .gray.opacity(0.2))
                        .frame(maxWidth: 55, maxHeight: 8)
                        .cornerRadius(12)
                        .animation(.spring(), value:currentPage)
                }
            }.padding(.bottom,16)
            
            BasicInfoHeaderView(title: currentPage.title, description: currentPage.description)
                .padding()
            
            Group {
                switch currentPage {
                case .name:
                    NameView()
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                case .dob:
                    DateOfBirthView()
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                case .gender:
                    GenderCardView()
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeInOut(duration: 0.35), value: currentPage)
            
            Spacer()
            
            HStack{
                
                if (currentPage.rawValue != 0){
                    Button(action:back){
                        Text("Back")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:55)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.green)
                            )
                    }
                }
                
                Button(action: {
                    if currentPage.rawValue < BasicInfo.allCases.count-1 {
                        next()
                    } else {
                        //navigateToSuccsees = true
                        router.navigate(to: .newOnboardingSuccess)
                    }
                }){
                    Text(currentPage.rawValue >= 2 ? "Submit" : "Next")
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
        .padding()
        .navigationBarBackButtonHidden(true)
        // .navigationDestination(isPresented: $navigateToSuccsees){SuccessView()}
        // }
    }
    
    func back() {
        if let prev = BasicInfo(rawValue: currentPage.rawValue - 1) {
            currentPage = prev
        }
    }
    
    func next() {
        if let next = BasicInfo(rawValue: currentPage.rawValue + 1) {
            currentPage = next
        }
    }
}

#Preview {
    BasicInfoView()
}




