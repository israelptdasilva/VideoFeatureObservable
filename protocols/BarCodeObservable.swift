import Vision
import UIKit


/// Protocol that fetches VNBarcodeObservation. Conforms to VideoFeatureObservable.
protocol BarCodeObservable: VideoFeatureObservable {
    func didFindCode(value: String)
}


extension VideoFeatureObservable where Self: BarCodeObservable {
    
    var request: [VNRequest] {
        let request = VNDetectBarcodesRequest(completionHandler: completionHandler)
        return [request]
    }
    
    func completionHandler(request: VNRequest, error: Error?) {
        request.results?.first.flatMap{ o in
            if let o = o as? VNBarcodeObservation {
                o.payloadStringValue.flatMap(didFindCode)
            }
        }
    }
}
