import Foundation


/// Camera error cases
enum CameraError: Error {
    
    /// Cannot load media type from device
    case media
    
    /// Cannot add configuration to session
    case configuration
    
    // Error description
    var localizedDescription: String {
        switch self {
        case .media: return "cannot load video camera on this device."
        case .configuration: return "cannot load video camera with required configurations"
        }
    }
}
