//
//  OriginImage.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import UIKit

struct OriginImage {
  let image: UIImage?
}

extension OriginImage {
  static let originSampleImages: [OriginImage] = [
    OriginImage(image: UIImage(named: "1")),
    OriginImage(image: UIImage(named: "2"))
  ]
}
