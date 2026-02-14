//
//  HomeView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var router = HomeRouter()
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var rideViewModel = RideNavigationViewModel()
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        NavigationStack(path: $router.navPath){
            ZStack(){
                MapView(mapViewModel: mapViewModel, rideViewModel: rideViewModel)
                
                FadingGradient(color1: .newGray, color2:  Color.white.opacity(0.1), location1: 0.0, location2: 0.2, startPoint: .top, endPoint: .bottom)
                
                FadingGradient(color1: .newGray, color2:  Color.white.opacity(0.1), location1: 0.0, location2: 0.2, startPoint: .bottom, endPoint: .top)
                
                VStack{
                    CustomAppBar(mapViewModel: mapViewModel)
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack {
                            ForEach(PromoVariant.allCases, id:\.self) {promo in
                                PromoPill(title: promo.title, description: promo.description, image: promo.image, backgroundColor: promo.backgrounColor)
                            }
                        }
                    }
                    Spacer()
                    
                    LocationButton(viewModel: mapViewModel)
                    
                    Button(action:{
                        router.navigate(to: .scanQRCode(.home))
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
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: HomeRoutes.self){ route in
                switch route {
                case .profile: ProfileView()
                case .scanQRCode(let source): QRCodeScanView(source: source, mapViewModel: mapViewModel, rideViewModel: rideViewModel)
                case .rideNavigation(let scooter):
                    RideNavigationView(mapViewModel: mapViewModel, rideViewModel: rideViewModel, scooterAnnotation: scooter)
                case .rideCompleted:
                    FinishRideView(mapViewModel: mapViewModel, rideViewModel: rideViewModel)
                case .ridePhoto:
                    RidePhotoView(rideViewModel: rideViewModel)
                case .profileOptions(let option):
                    switch option {
                    case .myAccount:
                        MyAccountView()
                    case .paymentMethod:
                        PaymentView()
                    case .rideHistory:
                        RideHistoryView()
                    case .promoCode:
                        PromoCodeView()
                    case .inviteFriends:
                        EmptyView()
                    }
                }
                
            }
        }
        .sheet(item: $mapViewModel.selectedAnnotation) { annotation in
            RideDetailsView(annotation: annotation, mapViewModel: mapViewModel, rideViewModel: rideViewModel)
                .fixedSize(horizontal: false, vertical: true)
                            .modifier(GetHeightModifier(height: $sheetHeight))
                            .presentationDetents([.height(sheetHeight)])
        }
        .environmentObject(router)
    }
}

#Preview {
    HomeView()
}
