//
//  ClueView.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 09/02/2021.
//

import UIKit
import Firebase
import SwiftMessages

class ClueView: UIViewController, UITextFieldDelegate {
    
    var clueNumber: String?
    var redcolour = UIColor(red: 0.95, green: 0.18, blue: 0.32, alpha: 1.00)
    
    lazy var ClueText: UILabel = {
        let ClueText = UILabel()
        if let cr = clueNumber {
            ClueText.text = "\(cr) Riddle"
        }
        ClueText.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        ClueText.textColor = .white
        ClueText.translatesAutoresizingMaskIntoConstraints = false
        return ClueText
    }()
    
    lazy var RiddleText: UILabel = {
        let RiddleText = UILabel()
        RiddleText.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        RiddleText.textColor = .white
        RiddleText.translatesAutoresizingMaskIntoConstraints = false
        RiddleText.numberOfLines = 0
        return RiddleText
    }()
    
    lazy var PassKeyField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Answer.."
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = UITextField.ViewMode.always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 20
        field.layer.masksToBounds = true
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor(red: 0.75, green: 0.08, blue: 0.24, alpha: 1.00).cgColor
        field.backgroundColor = UIColor.white
        field.returnKeyType = .done
        return field
    }()
    
    lazy var answerText: UILabel = {
        let answerText = UILabel()
        answerText.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        answerText.textColor = UIColor(red: 0.75, green: 0.08, blue: 0.24, alpha: 1.00)
        answerText.translatesAutoresizingMaskIntoConstraints = false
        return answerText
    }()
    
    lazy var checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.setTitle("Check Answer", for: .normal)
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        checkButton.setTitleColor(.white, for: .normal)
        checkButton.backgroundColor = UIColor(red: 0.75, green: 0.08, blue: 0.24, alpha: 1.00)
        checkButton.layer.cornerRadius = 20
        checkButton.layer.masksToBounds = true
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        return checkButton
    }()
    
    lazy var Image: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "heart", withConfiguration: largeConfig)?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        button.setImage(largeBoldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        //button.backgroundColor = UIColor.white
        return button
    }()
    
    lazy var colourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white//UIColor(red: 0.75, green: 0.08, blue: 0.24, alpha: 1.00)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    var answer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = redcolour
        setupView()
        getRiddle()
        PassKeyField.delegate = self
        checkButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
    }
    
    func getRiddle() {
        guard let document = clueNumber else {return}
        let ref = Firestore.firestore().collection("clues").document(document)
        ref.addSnapshotListener({ (snapshot, error) in
            let data = snapshot?.data()
            var riddle = data?["clue"] as! String
            let solved = data?["solved"] as! Bool
            let key = data?["key"] as! String
            let Answer = data?["answer"] as! String
            self.answer = Answer
            riddle = riddle.replacingOccurrences(of: "\\n", with: "\n")
            self.RiddleText.text = riddle
            if solved {
                self.answerText.isHidden = false
                self.answerText.text = "The Key from this clue is \(key)"
            }
            else {
                self.answerText.isHidden = true
            }
        })
    }

    func setupView() {
        view.addSubview(colourView)
        view.addSubview(ClueText)
        view.addSubview(RiddleText)
        view.addSubview(Image)
        colourView.addSubview(PassKeyField)
        colourView.addSubview(answerText)
        colourView.addSubview(checkButton)

        NSLayoutConstraint.activate([

            ClueText.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            ClueText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //ClueText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            ClueText.heightAnchor.constraint(equalToConstant: 80),
            
            Image.leftAnchor.constraint(equalTo: ClueText.rightAnchor,constant: 10),
            Image.centerYAnchor.constraint(equalTo: ClueText.centerYAnchor),
            
            RiddleText.topAnchor.constraint(equalTo: ClueText.bottomAnchor, constant: 10),
            RiddleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            RiddleText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            RiddleText.bottomAnchor.constraint(equalTo: colourView.topAnchor),
            //RiddleText.heightAnchor.constraint(equalToConstant: 50),
            
            colourView.topAnchor.constraint(equalTo: view.centerYAnchor),
            colourView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //colourView.rightAnchor.constraint(equalTo: view.rightAnchor),
            colourView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            PassKeyField.topAnchor.constraint(equalTo: colourView.topAnchor, constant: 20),
            PassKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            PassKeyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            PassKeyField.heightAnchor.constraint(equalToConstant: 50),
            
            checkButton.topAnchor.constraint(equalTo: PassKeyField.bottomAnchor, constant: 20),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
            
            answerText.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 20),
            answerText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            answerText.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            

        ])

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        PassKeyField.resignFirstResponder()
        return true
    }
    
    func showSuccess() {
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "Yay!", body: "You Solved The Clue!")
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    
    @objc func checkAnswer() {
        if PassKeyField.text == answer {
            guard let number = clueNumber else {return}
            let ref = Firestore.firestore().collection("clues").document(number)
            ref.updateData(["solved":true])
            showSuccess()
        }
        else {
            tryAgainMessage()
        }
        
    }
    
    func tryAgainMessage() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Uh Oh", body: "You're so close try again", iconImage: nil, iconText: "🥶", buttonImage: nil, buttonTitle: "Ok") { _ in
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

}
