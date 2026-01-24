import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String?
    @Binding var inlineErrorMsg: String?
    @Binding var alertErrorMsg: String?
    @Binding var isFlashOn: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = context.coordinator.captureSession
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            DispatchQueue.main.async {
                self.alertErrorMsg = "Camera access error"
            }
            return viewController
        }
        
        guard let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            DispatchQueue.main.async {
                self.alertErrorMsg = "Camera input error"
            }
            return viewController
        }
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else {
            DispatchQueue.main.async {
                self.alertErrorMsg = "Camera input error"
            }
            return viewController
        }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(context.coordinator, queue: .main)
        output.metadataObjectTypes = [.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = viewController.view.bounds
        viewController.view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        
        DispatchQueue.main.async {
            let scanRect = CGRect(x: (viewController.view.bounds.width - 250) / 2, y: (viewController.view.bounds.height - 250) / 2,
                                  width: 250,
                                  height: 250
            )
            output.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.toggleTorch(on: isFlashOn)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
        coordinator.captureSession.stopRunning()
    }
    
    class Coordinator: NSObject, @preconcurrency AVCaptureMetadataOutputObjectsDelegate {
        
        let captureSession = AVCaptureSession()
        let parent: ScannerView
        private var isProcessing = false
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        @MainActor
        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            guard !isProcessing else { return }
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let value = metadataObject.stringValue else { return }
            
            isProcessing = true
            
            if !value.localizedCaseInsensitiveContains("fastago") {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                parent.inlineErrorMsg = "Invalid QR Code. Please scan a Fastago scooter QR."
                
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    parent.inlineErrorMsg = nil
                    isProcessing = false
                }
                return
            }
            
            captureSession.stopRunning()
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            parent.inlineErrorMsg = nil
            
            parent.scannedCode = value
        }
        
        @MainActor
        func toggleTorch(on: Bool) {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }
            
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch {
                parent.alertErrorMsg = "Flash could not be used"
            }
        }
    }
    
}
