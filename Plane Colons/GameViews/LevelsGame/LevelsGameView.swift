import SwiftUI

struct LevelsGameView: View {
    
    @Environment(\.presentationMode) var pressmode
    @StateObject var levelsManager = LevelsManager()
    @EnvironmentObject var profileData: ProfileData
    
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
                
                Text("LEVELS")
                    .font(.custom("DamnNoisyKids", size: 42))
                    .foregroundColor(Color.init(red: 48/255, green: 83/255, blue: 173/255))
                    .padding(.top, 42)
                
                Spacer()
                
                ZStack {
                    Image("values_back")
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(70)),
                        GridItem(.fixed(70)),
                        GridItem(.fixed(70))
                    ]) {
                        ForEach(levelsManager.availableLevels, id: \.id) { level in
                            if levelsManager.unlockedLevels.contains(where: { $0.id == level.id }) {
                                NavigationLink(destination: GameViewPlaneColonsGame(level: level)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(profileData)) {
                                    ZStack {
                                        Image("unlocked_level_back")
                                        Text("\(level.id)")
                                            .font(.custom("DamnNoisyKids", size: 24))
                                            .foregroundColor(.white)
                                    }
                                }
                            } else {
                                ZStack {
                                    Image("disabled_level_back")
                                    Text("\(level.id)")
                                        .font(.custom("DamnNoisyKids", size: 24))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                
                Button {
                      pressmode.wrappedValue.dismiss()
                  } label: {
                      Image("back_button")
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
    LevelsGameView()
        .environmentObject(ProfileData())
}
