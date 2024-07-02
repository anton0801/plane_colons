import Foundation

struct Plane: Identifiable {
    let id: String
    let icon: String
    let price: Int
}

class SkinsManager: ObservableObject {
    @Published var availableAirplanes: [Plane] = [
        Plane(id: "plane_normal", icon: "plane_normal", price: 0),
        Plane(id: "plane_second", icon: "plane_second", price: 10000),
        Plane(id: "plane_third", icon: "plane_third", price: 30000)
    ]
    
    @Published var purchasedAirplanes: [Plane] = []

    private let purchasedAirplanesKey = "purchasedAirplanes"

    init() {
        loadPurchasedAirplanes()
        if purchasedAirplanes.isEmpty {
            buyAirplane(availableAirplanes[0]) {
                return true
            }
        }
    }

    func buyAirplane(_ airplane: Plane, predicate: @escaping () -> Bool) {
        let predResult = predicate()
        if predResult {
            purchasedAirplanes.append(airplane)
            savePurchasedAirplanes()
        }
    }

    private func savePurchasedAirplanes() {
        let ids = purchasedAirplanes.map { $0.id }
        UserDefaults.standard.set(ids, forKey: purchasedAirplanesKey)
    }

    private func loadPurchasedAirplanes() {
        if let savedIds = UserDefaults.standard.array(forKey: purchasedAirplanesKey) as? [String] {
            let purchased = availableAirplanes.filter { savedIds.contains($0.id) }
            purchasedAirplanes = purchased
        }
    }
    
}
