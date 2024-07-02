import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Level
    var gameActions: GameActions
    
    func restartGame() -> GameScene {
        let newGameScene = GameScene(level: level, gameActions: gameActions)
        view?.presentScene(newGameScene)
        return newGameScene
    }
    
    private var points = UserDefaults.standard.integer(forKey: "points_profile") {
        didSet {
            UserDefaults.standard.set(points, forKey: "points_profile")
            pointsLabel.text = "\(points)"
        }
    }
    
    private var planeSrc: String
    private var plane: SKSpriteNode!
    
    private var pointsLabel: SKLabelNode
    
    private var pauseButton: SKSpriteNode!
    private var homeButton: SKSpriteNode!
    
    private var readyButton: SKSpriteNode!
    private var readyLabel: SKLabelNode!
    
    private var gameStarted = false
    private var readyTime = 3 {
        didSet {
            readyLabel.text = "\(readyTime)"
        }
    }
    
    private var isSoundsOn = UserDefaults.standard.bool(forKey: "isSoundOn")
    private var isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
    
    private var distance: Int = 0 {
        didSet {
            distanceLabel.text = "\(distance)/\(level.id * 200) M"
            if distance == level.id * 200 {
                distanceTimer.invalidate()
                spawnColumnSpawner.invalidate()
                spawnCoinSpawner.invalidate()
                gameActions.win()
            }
        }
    }
    
    private var distanceLabel: SKLabelNode
    
    private var spawnColumnSpawner: Timer!
    private var spawnCoinSpawner: Timer!
    private var distanceTimer: Timer!
    
    init(level: Level, gameActions: GameActions) {
        self.gameActions = gameActions
        pointsLabel = SKLabelNode(text: "\(points)")
        distanceLabel = SKLabelNode(text: "0/\(level.id * 200) M")
        self.level = level
        self.planeSrc = UserDefaults.standard.string(forKey: "plane_sel") ?? "plane_normal"
        super.init(size: CGSize(width: 750, height: 1335))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let backgroundImage = SKSpriteNode(imageNamed: "game_image")
        backgroundImage.size = size
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgroundImage)
        
        if isMusicOn {
            let musicBackNode = SKAudioNode(fileNamed: "background_music.mp3")
            backgroundImage.addChild(musicBackNode)
        }
        
        plane = SKSpriteNode(imageNamed: planeSrc)
        plane.position = CGPoint(x: size.width / 2, y: 200)
        plane.name = .plane
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        let planePB = plane.physicsBody!
        planePB.isDynamic = false
        planePB.affectedByGravity = false
        planePB.categoryBitMask = 1
        planePB.collisionBitMask = .both
        planePB.contactTestBitMask = .both
        addChild(plane)
        
        createToolbarContent()
        createReadyContent()
    }
    
    private func createToolbarContent() {
//        pauseButton = .init(imageNamed: "game_pause_button")
//        pauseButton.position = CGPoint(x: size.width - 100, y: size.height - 100)
//        pauseButton.size = CGSize(width: 100, height: 95)
//        addChild(pauseButton)
        
        homeButton = .init(imageNamed: "home_button")
        homeButton.position = CGPoint(x: size.width - 100, y: size.height - 100)
        homeButton.size = CGSize(width: 100, height: 95)
        homeButton.name = .home
        addChild(homeButton)
        
        createBalanceBackground()
        
        pointsLabel.fontName = "DamnNoisyKids"
        pointsLabel.fontSize = 32
        pointsLabel.position = CGPoint(x: 70, y: size.height - 112)
        addChild(pointsLabel)
    }
    
    private func createBalanceBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "balance_label")
        backgroundImage.size = CGSize(width: 200, height: 50)
        backgroundImage.position = CGPoint(x: 100, y: size.height - 100)
        addChild(backgroundImage)
    }
    
    private func createReadyContent() {
        readyButton = .init(imageNamed: "ready_button")
        readyButton.position = CGPoint(x: size.width / 2, y: 75)
        readyButton.name = .readyButton
        addChild(readyButton)
        
        readyLabel = .init(text: "READY?")
        readyLabel.fontName = "DamnNoisyKids"
        readyLabel.fontSize = 72
        readyLabel.fontColor = UIColor.init(red: 48/255, green: 83/255, blue: 173/255, alpha: 1)
        readyLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(readyLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchScreen = touches.first {
            let object = atPoint(touchScreen.location(in: self))
            if object.name == .readyButton {
                startReadyTimer()
            }
            
            if object.name == .home {
                gameActions.toHome()
            }
        }
    }
    
    private func startReadyTimer() {
        readyTime = 3
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.readyTime -= 1
            if self.readyTime == 0 {
                self.readyLabel.text = "GO!"
                timer.invalidate()
                self.startGame()
            }
        }
    }
    
    private func hideReadyContent() {
        let actionFade = SKAction.fadeOut(withDuration: 0.5)
        readyButton.run(actionFade) { self.readyButton.removeFromParent() }
        readyLabel.run(actionFade) { self.readyLabel.removeFromParent() }
        showDistanceLabel()
    }
    
    private func showDistanceLabel() {
        distanceLabel.fontName = "DamnNoisyKids"
        distanceLabel.fontSize = 52
        distanceLabel.fontColor = .white
        distanceLabel.position = CGPoint(x: size.width / 2, y: 50)
        addChild(distanceLabel)
        
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.5)
        distanceLabel.run(actionFadeIn)
    }
    
    private func startGame() {
        gameStarted = true
        distanceTimer = .scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.distance += 1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideReadyContent()
            self.spawnColumn()
            self.startSpawnColumns()
        }
    }
    
    private func startSpawnColumns() {
        let spawnCOlumTimeInverval = 1.5 - Double((level.id / 20))
        self.spawnColumnSpawner = .scheduledTimer(withTimeInterval: spawnCOlumTimeInverval, repeats: true, block: { _ in
            self.spawnColumn()
        })
        self.spawnCoinSpawner = .scheduledTimer(withTimeInterval: spawnCOlumTimeInverval * 2, repeats: true, block: { _ in
            self.spawnCoin()
        })
    }
    
    private func spawnColumn() {
        let directions: ColumnPosition = [.left, .right, .left, .right].randomElement() ?? .left
        let columnXSize = CGFloat.random(in: 200..<400)
        let columnXPos: CGFloat
        let columnNode: SKSpriteNode
        if directions == .left {
            columnXPos = columnXSize / 2
            columnNode = .init(imageNamed: "column_left")
        } else {
            columnXPos = size.width - columnXSize / 2
            columnNode = .init(imageNamed: "column_right")
        }
        columnNode.position = CGPoint(x: columnXPos, y: size.height)
        columnNode.size = CGSize(width: columnXSize, height: 80)
        columnNode.physicsBody = SKPhysicsBody(rectangleOf: columnNode.size)
        columnNode.name = .column
        let columnPB = columnNode.physicsBody!
        columnPB.affectedByGravity = false
        columnPB.isDynamic = true
        columnPB.categoryBitMask = .columnId
        columnPB.collisionBitMask = .planeId
        columnPB.contactTestBitMask = .planeId
        addChild(columnNode)
        
        let actionDown = SKAction.move(to: CGPoint(x: columnXPos, y: -100), duration: TimeInterval(4 - (distance / 200)))
        columnNode.run(actionDown) {
            columnNode.removeFromParent()
        }
    }
    
    private func spawnCoin() {
        let coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode.position = CGPoint(x: CGFloat.random(in: 100..<size.width - 100), y: size.height - 120)
        coinNode.name = .coin
        coinNode.physicsBody = SKPhysicsBody(circleOfRadius: coinNode.size.width / 2)
        let coinPB = coinNode.physicsBody!
        coinPB.categoryBitMask = .coinId
        coinPB.collisionBitMask = .planeId
        coinPB.contactTestBitMask = .planeId
        addChild(coinNode)
        
        let actionDown = SKAction.move(to: CGPoint(x: coinNode.position.x, y: -100), duration: TimeInterval(4 - (distance / 200)))
        coinNode.run(actionDown) {
            coinNode.removeFromParent()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchScreen = touches.first {
            let loc = touchScreen.location(in: self)
            let object = atPoint(loc)
            if gameStarted {
                if object.name == .plane {
                    if loc.x > 50 && loc.x < size.width - 50 {
                        plane.position.x = loc.x
                    }
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == .planeId && bodyB.categoryBitMask == .columnId {
            bodyA.node?.removeFromParent()
            if let particles = SKEmitterNode(fileNamed: "ExpFire") {
                particles.position = CGPoint(x: size.width / 2, y: size.height / 2)
                particles.position = plane.position
                addChild(particles)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    particles.removeFromParent()
                    self.gameActions.lose()
                    self.isPaused = true
                }
            } else {
                self.gameActions.lose()
                isPaused = true
            }
        }
        
        if bodyA.categoryBitMask == .planeId && bodyB.categoryBitMask == .coinId {
            bodyB.node?.removeFromParent()
            points += 100
            if isSoundsOn {
                run(SKAction.playSoundFileNamed("claim_coin.mp3", waitForCompletion: false))
            }
        }
    }
    
}

protocol GameActions {
    func win()
    func lose()
    func pause()
    func toHome()
}

extension String {
    static let plane = "plane"
    static let readyButton = "ready_button"
    static let column = "column"
    static let coin = "coin"
    static let home = "home"
}

extension UInt32 {
    static let planeId: UInt32 = 1
    static let coinId: UInt32 = 2
    static let columnId: UInt32 = 3
    static let both = coinId | columnId
}

enum ColumnPosition {
    case left, right
}
