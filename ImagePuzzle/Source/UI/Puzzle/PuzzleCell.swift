//
//  PuzzleRandomImaeListCell.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import UIKit

final class PuzzleCell: UICollectionViewCell {
  lazy var image = UIImageView().then {
    $0.contentMode = .scaleToFill
  }
  
  var dragging = false
  
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
      self.image.layer.opacity = 1
      dragging = false
    case .lifting:
      return
    case .dragging:
      if !dragging {
        self.image.layer.opacity = 0
        dragging = true
      } else {
        self.image.layer.opacity = 1
      }
    default:
      break
    }
  }
  
  func configure(_ item: PuzzleImage) {
    let image = UIImage(data: item.image ?? Data())
    self.image.image = image
  }
}

// MARK: - UI
extension PuzzleCell {
  private func setView() {
    contentView.backgroundColor = .systemGroupedBackground
    contentView.addSubview(image)
  }
  
  private func setConstraint() {
    image.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
  }
}
