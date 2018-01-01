# Video Feature Observable

**Goals:**

- Use the iOS camera to fetch image features such as QRCode and Rectangle
- Explore the Vision Framework
- Build a camera object using the AVFoundation framework

**Tools:**
- [AVFoundation](https://developer.apple.com/av-foundation/)
- [Vision](https://developer.apple.com/documentation/vision)


## Installation

`git clone https://github.com/ismalakazel/VideoFeatureObservable`

## Usage

Initialize a `Camera` object to output sample buffers from the iOS camera.

```swift

var camera = Camera?

...

do {
    // Initialize Camera
    try camera = Camera()
    
    // Set AVCaptureVideoDataOutputSampleBufferDelegate
    camera?.delegate = self
    
    // Set camera output preview UIView
    camera?.setPreviewLayer(for: view)
    
    // Start outputing sample buffers
    camera?.session.startRunning()
} catch {
    // Handle exception
}
```

Inherit from AVCaptureVideoDataOutputSampleBufferDelegate to get the outputed sample buffers.

```swift
extension MyViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Create CIImage from sample buffer
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let image = CIImage(cvPixelBuffer: pixelbuffer, options: nil)
        
        // Fetch features from image
        fetchFeatures(from: image)
    }
}
```

Finally, implement either `BarCodeObservable` or `RectangleObservable` protocol to handle the callback from `fetchFeatures` function

```swift
extension MyViewController: BarCodeObservable {
  func didFindCode(value: String) {
      
      // Stop camera session and future observation requests
      camera?.session.stopRunning()
      
      // Barcode value
      print(value)
  }
}
```

Full example can be see in `Example/ExampleVideoFeatureViewController.swift`
