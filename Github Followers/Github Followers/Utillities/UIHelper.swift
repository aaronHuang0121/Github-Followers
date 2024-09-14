//
//  UIHelper.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/14.
//

import UIKit

struct UIHelper {
    static func createColumnsFlowLayout(in view: UIView, columns: Int = 1) -> UICollectionViewLayout {
        let columns = CGFloat(columns > 0 ? columns : 1)
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth: CGFloat = width - (padding * 2) - (minimumItemSpacing * (columns - 1))
        let itemWidth = availableWidth / columns
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
