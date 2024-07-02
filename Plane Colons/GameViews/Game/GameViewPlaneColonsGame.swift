import SwiftUI
import SpriteKit

struct GameViewPlaneColonsGame: View, GameActions {
    
    func win() {
        gameScene = nil
        winGame = true
    }
    
    func lose() {
        gameScene = nil
        loseGame = true
    }
    
    func pause() {
        
    }
    
    func toHome() {
        pressmode.wrappedValue.dismiss()
    }
    
    @Environment(\.presentationMode) var pressmode
    @EnvironmentObject var profileData: ProfileData
    
    var level: Level
    
    @State var gameScene: GameScene!
    
    @State var winGame = false
    @State var loseGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let gameScene = gameScene {
                    SpriteView(scene: gameScene)
                        .ignoresSafeArea()
                }
                
                NavigationLink(destination: GameViewWinStateView()
                    .navigationBarBackButtonHidden(), isActive: $winGame) { }
                NavigationLink(destination: GameViewLoseStateView()
                    .navigationBarBackButtonHidden(), isActive: $loseGame) { }
            }
            .onAppear {
                gameScene = GameScene(level: level, gameActions: self)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RESTART")), perform: { _ in
                gameScene = GameScene(level: level, gameActions: self)
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("EXIT")), perform: { _ in
                pressmode.wrappedValue.dismiss()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GameViewPlaneColonsGame(level: Level(id: 1, name: "1"))
        .environmentObject(ProfileData())
}
