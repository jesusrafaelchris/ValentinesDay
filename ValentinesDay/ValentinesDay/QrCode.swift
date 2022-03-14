//
//  QrCode.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 07/02/2021.
//

import AVFoundation
import UIKit

class QrCode: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: QRDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var QRText: UILabel = {
        let Text = UILabel()
        Text.text = "Scan QR Code for next clue"
        Text.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        Text.textColor = .white
        Text.translatesAutoresizingMaskIntoConstraints = false
        return Text
    }()
    
    lazy var FlashButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "flashlight.off.fill", withConfiguration: largeConfig)?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.setImage(largeBoldDoc, for: .normal)
        button.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        setupView()
        captureSession.startRunning()
        FlashButton.addTarget(self, action: #selector(Flash), for: .touchUpInside)
        containerView.frame = CGRect(x: view.frame.width/2 - 100, y: view.frame.height/2 - 100, width: 200, height: 200)
        view.addSubview(containerView)
        
        drawRectangle()
    }
    
    private func drawRectangle() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        
        containerView.layer.addSublayer(shapeLayer)
    }
    
    @objc func Flash() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if ((device?.hasTorch) != nil) {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try device?.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        if let delegate = self.delegate {
            delegate.giveQRCodeValue(value: code)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setupView() {
        view.addSubview(QRText)
        view.addSubview(FlashButton)
    
        NSLayoutConstraint.activate([
            
            QRText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            QRText.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            FlashButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            FlashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            FlashButton.widthAnchor.constraint(equalToConstant: 40),
            FlashButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
