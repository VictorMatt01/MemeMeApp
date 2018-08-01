//
//  TableViewContollerTest.swift
//  MemeMeApp
//
//  Created by Victor Matthijs on 25/06/2018.
//  Copyright © 2018 Victor Matthijs. All rights reserved.
//

import UIKit

class TableViewContollerTest: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = UIApplication.shared.delegate as! AppDelegate
        return object.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemeTableViewCell
        let object = UIApplication.shared.delegate as! AppDelegate
        
        let text = object.memes[indexPath.row].topText + " " + object.memes[indexPath.row].bottomText
        
        cell.setMeme(text: text, image: object.memes[indexPath.row].originalImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! DetailMemeViewController
        let object = UIApplication.shared.delegate as! AppDelegate
        
        let detailMeme = object.memes[indexPath.row]
        
        detailViewController.detailMeme = detailMeme
        
        show(detailViewController, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.reloadData()
    }

}
