//
//  Nib.swift
//  EugeneMusic
//
//  Created by Eugene on 13/02/2024.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
}
