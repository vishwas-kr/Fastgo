//
//  RideHistoryTabBar.swift
//  Fastgo
//
//  Created by vishwas on 1/30/26.
//
import SwiftUI

struct RideHistoryTabView : View {
    @StateObject var viewModel: RideHistoryViewModel
    @Namespace private var underlineNamespace
    var body : some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack (spacing:0) {
                ForEach(viewModel.tabs.indices, id:\.self) {index in
                    
                    VStack{
                        Text(viewModel.tabs[index])
                            .fontWeight(viewModel.selectedTab == index ? .bold : .regular)
                            .padding(.horizontal,22)
                            .onTapGesture {
                                viewModel.selectedTab = index
                            }
                        if viewModel.selectedTab == index {
                            Rectangle()
                                .frame(height:2)
                                .foregroundStyle(.green)
                                .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                        } else {
                            Rectangle()
                                .frame(height:0.5)
                                .foregroundStyle(Color(.systemGray3))
                        }
                        
                    }
                }
            }
        }
    }
}
