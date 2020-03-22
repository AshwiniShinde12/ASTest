//
//  Extension.swift
//  ASTest
//
//  Created by Ashwini on 20/03/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func roundImage(){
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
extension UIImage {

func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
    var width: CGFloat
    var height: CGFloat
    var newImage: UIImage
    
    let size = self.size
    let aspectRatio =  size.width/size.height
    
    switch contentMode {
    case .scaleAspectFit:
        if aspectRatio > 1 {                            // Landscape image
            width = dimension
            height = dimension / aspectRatio
        } else {                                        // Portrait image
            height = dimension
            width = dimension * aspectRatio
        }
        
    default:
        fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
    }
    
    if #available(iOS 10.0, *) {
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = opaque
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
        newImage = renderer.image {
            (context) in
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }
    } else {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    return newImage
}
}

extension UITextField{
    
    func isValidPhone() -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self.text!)
        }

    func isValidEmail() -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text!)
        }
}

extension UIView{
    func addShadow(radius:CGFloat)
    {
          self.layer.shadowColor = UIColor.black.cgColor
          self.layer.shadowOffset = CGSize(width: 0.0, height: 0.6)
          self.layer.shadowRadius = radius
          self.layer.cornerRadius = radius
          self.layer.shadowOpacity = 0.5
    }
    
}
