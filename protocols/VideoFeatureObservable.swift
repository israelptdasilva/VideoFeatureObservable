import AVFoundation
import Vision
import UIKit


/// Protocol that fetches features from camera of type video
protocol VideoFeatureObservable {
    
    /// A Camera object that is capable of capturing video
    var camera: Camera? { get }
    
    /// An array of feature requests
    var request: [VNRequest] { get }
    
    /**
     The completion handler of the request
     - parameter request: The VNRequest containing the observations
     - parameter error: The request Error
     */
    func completionHandler(request: VNRequest, error: Error?)
}


extension VideoFeatureObservable {
    /// Fetch feature with [VNImageRequest]
    func fetchFeatures(from image: CIImage) {
        try? VNImageRequestHandler(ciImage: image, options: [:]).perform(request)
    }
}
