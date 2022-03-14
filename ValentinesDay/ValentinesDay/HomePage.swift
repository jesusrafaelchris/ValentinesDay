//
//  HomePage.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 07/02/2021.
//

import UIKit
import Mapbox
import SideMenuSwift
import Firebase
import SwiftMessages

protocol QRDelegate: AnyObject {
    func giveQRCodeValue(value:String)
}

class HomePage: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, QRDelegate, UITextFieldDelegate{
    
    func giveQRCodeValue(value: String) {
        QRCodeValue = value
        if value == "Clue10" {
            let ref = Firestore.firestore().collection("clues").document(value)
            ref.updateData(["Locked": false])
            FoundAllMessage(clue: value)
        }
        
        else {
            let ref = Firestore.firestore().collection("clues").document(value)
            let lastpathref = Firestore.firestore().collection("last-path").document("Last")
            lastpathref.setData(["last-path":value])
            ref.updateData(["Locked": false])
            demoCentered(clue: value)
            loadGeoJson(cluenumber: value)
        }
    }
    
    var QRCodeValue: String?
    var mapView: MGLMapView?
    var preciseButton: UIButton?
    var purple = UIColor(red: 0.95, green: 0.18, blue: 0.32, alpha: 1.00)
    var points = [ClueStruct]()
    
