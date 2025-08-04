import SwiftUI

struct Validator {
    static func isValidEmail(for email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isPasswordValid(for password: String) -> Bool {
        return !password.isEmpty && password.count >= 1
    }
}

class AlertManager: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func showInvalidEmailAlert() {
        alertTitle = "无效邮箱"
        alertMessage = "请输入正确格式的邮箱."
        showAlert = true
    }
    
    func showInvalidPasswordAlert() {
        alertTitle = "无效密码"
        alertMessage = "密码不为空."
        showAlert = true
    }
}

extension Color {
    static let customTeal = Color(.systemTeal)
    static let customBackground = Color(.systemBackground)
    static let customSecondary = Color(.secondarySystemBackground)
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
} 