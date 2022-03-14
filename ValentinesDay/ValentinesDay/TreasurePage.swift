//
//  TreasurePage.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 11/02/2021.
//

import UIKit

class TreasurePage: UIViewController {
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var containerView2: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.95, green: 0.18, blue: 0.32, alpha: 1.00)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var CongratulationsText: UILabel = {
        let CongratulationsText = UILabel()
        CongratulationsText.text = "Congratulations!"
        CongratulationsText.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        CongratulationsText.textColor = .white
        CongratulationsText.translatesAutoresizingMaskIntoConstraints = false
        return CongratulationsText
    }()
    
    lazy var FoundText: UILabel = {
        let Text = UILabel()
        Text.text = "You found the Valentines Day Treasure!!"
        Text.adjustsFontSizeToFitWidth = true
        Text.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        Text.textColor = .white
        Text.translatesAutoresizingMaskIntoConstraints = false
        return Text
    }()
    
    lazy var emoji1: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = UIFont(name: "AppleColorEmoji", size: 60)
        emoji.text = "🎉"
        emoji.adjustsFontSizeToFitWidth = true
        emoji.minimumScaleFactor = 0.5
        emoji.textAlignment = .center
        return emoji
    }()
    
    lazy var emoji2: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = UIFont(name: "AppleColorEmoji", size: 60)
        emoji.text = "🎉"
        emoji.adjustsFontSizeToFitWidth = true
        emoji.minimumScaleFactor = 0.5
        emoji.textAlignment = .center
        return emoji
    }()
    
    
    lazy var BottomText: UITextView = {
        let Text = UITextView()
        Text.text = """
            But it’s not over yet....
            You have unlocked the next part of our valentines day together.
            This part requires you to dress in something a little fancier..
            We’re going to make homemade fresh pasta and i’m going to cook you..

            Creamy Crab Pasta with Chilli and Basil

            Ingredients
            420 g blue swimmer crab meat drained & picked for shell
            250 g dry angel hair pasta
            1 tbsp. olive oil
            250 g cherry tomatoes cut into quarters or eighths if large
            2 large garlic cloves crushed/minced
            1 long red chilli very finely chopped (see notes)
            1/3 cup dry white wine
            300 ml pure cream
            1 cup firmly packed fresh basil leaves
            juice of 1 lemon
            salt & pepper to taste
            grated fresh parmesan to serve

            Instructions
            Heat oil in a large frying pan over medium heat.
            Add tomatoes and cook, stirring for 1-2 mins or until tomatoes
            have started to break down.
            Add garlic and chilli and cook, stirring for 1 min.
            Add white wine to pan to deglaze (it might sizzle a bit) and bring to boil.
            Allow wine to simmer for 1-2 minutes or until it has reduced by about half.
            Add cream, crab & basil to pan and leave on medium heat until cream
            starts to bubble and thicken just slightly.
            Meanwhile cook pasta according to packet directions and drain.
            Add lemon juice and drained pasta to cream & crab mixture, stirring to combine.
            Top with parmesan if desired & serve immediately.
            """
        //Text.adjustsFontSizeToFitWidth = true
        Text.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        Text.textColor = .black
        Text.backgroundColor = .white
        Text.translatesAutoresizingMaskIntoConstraints = false
        Text.showsVerticalScrollIndicator = true
        Text.isEditable = false
        Text.isScrollEnabled = true
        Text.scrollRangeToVisible(NSMakeRange(0, 0))
        Text.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        return Text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.18, blue: 0.32, alpha: 1.00)
        setupView()
    }
    
    func setupView() {
        view.addSubview(containerView2)
        containerView2.addSubview(containerView)
        containerView2.addSubview(CongratulationsText)
        containerView2.addSubview(FoundText)
        containerView2.addSubview(emoji1)
        containerView2.addSubview(emoji2)
        view.addSubview(BottomText)
        
        containerView2.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView2.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView2.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView2.bottomAnchor.constraint(equalTo: containerView.topAnchor,constant: 10).isActive = true
        
        CongratulationsText.centerYAnchor.constraint(equalTo: containerView2.centerYAnchor).isActive = true
        CongratulationsText.centerXAnchor.constraint(equalTo: containerView2.centerXAnchor).isActive = true
        CongratulationsText.heightAnchor.constraint(equalToConstant: 45).isActive = true
        CongratulationsText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        FoundText.topAnchor.constraint(equalTo: CongratulationsText.bottomAnchor ,constant:  20).isActive = true
        FoundText.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 8).isActive = true
        FoundText.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -8).isActive = true
        //FoundText.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emoji1.topAnchor.constraint(equalTo: containerView2.topAnchor ,constant: 70).isActive = true
        emoji1.leftAnchor.constraint(equalTo: containerView2.leftAnchor,constant: 20).isActive = true
        //emoji1.rightAnchor.constraint(equalTo: containerView2.rightAnchor).isActive = true
        //emoji1.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor).isActive = true
        
        //emoji2.topAnchor.constraint(equalTo: containerView2.centerYAnchor ,constant:  -40).isActive = true
        //emoji2.leftAnchor.constraint(equalTo: containerView2.leftAnchor).isActive = true
        emoji2.rightAnchor.constraint(equalTo: containerView2.rightAnchor,constant: -20).isActive = true
        emoji2.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor, constant: -20).isActive = true
        
        containerView.topAnchor.constraint(equalTo: view.centerYAnchor ,constant:  -40).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        BottomText.topAnchor.constraint(equalTo: containerView.topAnchor ,constant: 10).isActive = true
        BottomText.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 8).isActive = true
        BottomText.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -8).isActive = true
        BottomText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -8).isActive = true
    }

}
