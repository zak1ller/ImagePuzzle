//
//  ImageListViewCell.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import UIKit

class ImageListViewCell: UITableViewCell {
  lazy var image = UIImageView().then {
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }
  
  lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 8
  }
  
  lazy var nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }
  
  lazy var descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.numberOfLines = 0
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
    nameLabel.text = item.name
    descriptionLabel.text = item.description
  }
}

// MARK: - UI
extension ImageListViewCell {
  private func setView() {
    contentView.addSubview(image)
    contentView.addSubview(contentStackView)
    
    contentStackView.addArrangedSubview(nameLabel)
    contentStackView.addArrangedSubview(descriptionLabel)
  }
  
  private func setConstraint() {
    image.snp.makeConstraints { make in
      make.width.height.equalTo(100)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview().offset(-24)
    }
    
    contentStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalTo(image.snp.leading).offset(-16)
      make.top.equalToSuperview()
    }
  }
}
