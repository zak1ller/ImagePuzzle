//
//  PuzzleSuccessViewController.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/25.
//

import Foundation
import UIKit
import Combine

final class PuzzleSuccessViewController: UIViewController {
  
  lazy var imageView = UIImageView().then {
    $0.image = self.viewModel.originImage.image
  }
  
  var viewModel: PuzzleSuccessViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    setConstraint()
    bind()
  }
  
  private func bind() {
    
  }
}

// MARK: - UI
extension PuzzleSuccessViewController {
  private func setView() {
    view.backgroundColor = .white
    
    view.addSubview(imageView)
  }
  
  private func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(UIScreen.main.bounds.width - 80)
      make.leading.equalToSuperview().offset(40)
      make.trailing.equalToSuperview().offset(-40)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(40)
    }
  }
}
