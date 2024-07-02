import SwiftUI

struct SkinsGameView: View {
    
    @Environment(\.presentationMode) var pressmode
    @EnvironmentObject var planeManager: PlaneManager
    @EnvironmentObject var profileData: ProfileData
    
    @StateObject var skinsManager: SkinsManager = SkinsManager()
    
    @State var errorPurchase = false
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image("balance_label")
                    Text("\(profileData.points)")
                        .font(.custom("DamnNoisyKids", size: 24))
                        .foregroundColor(.white)
                }
                Spacer()
                
                Button {
                    pressmode.wrappedValue.dismiss()
                } label: {
                    Image("back_button")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(.trailing)
            }
            
            Text("Skins")
                .font(.custom("DamnNoisyKids", size: 42))
                .foregroundColor(Color.init(red: 48/255, green: 83/255, blue: 173/255))
                .padding(.top, 24)
            
            Spacer()
            
            ZStack {
                Image("values_back")
                    .resizable()
                    .frame(width: 300, height: 600)
                
                VStack {
                    ForEach(skinsManager.availableAirplanes, id: \.id) { plane in
                        if planeManager.plane == plane.id {
                            VStack {
                                ZStack {
                                    Image("skin_background")
                                    Image(plane.icon)
                                }
                                HStack {
                                    ZStack {
                                        Image("button_background")
                                        Text("SELECTED")
                                            .font(.custom("DamnNoisyKids", size: 18))
                                            .foregroundColor(.white)
                                    }
                                }
                                .offset(y: -20)
                            }
                        } else {
                            if skinsManager.purchasedAirplanes.contains(where: { $0.id == plane.id }) {
                                VStack {
                                    ZStack {
                                        Image("skin_background")
                                        Image(plane.icon)
                                    }
                                    HStack {
                                        Button {
                                            planeManager.plane = plane.id
                                        } label: {
                                            ZStack {
                                                Image("button_background")
                                                Text("SELECT")
                                                    .font(.custom("DamnNoisyKids", size: 18))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .offset(y: -20)
                                }
                            } else {
                                VStack {
                                    ZStack {
                                        Image("skin_background")
                                        Image(plane.icon)
                                    }
                                    HStack {
                                        ZStack {
                                            Image("button_background")
                                            Text("\(plane.price)")
                                                .font(.custom("DamnNoisyKids", size: 18))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Button {
                                            skinsManager.buyAirplane(plane) {
                                                if profileData.points >= plane.price {
                                                    profileData.points -= plane.price
                                                    return true
                                                }
                                                self.errorPurchase = true
                                                return false
                                            }
                                        } label: {
                                            ZStack {
                                                Image("button_background")
                                                Text("BUY")
                                                    .font(.custom("DamnNoisyKids", size: 18))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .offset(y: -20)
                                }
                            }
                        }
                        
                    }
                }
            }
            
            Spacer()
        }
        .background(
            Image("background_game")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $errorPurchase) {
            Alert(title: Text("Error purchase"), message: Text("Not enought points for buy this airplane."), dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    SkinsGameView()
        .environmentObject(PlaneManager())
        .environmentObject(ProfileData())
}
