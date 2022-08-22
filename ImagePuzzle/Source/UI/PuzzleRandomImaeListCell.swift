//
//  PuzzleRandomImaeListCell.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import UIKit

final class PuzzleRnadomImageListCell: UICollectionViewCell {
  
  lazy var containerView = UIView()
  
  lazy var image = UIImageView().then {
    $0.contentMode = .scaleToFill
  }
  
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
  
  func configure(_ item: UIImage?) {
    self.image.image = item
  }
}

// MARK: - UI
extension PuzzleRnadomImageListCell {
  private func setView() {
    contentView.addSubview(containerView)
    containerView.addSubview(image)
  }
  
  private func setConstraint() {
    containerView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
    
    image.snp.makeConstraints { make in
      make.width.height.equalTo(80)
      make.centerX.centerY.equalToSuperview()
    }
  }
}
