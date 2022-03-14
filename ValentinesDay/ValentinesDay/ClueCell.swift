//
//  ClueCell.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 08/02/2021.
//

import UIKit

class ClueCell: UITableViewCell {
    
    let clueimage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "map", withConfiguration: largeConfig)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        image.image = largeBoldDoc
        return image
    }()
    
    let ClueText: UILabel = {
        let text = UILabel()
        text.adjustsFontSizeToFitWidth = true
        text.numberOfLines = 2
        text.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let Lockimage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "lock.fill", withConfiguration: largeConfig)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        image.image = UIImage(systemName: "lock.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        addSubview(clueimage)
        addSubview(ClueText)
        addSubview(Lockimage)
        setupview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupview() {

        
        NSLayoutConstraint.activate([
        
            clueimage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            clueimage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            
            ClueText.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ClueText.leftAnchor.constraint(equalTo: clueimage.rightAnchor, constant: 20),
            
            Lockimage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            Lockimage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            //Lockimage.widthAnchor.constraint(equalToConstant: 50),
            //Lockimage.heightAnchor.constraint(equalToConstant: 50),
            
        
        ])

    }

}
