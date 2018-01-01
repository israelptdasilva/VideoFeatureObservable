import UIKit
import AVFoundation
import CoreData


/// A UIViewController that fetches barcode features from video output
class ExampleVideoFeatureViewController: UIViewController {
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            do {
                // Initialize Camera
                try self.camera = Camera()
                self.camera?.delegate = self
                self.camera?.setPreviewLayer(for: self.view)
                self.camera?.session.startRunning()
            } catch {
                // TODO: Handle error
            }
        }
    }
    
    deinit {
        // Stop camera session and future observation requests
        camera?.session.stopRunning()
    }
    
    /// The camera object with video capabilities
    private(set) var camera: Camera?
}

// MARK: - BarCodeObservable

extension ExampleVideoFeatureViewController: BarCodeObservable {
    func didFindCode(value: String) {
        // Stop camera session and future observation requests
        camera?.session.stopRunning()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ExampleVideoFeatureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Create CIImage from sample buffer
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let image = CIImage(cvPixelBuffer: pixelbuffer, options: nil)
        
        // Fetch BarCode features from camera preview output
        fetchFeatures(from: image)
    }
}

