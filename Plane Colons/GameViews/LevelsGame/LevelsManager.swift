import Foundation

struct Level: Identifiable {
    let id: Int
    let name: String
}

class LevelsManager: ObservableObject {
    @Published var availableLevels: [Level] = []
    
    @Published var unlockedLevels: [Level] = []

    private let unlockedLevelsKey = "unlockedLevels"

    init() {
        for i in 1...12 {
            availableLevels.append(Level(id: i, name: "\(i)"))
        }
        loadUnlockedLevels()
        if unlockedLevels.isEmpty {
            unlockLevel(availableLevels[0])
        }
    }

    func unlockLevel(_ level: Level) {
        unlockedLevels.append(level)
        saveUnlockedLevels()
    }

    private func saveUnlockedLevels() {
        let ids = unlockedLevels.map { $0.id }
        UserDefaults.standard.set(ids, forKey: unlockedLevelsKey)
    }

    private func loadUnlockedLevels() {
        if let savedIds = UserDefaults.standard.array(forKey: unlockedLevelsKey) as? [Int] {
            let unlocked = availableLevels.filter { savedIds.contains($0.id) }
            unlockedLevels = unlocked
        }
    }
}
