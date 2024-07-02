import SwiftUI

struct MenuView: View {
    
    @StateObject var profileData = ProfileData()
    @StateObject var planeManager = PlaneManager()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        Image("balance_label")
                        Text("\(profileData.points)")
                            .font(.custom("DamnNoisyKids", size: 24))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                
                Text("Plane Colons")
                    .font(.custom("DamnNoisyKids", size: 42))
                    .foregroundColor(Color.init(red: 48/255, green: 83/255, blue: 173/255))
                    .padding(.top, 42)
                
                Spacer()
                
                ZStack {
                    Image("values_back")
                    
                    VStack {
                        NavigationLink(destination: LevelsGameView()
                            .environmentObject(profileData)
                            .navigationBarBackButtonHidden(true)) {
                            Image("play_button")
                        }
                        NavigationLink(destination: SkinsGameView()
                            .environmentObject(planeManager)
                            .environmentObject(profileData)
                            .navigationBarBackButtonHidden(true)) {
                            Image("shop_button")
                        }
                        .padding(.top)
                        NavigationLink(destination: OptionsGameView()
                            .environmentObject(profileData)
                            .navigationBarBackButtonHidden(true)) {
                            Image("settings_button")
                        }
                        .padding(.top)
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

#Preview {
    MenuView()
}
