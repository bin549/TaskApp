import Foundation
import SwiftUI

struct ToDo: Identifiable, Codable {
    let id: Int
    var title: String
    var status: Bool
    
    init(id: Int, title: String, status: Bool = false) {
        self.id = id
        self.title = title
        self.status = status
    }
}

struct SignInUserRequest {
    let email: String
    let password: String
}

struct TouchPointsAndColor {
    var color: UIColor?
    var width: CGFloat?
    var opacity: CGFloat?
    var points: [CGPoint]?
    
    init(color: UIColor, points: [CGPoint]?) {
        self.color = color
        self.points = points
    }
}

struct DrawingLine: Identifiable {
    let id = UUID()
    var points: [CGPoint] = []
    var color: Color = .black
    var width: CGFloat = 1.0
    var opacity: Double = 1.0
} 