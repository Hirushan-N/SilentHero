import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @AppStorage("token") private var token: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("SilentHero Login")
                    .font(.title)
                    .bold()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: login) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Log In")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                
                Spacer()
            }
            .padding()
        }
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        // Simulate network call to .NET API with hardcoded success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if email == "user@example.com" && password == "password" {
                self.token = "mock-jwt-token-1234567890"
                self.isLoggedIn = true
            } else {
                self.errorMessage = "Invalid email or password."
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
}
