//
//  CollectionViewFlowLayout.swift
//  CollectionCarosel
//
//  Created by byndr on 01/11/21.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Constants
    private enum Constants {
        static let zoomFactor: CGFloat = 0.3
        static let itemWidth: CGFloat = 230       //Width of the Cell.
        static let itemHeight: CGFloat = 300      //Height of the Cell.
        static let minLineSpacing: CGFloat = 50.0
    }
    
    public var activeDistance: CGFloat = 200
    
    override public func prepare() {
        super.prepare()
        
        itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        scrollDirection = .horizontal
        minimumLineSpacing = Constants.minLineSpacing
        //These numbers will depend on the size of your cards you have set in the CardsViewFlowConstants.
        //60 - will let the first and last card of the CollectionView to be centered.
        //100 - will avoid the double rows in the CollectionView
        sectionInset = UIEdgeInsets.init(top: 100.0, left: 60.0, bottom: 100, right: 60.0)
    }
    
    // Here is where the magic happens
    // Add zooming to the Layout Attributes.
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView!.contentOffset
        visibleRect.size = collectionView!.bounds.size
        
        for itemAttributes in array! {
            //let newAttributes: UICollectionViewLayoutAttributes = itemAttributes
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            if itemAttributesCopy.frame.intersects(rect) {
                let distance = visibleRect.midX - itemAttributes.center.x
                let normalizedDistance = distance / activeDistance
                if (abs(distance)) < activeDistance {
                    let zoom = 1 + Constants.zoomFactor*(1 - abs(normalizedDistance))
                    itemAttributesCopy.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    itemAttributesCopy.zIndex = 1
                }
            }
            attributesCopy.append(itemAttributesCopy)
        }
        return attributesCopy
    }
    
    //Focus the zoom in the middle Card.
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (collectionView!.bounds.width / 2.0)
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        
        if let array = super.layoutAttributesForElements(in: targetRect) {
            for layoutAttributes in array {
                let itemHorizontalCenter: CGFloat = layoutAttributes.center.x
                if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    // Invalidate the Layout when the user is scrolling
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
