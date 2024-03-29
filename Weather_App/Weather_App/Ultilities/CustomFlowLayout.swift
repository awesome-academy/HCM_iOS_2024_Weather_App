//
//  CustomFlowLayout.swift
//  Weather_App
//
//  Created by An Bảo on 31/03/2024.
//

import Foundation
import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil } 
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                layoutAttribute.frame.size.width = collectionView.frame.width
            }
        }
        return attributes
    }
}
