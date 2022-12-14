//
//  UIImage+Extension.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/25.
//

import Foundation
import UIKit

extension UIImage {
  func cropImageToSquare() -> UIImage? {
    var imageHeight = self.size.height
    var imageWidth = self.size.width
    
    if imageHeight > imageWidth {
      imageHeight = imageWidth
    } else {
      imageWidth = imageHeight
    }
    
    let size = CGSize(width: imageWidth, height: imageHeight)
    
    let refWidth : CGFloat = CGFloat(self.cgImage!.width)
    let refHeight : CGFloat = CGFloat(self.cgImage!.height)
    
    let x = (refWidth - size.width) / 2
    let y = (refHeight - size.height) / 2
    
    let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
    if let imageRef = self.cgImage!.cropping(to: cropRect) {
      return UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
    }
    
    return nil
  }
}
