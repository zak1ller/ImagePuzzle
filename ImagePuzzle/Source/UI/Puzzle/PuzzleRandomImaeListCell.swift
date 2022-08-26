//
//  PuzzleRandomImaeListCell.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import UIKit

final class PuzzleRnadomImageListCell: UICollectionViewCell {
  
  lazy var image = UIImageView().then {
    $0.contentMode = .scaleToFill
  }
 
  lazy var imageBorder = UIView().then {
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 1
  }
  
  var opacity = false // dragState에서 이미지 opacity를 조정하기 위한 트릭
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setView()
    setConstraint()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setView()
    setConstraint()
  }
  
  override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {
    switch dragState {
    case .none:
      print("none")
      self.image.layer.opacity = 1
    case .lifting:
      print("lifting")
      return
    case .dragging:
      print("dragging")
      if !opacity {
        self.image.layer.opacity = 0
      } else {
        self.image.layer.opacity = 1
      }
      opacity.toggle()
    default:
      break
    }
  }
  
  func configure(_ item: Data) {
    let image = UIImage(data: item)
    self.image.image = image
  }
}

// MARK: - UI
extension PuzzleRnadomImageListCell {
  private func setView() {
    self.addSubview(image)
    self.addSubview(imageBorder)
  }
  
  private func setConstraint() {
    image.snp.makeConstraints { make in
      make.width.height.equalTo(80)
      make.centerX.centerY.equalToSuperview()
    }
    
    imageBorder.snp.makeConstraints { make in
      make.leading.equalTo(image)
      make.trailing.equalTo(image)
      make.top.equalTo(image)
      make.bottom.equalTo(image)
    }
  }
}
