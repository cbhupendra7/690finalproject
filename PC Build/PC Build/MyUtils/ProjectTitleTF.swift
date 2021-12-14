//
//  ProjectTitleTF.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class ProjectTitleTF: UITextField {
    
    private let edge = UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
