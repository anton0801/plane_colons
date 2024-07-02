import SwiftUI

struct OptionsGameView: View {
    
    @Environment(\.presentationMode) var pressmode
    @StateObject private var soundSettings = SoundSettings()
    @EnvironmentObject var profileData: ProfileData

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
            }
            
            Text("Plane Colons")
                .font(.custom("DamnNoisyKids", size: 42))
                .foregroundColor(Color.init(red: 48/255, green: 83/255, blue: 173/255))
                .padding(.top, 42)
            
            Spacer()
            
            ZStack {
                Image("values_back")
                
                VStack {
                    Text("SOUNDS")
                        .font(.custom("DamnNoisyKids", size: 32))
                        .foregroundColor(.white)
                    Button(action: {
                       soundSettings.isSoundOn.toggle()
                   }) {
                       ZStack(alignment: .leading) {
                           Image("setting_field_item")
                              .resizable()
                              .frame(width: 200, height: 30)
                           
                           if soundSettings.isSoundOn {
                               Image("setting_circle")
                                    .offset(x: 173)
                           } else {
                               Image("setting_circle")
                                    .offset(x: 5)
                           }
                       }
                   }
                    
                    Text("Music")
                        .font(.custom("DamnNoisyKids", size: 32))
                        .foregroundColor(.white)
                    Button(action: {
                       soundSettings.isMusicOn.toggle()
                   }) {
                       ZStack(alignment: .leading) {
                           Image("setting_field_item")
                              .resizable()
                              .frame(width: 200, height: 30)
                           
                           if soundSettings.isMusicOn {
                               Image("setting_circle")
                                    .offset(x: 173)
                           } else {
                               Image("setting_circle")
                                    .offset(x: 5)
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
    
}

class SoundSettings: ObservableObject {
    @Published var isSoundOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")
        }
    }
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isMusicOn")
        }
    }
    
    init() {
        self.isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
    }
}

#Preview {
    OptionsGameView()
        .environmentObject(ProfileData())
}
