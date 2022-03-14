//
//  FourthPage.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 07/02/2021.
//

import UIKit
import Firebase

class FourthPage: UIViewController {
    
    lazy var colourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.21, green: 0.74, blue: 0.26, alpha: 1.00)
        return view
    }()
    
    lazy var GetStartedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var HelpText: UILabel = {
        let HelpText = UILabel()
        HelpText.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        HelpText.textColor = .white
        HelpText.translatesAutoresizingMaskIntoConstraints = false
        HelpText.numberOfLines = 0
        HelpText.text = """
                           Once you have all pieces
                           of the password input them
                           into the bar and unlock the
                           treasure.
                        """
        return HelpText
    }()
    
    lazy var Image: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "map", withConfiguration: largeConfig)?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        button.setImage(largeBoldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        //button.backgroundColor = UIColor.white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.88, green: 0.97, blue: 0.84, alpha: 1.00)
        setupView()
        GetStartedButton.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
    }
    
    @objc func dismissPage() {
        let ref = Firestore.firestore().collection("doneintro").document("doneintro")
        ref.updateData(["done":true])
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        view.addSubview(colourView)
        view.addSubview(GetStartedButton)
        view.addSubview(HelpText)
        view.addSubview(Image)
        
        NSLayoutConstraint.activate([
            
            Image.centerXAnchor.constraint(equalTo: colourView.centerXAnchor),
            Image.topAnchor.constraint(equalTo: view.topAnchor,constant: 200),
            
            colourView.topAnchor.constraint(equalTo: view.centerYAnchor),
            colourView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            colourView.rightAnchor.constraint(equalTo: view.rightAnchor),
            colourView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            HelpText.topAnchor.constraint(equalTo: view.centerYAnchor),
            //HelpText.rightAnchor.constraint(equalTo: view.rightAnchor),
            HelpText.widthAnchor.constraint(equalTo: view.widthAnchor),
            HelpText.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -90),
            
            GetStartedButton.topAnchor.constraint(equalTo: HelpText.bottomAnchor, constant: -60),
            //HelpText.rightAnchor.constraint(equalTo: view.rightAnchor),
            GetStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GetStartedButton.widthAnchor.constraint(equalToConstant: 200),
            GetStartedButton.heightAnchor.constraint(equalToConstant: 70),
            //GetStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])

    }
    
}
