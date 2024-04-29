//
//  UIView+Ext.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
