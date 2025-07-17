import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showMainView = false
    @State private var loginViewScale: CGFloat = 0
    @State private var logoOffset: CGFloat = 0
    @State private var fieldsOpacity: Double = 0
    @StateObject private var alertManager = AlertManager()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 30) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .offset(y: logoOffset)
                        .animation(.easeInOut(duration: 0.8).delay(0.2), value: logoOffset)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            TextField("邮箱", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .opacity(fieldsOpacity)
                        .animation(.easeInOut(duration: 0.8).delay(0.6), value: fieldsOpacity)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            SecureField("密码", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .opacity(fieldsOpacity)
                        .animation(.easeInOut(duration: 0.8).delay(0.7), value: fieldsOpacity)
                        
                        Button(action: handleLogin) {
                            Text("登录")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .opacity(fieldsOpacity)
                        .animation(.easeInOut(duration: 0.8).delay(0.8), value: fieldsOpacity)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(30)
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .scaleEffect(loginViewScale)
                .animation(.spring(response: 0.8, dampingFraction: 0.5).delay(0.3), value: loginViewScale)
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            startAnimations()
        }
        .alert(alertManager.alertTitle, isPresented: $alertManager.showAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(alertManager.alertMessage)
        }
        .fullScreenCover(isPresented: $showMainView) {
            MainTabView()
        }
    }
    
    private func startAnimations() {
        loginViewScale = 1.0
        logoOffset = -20
        fieldsOpacity = 1.0
    }
    
    private func handleLogin() {
        let userRequest = SignInUserRequest(
            email: username,
            password: password
        )
        
        if !Validator.isValidEmail(for: userRequest.email) {
            alertManager.showInvalidEmailAlert()
            return
        }
        
        if !Validator.isPasswordValid(for: userRequest.password) {
            alertManager.showInvalidPasswordAlert()
            return
        }
        
        showMainView = true
    }
} 