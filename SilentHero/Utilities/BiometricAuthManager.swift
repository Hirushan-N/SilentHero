import LocalAuthentication

class BiometricAuthManager {
    static let shared = BiometricAuthManager()

    private let context = LAContext()

    /// Check if biometric authentication is available on this device
    func canEvaluatePolicy() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    /// Returns the type of biometric available (Face ID / Touch ID / None)
    func biometricType() -> LABiometryType {
        return context.biometryType
    }

    /// Authenticate the user using biometrics
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let reason = "Authenticate to unlock SilentHero"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    let message = error?.localizedDescription ?? "Authentication failed"
                    completion(false, message)
                }
            }
        }
    }
}