    lazy var QrButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "qrcode.viewfinder", withConfiguration: largeConfig)?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        button.setImage(largeBoldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        return button
    }()
    
    lazy var PassKeyField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter PassKey.."
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = UITextField.ViewMode.always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 20
        field.layer.masksToBounds = true
        field.backgroundColor = UIColor.white
        field.returnKeyType = .done
        return field
    }()
    
    lazy var LockButton: UIButton = {
        let button = UIButton()
        button.setTitle("🗝️", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        return button
    }()
    
    lazy var TrackButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "location.fill", withConfiguration: largeConfig)?.withTintColor(.gray).withRenderingMode(.alwaysOriginal)
        button.setImage(largeBoldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        return button
    }()
    
    lazy var showCLuesButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "line.horizontal.3", withConfiguration: largeConfig)?.withTintColor(.gray).withRenderingMode(.alwaysOriginal)
        button.setImage(largeBoldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.mapView = mapView
        //mapView.setZoomLevel(20, animated: false)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 51.454514, longitude: -2.587910), zoomLevel: 14, animated: false)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        setupview()
        QrButton.addTarget(self, action: #selector(openQrCamera), for: .touchUpInside)
        TrackButton.addTarget(self, action: #selector(zoomOnUser), for: .touchUpInside)
        showCLuesButton.addTarget(self, action: #selector(menuBarButtomItemTapped), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
        showpoints()
        getLastPath()
        PassKeyField.delegate = self
        doneIntro()
    }
    
    @objc func dismisskeyboard() {
        PassKeyField.resignFirstResponder()
    }
    
    func rearrangeLetters() {
        let titleText = "HARRY POTTER IS DEAD"
        var charIndex = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.PassKeyField.text?.append(letter)
            }
             charIndex += 1
        }
    }
    
    func rearrangeLetters2() {
        let titleText = "I miss you more baby"
        var charIndex = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.PassKeyField.text?.append(letter)
            }
             charIndex += 1
        }
    }
    
    func rearrangeLetters3() {
        let titleText = "I love you so so so so so so so much"
        var charIndex = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.PassKeyField.text?.append(letter)
            }
             charIndex += 1
        }
    }
    
    func CheckKeyPhrase() {
        print("checking")
        let ref = Firestore.firestore().collection("password").document("password")
        ref.getDocument { (snapshot, error) in
            let data = snapshot?.data()
            let password = data?["password"] as! String
            let secretPassword = data?["secretpassword"] as! String
            let loveu = data?["love"] as! String
            if self.PassKeyField.text == password {
                self.PassKeyField.text = ""
                self.rearrangeLetters()
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
                    let treasurePage = TreasurePage()
                    self.navigationController?.pushViewController(treasurePage, animated: true)
                    self.PassKeyField.text = ""
                }
            }
            
            else if self.PassKeyField.text == secretPassword {
                self.PassKeyField.text = ""
                self.rearrangeLetters2()
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
                    self.PassKeyField.text = ""
                }
            }
            
            else if self.PassKeyField.text == loveu {
                self.PassKeyField.text = ""
                self.rearrangeLetters3()
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
                    self.PassKeyField.text = ""
                }
            }
            else {
                self.Message(clue: "I think you typed it wrong.")
            }
        }
    }
    
    func Message(clue: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Whoops", body: clue, iconImage: nil, iconText: "🥶", buttonImage: nil, buttonTitle: "Ok") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func doneIntro() {
        let ref = Firestore.firestore().collection("doneintro").document("doneintro")
        ref.getDocument { (snapshot, error) in
            let data = snapshot?.data()
            let done = data?["done"] as! Bool
            if done == false {
                let swipe = SwipeThroughPage()
                let nav = UINavigationController(rootViewController: swipe)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            }
            else {
               //load the pictures
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        PassKeyField.resignFirstResponder()
        CheckKeyPhrase()
        return true
    }
    
    func getLastPath() {
        let lastpathref = Firestore.firestore().collection("last-path").document("Last")
        lastpathref.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                guard let data = document?.data() else {return}
                guard let last = data["last-path"] as? String else {return}
                self.loadGeoJson(cluenumber: last)
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        DispatchQueue.main.async {
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        }
    }

    @available(iOS 14, *)
    func mapView(_ mapView: MGLMapView, didChangeLocationManagerAuthorization manager: MGLLocationManager) {
        guard let accuracySetting = manager.accuracyAuthorization?() else { return }

        if accuracySetting == .reducedAccuracy {
            addPreciseButton()
        } else {
            removePreciseButton()
        }
    }
    

    @available(iOS 14, *)
    func addPreciseButton() {
        let preciseButton = UIButton(frame: CGRect.zero)
        preciseButton.setTitle("Turn Precise On", for: .normal)
        preciseButton.backgroundColor = .gray

        preciseButton.addTarget(self, action: #selector(requestTemporaryAuth), for: .touchDown)
        self.view.addSubview(preciseButton)
        self.preciseButton = preciseButton

        // constraints
        preciseButton.translatesAutoresizingMaskIntoConstraints = false
        preciseButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        preciseButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        preciseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        preciseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @available(iOS 14, *)
    @objc private func requestTemporaryAuth() {
        guard let mapView = self.mapView else { return }

        let purposeKey = "MGLAccuracyAuthorizationDescription"
        mapView.locationManager.requestTemporaryFullAccuracyAuthorization!(withPurposeKey: purposeKey)
    }

    private func removePreciseButton() {
        guard let button = self.preciseButton else { return }
        button.removeFromSuperview()
        self.preciseButton = nil
    }
    
    func FoundAllMessage(clue: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Yay!", body: "You found all the clues!\n Put the keyphrases from each clue into the textbar\n to claim your prize!", iconImage: nil, iconText: "🎉", buttonImage: nil, buttonTitle: "Ok") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func demoCentered(clue: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Yay!", body: "You found a clue!\n Solve it to find the next one", iconImage: nil, iconText: "🕵️", buttonImage: nil, buttonTitle: "Ok") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func setupview() {
        view.addSubview(QrButton)
        view.addSubview(TrackButton)
        view.addSubview(showCLuesButton)
        view.addSubview(LockButton)
        view.addSubview(PassKeyField)
        
        NSLayoutConstraint.activate([
            
            LockButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            LockButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            LockButton.widthAnchor.constraint(equalToConstant: 50),
            LockButton.heightAnchor.constraint(equalToConstant: 50),
            
            PassKeyField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            PassKeyField.leftAnchor.constraint(equalTo: LockButton.rightAnchor, constant: 20),
            PassKeyField.widthAnchor.constraint(equalToConstant: 300),
            PassKeyField.heightAnchor.constraint(equalToConstant: 50),
            
            QrButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            QrButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            QrButton.widthAnchor.constraint(equalToConstant: 70),
            QrButton.heightAnchor.constraint(equalToConstant: 70),
            
            TrackButton.bottomAnchor.constraint(equalTo: QrButton.topAnchor, constant: -30),
            TrackButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            TrackButton.widthAnchor.constraint(equalToConstant: 50),
            TrackButton.heightAnchor.constraint(equalToConstant: 50),
            
            showCLuesButton.bottomAnchor.constraint(equalTo: QrButton.topAnchor, constant: -30),
            showCLuesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            showCLuesButton.widthAnchor.constraint(equalToConstant: 50),
            showCLuesButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func openQrCamera() {
        let qr = QrCode()
        qr.delegate = self
        self.present(qr, animated: true, completion: nil)
    }
    
    @objc func zoomOnUser() {
        
        mapView?.showsUserLocation = true
        mapView?.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        
    }
    
    @objc func menuBarButtomItemTapped() {
        sideMenuController?.revealMenu(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func getPoints() {
    
        let docref = Firestore.firestore().collection("clues").order(by: "number")
        docref.getDocuments { (snapshot, error) in
            self.points.removeAll()
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                let cluestruct = ClueStruct()
                cluestruct.Cluename = document.documentID
                let islocked = data["Locked"] as! Bool
                let Latitude = data["Latitude"] as! NSNumber
                let Longitude = data["Longitude"] as! NSNumber
                cluestruct.Latitude = Latitude
                cluestruct.Longitude = Longitude
                cluestruct.islocked = islocked
                self.points.append(cluestruct)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
        return nil
        }
         
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
         
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
         
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
        annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
        annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        annotationView!.backgroundColor = .clear
        }
         
        return annotationView
    }
    
    func showpoints() {
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: 51.47732190791656, longitude: -2.6000862312711153),
            CLLocationCoordinate2D(latitude: 51.46742681842741, longitude: -2.598496613656594),
            CLLocationCoordinate2D(latitude: 51.4736185470348, longitude: -2.605930292520033),
            CLLocationCoordinate2D(latitude: 51.464251246987295, longitude: -2.6104754561791803),
            CLLocationCoordinate2D(latitude: 51.457078935129566, longitude: -2.6086913732519545),
            CLLocationCoordinate2D(latitude: 51.46599783856721, longitude: -2.616847180934972),
            CLLocationCoordinate2D(latitude: 51.46149890630267, longitude: -2.6212649100881014),
            CLLocationCoordinate2D(latitude: 51.46313974474589, longitude: -2.6241959035031504),
            CLLocationCoordinate2D(latitude: 51.45501437066381, longitude: -2.619141001911581),
            CLLocationCoordinate2D(latitude: 51.45593614751162, longitude: -2.6246432121677423),

        ]
        
        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in coordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
                
                let ref = Firestore.firestore().collection("clues").order(by: "number").whereField("Latitude", isEqualTo: coordinate.latitude)
                
            ref.addSnapshotListener({ (snapshot, error) in
                    guard let documents = snapshot?.documents else {return}
                    for document in documents {
                        let data = document.data()
                        let islocked = data["Locked"] as! Bool
                        let name = document.documentID
                        point.title = "\(name)"
                        if islocked == false {
                            print("not locked")
                            pointAnnotations.append(point)
                            self.mapView?.addAnnotations(pointAnnotations)

                        }
                        else {
                            print("locked")
                            //pointAnnotations.append(point)
                        }
                    }
                })
            }
        }
    
    func loadGeoJson(cluenumber: String) {
        DispatchQueue.global().async {
            
            if cluenumber == "Clue10" {
                print("Clue10")
            }
            
            else {
                guard let jsonUrl = Bundle.main.url(forResource: "\(cluenumber)", withExtension: "geojson") else {
                preconditionFailure("Failed to load local GeoJSON file")
                    }
                 
                guard let jsonData = try? Data(contentsOf: jsonUrl) else {
                preconditionFailure("Failed to parse GeoJSON file")
                    }
                 
                DispatchQueue.main.async {
                self.drawPolyline(geoJson: jsonData, identifier: cluenumber)
                    }
            }
        }
    }
     
    func drawPolyline(geoJson: Data, identifier: String) {

        guard let style = self.mapView?.style else { return }
         
        guard let shapeFromGeoJSON = try? MGLShape(data: geoJson, encoding: String.Encoding.utf8.rawValue) else {
        fatalError("Could not generate MGLShape")
        }
         
        let source = MGLShapeSource(identifier: identifier, shape: shapeFromGeoJSON, options: nil)
        style.addSource(source)
         
        let layer = MGLLineStyleLayer(identifier: identifier, source: source)
         
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
         
        layer.lineColor = NSExpression(forConstantValue: UIColor.systemRed)
         

        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
        [14: 2, 18: 20])
        
        style.addLayer(layer)

        }
    }
    
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
    super.layoutSubviews()
     
    // Use CALayer’s corner radius to turn this view into a circle.
        let bezierPath = UIBezierPath(heartIn: self.bounds)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        //shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.red.cgColor
        //shapeLayer.lineWidth = 3
                
        layer.addSublayer(shapeLayer)

    }
     
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()

        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2

        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)

        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))

        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)

        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))

        //Left Bottom Line
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
