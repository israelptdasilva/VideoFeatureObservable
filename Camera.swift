import AVFoundation
import UIKit


/// A bootstrap of an AVCaptureSession that captures frame buffers from the iOS camera.
struct Camera {
    
    /// AVCaptureSession with video capture settings
    let session: AVCaptureSession!
    
    /// A layer that previews the current session output
    let preview: AVCaptureVideoPreviewLayer!
    
    /// A class complaint to AVCaptureVideoDataOutputSampleBufferDelegate protocol
    weak var delegate: AVCaptureVideoDataOutputSampleBufferDelegate? {
        didSet {
            videoOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "cam.session"))
        }
    }
    
    /**
     Camera initializer
     - parameter delegate: A class complaint to the AVCaptureVideoDataOutputSampleBufferDelegate protocol
     - parameter superview: A UIView where the preview layer can be inserted into
     - throws: CameraError
     */
    init() throws {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), let input = try? AVCaptureDeviceInput(device: device) else {
            throw CameraError.media
        }
        
        // Device configuration
        try! input.device.lockForConfiguration()
        input.device.autoFocusRangeRestriction = .near
        
        // Video data output configuration
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.connections.first?.videoOrientation = .portrait
        videoOutput.connections.first?.preferredVideoStabilizationMode = .auto

        // Photo data output configuration
        photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        
        // Session configuration
        session = AVCaptureSession()

        guard session.canAddInput(input), session.canAddOutput(videoOutput), session.canSetSessionPreset(AVCaptureSession.Preset.high) else {
                throw CameraError.configuration
        }
        
        session.addInput(input)
        session.addOutput(videoOutput)
        session.addOutput(photoOutput)
        session.sessionPreset = AVCaptureSession.Preset.high
        
        // Session preview layer
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspect
    }
    
    /**
     Takes a snapshot of the current frame buffer
     - parameter delegate: The class complaint to AVCapturePhotoCaptureDelegate protocol
    */
    func takeSnapshot(delegate: AVCapturePhotoCaptureDelegate) {
        
        // Photo settings
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: self.preview.bounds.height,
                             kCVPixelBufferHeightKey as String: self.preview.bounds.width] as [String : Any]
        settings.previewPhotoFormat = previewFormat
        settings.flashMode = .off
        
        // Take snapshot
        photoOutput.capturePhoto(with: settings, delegate: delegate)
    }
    
    /**
     Inserts the preview layer in a UIView
     - parameter view: The UIView where the preview layer will be inserted into
    */
    func setPreviewLayer(for view: UIView) {
        // Update preview frame
        preview.frame = view.bounds
        
        // Insert preview layer into view
        view.layer.insertSublayer(preview, at: 0)
    }
    
    /// The video data output used in the session
    private let videoOutput: AVCaptureVideoDataOutput!
    
    /// The photo data output used in the session
    private let photoOutput: AVCapturePhotoOutput!
}
