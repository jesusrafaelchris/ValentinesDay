//
//  MenuView.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 08/02/2021.
//

import UIKit
import Firebase
import SwiftMessages

class MenuView: UIViewController {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var colourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.95, green: 0.18, blue: 0.32, alpha: 1.00)
        return view
    }()
    
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(ClueCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    lazy var TitleText: UILabel = {
        let TitleText = UILabel()
        TitleText.text = "Valentines \nDay Hunt"
        TitleText.adjustsFontSizeToFitWidth = true
        TitleText.numberOfLines = 2
        TitleText.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        TitleText.textColor = .white
        TitleText.translatesAutoresizingMaskIntoConstraints = false
        return TitleText
    }()
    
    lazy var lowerText: UILabel = {
        let lowerText = UILabel()
        lowerText.text = "Happy Valentines Day Freya"
        lowerText.adjustsFontSizeToFitWidth = true
        lowerText.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        lowerText.textColor = .white
        lowerText.translatesAutoresizingMaskIntoConstraints = false
        return lowerText
    }()
    
    var clues = [ClueStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.80, green: 0.65, blue: 1.00, alpha: 1.00)
        navigationController?.navigationBar.isHidden = true
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        getClues()
    }
    
    func getClues() {
        let docref = Firestore.firestore().collection("clues").order(by: "number")
        docref.addSnapshotListener({ (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            self.clues.removeAll()
            for document in documents {
                let data = document.data()
                let cluestruct = ClueStruct()
                cluestruct.Cluename = document.documentID
                let islocked = data["Locked"] as! Bool
                cluestruct.islocked = islocked
                self.clues.append(cluestruct)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(colourView)
        colourView.addSubview(TitleText)
        colourView.addSubview(lowerText)
        containerView.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.725),
            
            colourView.topAnchor.constraint(equalTo: containerView.topAnchor),
            colourView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3),
            colourView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            colourView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            TitleText.centerYAnchor.constraint(equalTo: colourView.centerYAnchor),
            TitleText.rightAnchor.constraint(equalTo: colourView.rightAnchor),
            TitleText.leftAnchor.constraint(equalTo: colourView.leftAnchor,constant: 20),
            TitleText.widthAnchor.constraint(equalTo: colourView.widthAnchor),
            
            lowerText.bottomAnchor.constraint(equalTo: colourView.bottomAnchor, constant: -40),
            lowerText.rightAnchor.constraint(equalTo: colourView.rightAnchor),
            lowerText.leftAnchor.constraint(equalTo: colourView.leftAnchor,constant: 20),
            lowerText.widthAnchor.constraint(equalTo: colourView.widthAnchor),
            
            tableView.topAnchor.constraint(equalTo: colourView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
        ])

    }
    
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ClueCell
        let Clues = clues[indexPath.row]
        cell.ClueText.text = Clues.Cluename
        
        if Clues.islocked == false {
            cell.Lockimage.isHidden = true
            cell.ClueText.textColor = .black
            let imagegrey = UIImage(systemName: "lock.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
            cell.Lockimage.image = imagegrey
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            let largeBoldDoc = UIImage(systemName: "map", withConfiguration: largeConfig)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
            cell.clueimage.image = largeBoldDoc
        }
        else if Clues.islocked == true  {
            cell.Lockimage.isHidden = false
            cell.ClueText.textColor = UIColor.lightGray
            let imagegrey = UIImage(systemName: "lock.fill")?.withTintColor(.lightGray).withRenderingMode(.alwaysOriginal)
            cell.Lockimage.image = imagegrey
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            let largeBoldDoc = UIImage(systemName: "map.fill", withConfiguration: largeConfig)?.withTintColor(.lightGray).withRenderingMode(.alwaysOriginal)
            cell.clueimage.image = largeBoldDoc
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! ClueCell
        let Clues = clues[indexPath.row]
        if Clues.islocked == false {
            let clueview = ClueView()
            clueview.clueNumber = cell.ClueText.text
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.present(clueview, animated: true, completion: nil)
        }
        else if Clues.islocked == true  {
            showError()
        }

    }
    
    func showError() {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: "You haven't unlocked this yet.")
        error.button?.setTitle("Ok", for: .normal)
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: error)
        
    }
}


class ClueStruct {
    
    var Cluename:String?
    var islocked:Bool?
    var Latitude:NSNumber?
    var Longitude:NSNumber?
    
}
