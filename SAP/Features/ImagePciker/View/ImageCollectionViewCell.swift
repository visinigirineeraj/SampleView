//
//  ImageCollectionViewCell.swift
//  CollectionCarosel
//
//  Created by Byndr on 01/11/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CustomImageView!
    
    var swippedAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpFunction(_:)))
        swipeUpGesture.direction = .up
        addGestureRecognizer(swipeUpGesture)
    }
    
    @objc func swipeUpFunction(_ sender: UIButton) {
        swippedAction?()
    }
}
