//
//  MemeCollectionViewController.swift
//  MemeMeApp
//
//  Created by Victor Matthijs on 26/06/2018.
//  Copyright © 2018 Victor Matthijs. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let object = UIApplication.shared.delegate as! AppDelegate
        return object.memes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let object = UIApplication.shared.delegate as! AppDelegate
        
        cell.memedImageView.image = object.memes[indexPath.item].memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! DetailMemeViewController
        let object = UIApplication.shared.delegate as! AppDelegate
        let detailMeme = object.memes[indexPath.item]
        detailViewController.detailMeme = detailMeme
        
        show(detailViewController, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeCollectionView.reloadData()
    }
    
}
