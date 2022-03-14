//
//  FirstPage.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 07/02/2021.
//

import UIKit

class FirstPage: UIViewController {
    
    lazy var colourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.61, green: 0.05, blue: 0.87, alpha: 1.00)
        return view
    }()
    
    lazy var HelpText: UILabel = {
        let HelpText = UILabel()
        HelpText.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        HelpText.textColor = .white
        HelpText.translatesAutoresizingMaskIntoConstraints = false
        HelpText.numberOfLines = 0
        HelpText.text = """
                           Welcome to your
                           Valentines Day
                           Scavenger
                           Hunt....
                        """
        return HelpText
    }()
    
    lazy var Image: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "heart", withConfiguration: largeConfig)?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
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
        view.backgroundColor = UIColor(red: 0.80, green: 0.65, blue: 1.00, alpha: 1.00)

        setupView()
    }
    
    func setupView() {
        view.addSubview(colourView)
        view.addSubview(HelpText)
        view.addSubview(Image)

        NSLayoutConstraint.activate([
            
            colourView.topAnchor.constraint(equalTo: view.centerYAnchor),
            colourView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            colourView.rightAnchor.constraint(equalTo: view.rightAnchor),
            colourView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            Image.centerXAnchor.constraint(equalTo: colourView.centerXAnchor),
            Image.topAnchor.constraint(equalTo: view.topAnchor,constant: 200),
            
            HelpText.topAnchor.constraint(equalTo: view.centerYAnchor),
            //HelpText.rightAnchor.constraint(equalTo: view.rightAnchor),
            HelpText.widthAnchor.constraint(equalTo: view.widthAnchor),
            HelpText.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            
        ])

    }



}
