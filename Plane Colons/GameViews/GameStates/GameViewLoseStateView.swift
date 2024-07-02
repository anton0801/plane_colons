import SwiftUI

struct GameViewLoseStateView: View {
    
    @Environment(\.presentationMode) var pressmode
    
    var body: some View {
        VStack {
            Text("LOSE!")
                .font(.custom("DamnNoisyKids", size: 42))
                .foregroundColor(Color.init(red: 48/255, green: 83/255, blue: 173/255))
                .padding(.top, 42)
            
            Spacer()
            
            ZStack {
                Image("values_back")
                
                VStack {
                    Text("TRY AGAIN!")
                        .font(.custom("DamnNoisyKids", size: 30))
                        .foregroundColor(.white)
                    
                    Button {
                        pressmode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            NotificationCenter.default.post(name: Notification.Name("RESTART"), object: nil)
                        }
                    } label: {
                        ZStack {
                            Image("button_background")
                                .resizable()
                                .frame(width: 200, height: 50)
                            Text("RESTART")
                                .font(.custom("DamnNoisyKids", size: 30))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        pressmode.wrappedValue.dismiss()
                        NotificationCenter.default.post(name: Notification.Name("EXIT"), object: nil)
                    } label: {
                        ZStack {
                            Image("button_background")
                                .resizable()
                                .frame(width: 200, height: 50)
                            Text("EXIT")
                                .font(.custom("DamnNoisyKids", size: 30))
                                .foregroundColor(.white)
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
    }
    
}

#Preview {
    GameViewLoseStateView()
}
