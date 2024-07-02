import Foundation

class PlaneManager: ObservableObject {
    
    @Published var plane: String {
        didSet {
            UserDefaults.standard.set(plane, forKey: "plane_sel")
        }
    }
    
    init() {
        plane = UserDefaults.standard.string(forKey: "plane_sel") ?? ""
        if plane.isEmpty {
            plane = "plane_normal"
        }
    }
    
}
