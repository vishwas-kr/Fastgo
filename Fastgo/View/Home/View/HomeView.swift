//
//  HomeView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var showSheet : Bool = false
    @StateObject private var router = HomeRouter()
    @StateObject private var viewModel = HomeViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack(path: $router.navPath){
            ZStack(){
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .ignoresSafeArea()
                
                FadingGradient(color1: .newGray, color2:  Color.white.opacity(0.1), location1: 0.0, location2: 0.2, startPoint: .top, endPoint: .bottom)
                
                FadingGradient(color1: .newGray, color2:  Color.white.opacity(0.1), location1: 0.0, location2: 0.2, startPoint: .bottom, endPoint: .top)
                
                VStack{
                    CustomAppBar()
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack {
                            ForEach(PromoVariant.allCases, id:\.self) {promo in
                                PromoPill(title: promo.title, description: promo.description, image: promo.image, backgroundColor: promo.backgrounColor)
                            }
                        }
                    }
                    Spacer()
                    
                    LocationButton()
                    
                    Button(action:{
                        showSheet.toggle()
                    }){
                        HStack(spacing: 8) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title)
                            
                                .foregroundColor(.white)
                            Text("Scan to ride")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 65)
                        .background(Color.green)
                        .clipShape(Capsule())
                        
                    }
                }
                .padding(.horizontal)
                
            }
            .navigationDestination(for: HomeRoutes.self){ route in
                switch route {
                case .profile: ProfileView()
                case .profileOptions(let option):
                    switch option {
                    case .myAccount:
                        Text("My Account View")
                            .navigationTitle("My Account")
                    case .paymentMethod:
                        Text("Payment Method View")
                            .navigationTitle("Payment Methods")
                    case .rideHistory:
                        RideHistoryView()
                    case .promoCode:
                        Text("Promo Code View")
                            .navigationTitle("Promo Codes")
                    case .inviteFriends:
                        Text("Invite Friends View")
                            .navigationTitle("Invite Friends")
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSheet) {
            RideDetailsView()
                .presentationDetents([.medium, .fraction(0.8)])
        }
        .environmentObject(router)
    }
}

#Preview {
    HomeView()
}
