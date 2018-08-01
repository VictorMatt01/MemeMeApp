//
//  MemeTableViewCell.swift
//  MemeMeApp
//
//  Created by Victor Matthijs on 25/06/2018.
//  Copyright © 2018 Victor Matthijs. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMeme: UIImageView!
    
    @IBOutlet weak var textMeme: UILabel!
    
    func setMeme(text: String, image: UIImage){
        imageMeme.image = image
        textMeme.text = text
    }

}
