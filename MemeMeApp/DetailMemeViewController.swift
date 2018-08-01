//
//  DetailMemeViewController.swift
//  MemeMeApp
//
//  Created by Victor Matthijs on 26/06/2018.
//  Copyright © 2018 Victor Matthijs. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {

    @IBOutlet weak var detailMemeImageView: UIImageView!
    
    var detailMeme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        self.detailMemeImageView!.image = detailMeme.memedImage
    }
    

    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
