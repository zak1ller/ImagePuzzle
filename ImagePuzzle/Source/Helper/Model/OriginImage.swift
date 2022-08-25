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
  let name: String
  let description: String
}

extension OriginImage {
  static let originSampleImages: [OriginImage] = [
    OriginImage(
      image: UIImage(named: "1")?.cropImageToSquare(),
      name: "길고양이",
      description: "두물머리 핫도그에서 만난 길냥이"
    ),
    OriginImage(
      image: UIImage(named: "2")?.cropImageToSquare(),
      name: "마루",
      description: "우리집의 주인님이신 마루"
    ),
    OriginImage(
      image: UIImage(named: "3")?.cropImageToSquare(),
      name: "뿌까",
      description: "산책에 미쳐 날뛰는 털복숭이"
    )
  ]
}
