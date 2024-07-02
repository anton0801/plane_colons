import Foundation


class ProfileData: ObservableObject {
    
    var points: Int {
        didSet {
            UserDefaults.standard.set(points, forKey: "points_profile")
        }
    }
    
    init() {
        points = UserDefaults.standard.integer(forKey: "points_profile")
    }
    
}
