
import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

/// The available states of being logged in or not.
enum AuthenticationState {
    case loggedin, loggedout
}

class BiometricIDAuth {
    
  let context = LAContext()
  var loginReason = "Logging in with Touch ID"
    /// The current authentication state.
    var state = AuthenticationState.loggedout {
        // Update the UI on a change.
        didSet {
        }
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .none
        }
    }

  func canEvaluateBiometricsPolicy() -> Bool {
     return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }
    
  func canEvaluateOwnerAuthenticationPolicy() -> Bool {
      return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
  }
    
  func authenticateUser(completion: @escaping (Bool) -> Void) {
    guard canEvaluateBiometricsPolicy() else {
        self.authenticateDevicePassCode { (isSuccess) in
            completion(isSuccess)
        }
        return
    }
    
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
      if success {
        DispatchQueue.main.async {
          // User authenticated successfully, take appropriate action
          completion(true)
        }
      } else {
        let message: String
        switch evaluateError {
        case LAError.authenticationFailed?:
          message = "There was a problem verifying your identity."
        case LAError.userCancel?:
          message = "You pressed cancel."
        case LAError.userFallback?:
          message = "You pressed password."
        case LAError.biometryNotAvailable?:
          message = "Face ID/Touch ID is not available."
        case LAError.biometryNotEnrolled?:
          message = "Face ID/Touch ID is not set up."
        case LAError.biometryLockout?:
          message = "Face ID/Touch ID is locked."
        default:
          message = "Face ID/Touch ID may not be configured"
        }
        FSLogInfo("\(message)")
        completion(false)
        }
    }
  }
    
    func authenticateDevicePassCode(completion: @escaping (Bool) -> Void) {
        guard canEvaluateOwnerAuthenticationPolicy() else {
            completion(false)
            return
        }
        // Get a fresh context for each login. If you use the same context on multiple attempts
        //  (by commenting out the next line), then a previously successful authentication
        //  causes the next policy evaluation to succeed without testing biometry again.
        //  That's usually not what you want.
        
        context.localizedCancelTitle = "Enter Username/Password"
        let reason = "Log in to your account"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    // User authenticated successfully, take appropriate action
                    completion(true)
                }
            } else {
                let message: String
                switch evaluateError {
                case LAError.authenticationFailed?:
                    message = "There was a problem verifying your identity."
                case LAError.userCancel?:
                    message = "You pressed cancel."
                case LAError.userFallback?:
                    message = "You pressed password."
                case LAError.passcodeNotSet?:
                    message = "You have not set password."
                case LAError.notInteractive?:
                    message = "Not interactive"
                default:
                    message = "Face ID/Touch ID may not be configured"
                }
                completion(false)
                  FSLogInfo("\(message)")
            }
        }
    }
}
