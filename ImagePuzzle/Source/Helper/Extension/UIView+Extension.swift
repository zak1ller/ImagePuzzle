//
//  UIView+Extension.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/24.
//

import Foundation
import UIKit

extension UIView {
  static func makeEmptyView(size: CGFloat) -> UIView{
    let view = UIView()
    view.snp.makeConstraints { make in
      make.width.height.equalTo(size)
    }
    return view
  }
}
