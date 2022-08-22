//
//  ImageListViewCell.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import UIKit

class ImageListViewCell: UITableViewCell {
  lazy var image = UIImageView().then {
    $0.contentMode = .scaleToFill
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setView()
    setConstraint()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setView()
    setConstraint()
  }
  
  func configure(_ item: OriginImage) {
    image.image = item.image
  }
}

extension ImageListViewCell {
  private func setView() {
    contentView.addSubview(image)
  }
  
  private func setConstraint() {
    image.snp.makeConstraints { make in
      make.height.equalTo(contentView.snp.width)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}
