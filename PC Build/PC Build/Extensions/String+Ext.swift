//
//  String+Ext.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

extension String {
    
    func toInt() -> Int {
        return Int(self)!
    }
    
    func toDouble() -> Double {
        return Double(self)!
    }
    
    //TODO: - Check Email
    func matches(_ expression: String) -> Bool {
        if let range = range(of: expression, options: .regularExpression, range: nil, locale: nil) {
            return range.lowerBound == startIndex && range.upperBound == endIndex
            
        } else {
            return false
        }
    }
    
    var isValidEmail: Bool {
        matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    //TODO: - FirstName - LastName
    func fetchFirstLastName(completion: @escaping (String, String) -> Void) {
        var components = self.components(separatedBy: " ")
        if components.count > 0 {
            let fn = components.removeFirst()
            let ln = components.joined(separator: " ")
            completion(fn, ln)
        }
    }
    
    func estimatedText(font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGRect {
        let height = CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [
            NSAttributedString.Key.font : font
        ]
        
        return NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}
