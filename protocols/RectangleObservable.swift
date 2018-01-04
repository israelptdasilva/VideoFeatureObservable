import AVFoundation
import Vision
import UIKit


/// Protocol that fetches VNRectangleObservation. Conforms to VideoFeatureObservable.
protocol RectangleObservable: VideoFeatureObservable {
    func didFindRectangle(box: CGRect)
}


extension VideoFeatureObservable where Self: RectangleObservable {
    var request: [VNRequest] {
        let request = VNDetectRectanglesRequest(completionHandler: completionHandler)
        request.minimumAspectRatio = 0.8
        request.minimumSize = 0.28
        return [request]
    }
    
    func completionHandler(request: VNRequest, error: Error?) {
        request.results?.first.flatMap{ o in
            if let o = o as? VNRectangleObservation, o.confidence >= 0.8 , let rect = self.camera?.preview.layerRectConverted(fromMetadataOutputRect: o.boundingBox) {
                didFindRectangle(box: rect)
            }
        }
    }
}
