//
//  PuzzleSuccessEffectViewController.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/25.
//

import Foundation
import UIKit

final class PuzzleSuccessEfffectViewController: UIViewController {
  
  lazy var successLabel = UILabel().then {
    $0.text = "퍼즐 완성!"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 25, weight: .heavy)
  }
  
  var dismissedAction: (() -> ())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    setConstraint()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 1.0, animations: {
      self.view.alpha = 1
    }, completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        UIView.animate(withDuration: 1.0, animations: {
          self.view.alpha = 0
        }, completion: { _ in
          self.dismiss(animated: false)
        })
      })
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    dismissedAction?()
  }
}

// MARK: - UI
extension PuzzleSuccessEfffectViewController {
  private func setView() {
    view.alpha = 0
    view.backgroundColor = .white
    
    view.addSubview(successLabel)
  }
  
  private func setConstraint() {
    successLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.centerY.equalToSuperview()
    }
  }
}
