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
//    $0.layer.cornerRadius = 16
//    $0.clipsToBounds = true
  }
  
  lazy var puzzleTitleLabel = UILabel().then {
    $0.text = "이웃의 퍼즐을 모두 맞췄어요👏"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }
  
  lazy var newGameButton = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
    $0.setTitle("새로 시작하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    $0.backgroundColor = .systemOrange
    $0.layer.cornerRadius = 20
  }
  
  lazy var newGameLabel = UILabel().then {
    $0.text = "내가 맞춘 퍼즐을 한 번 더 맞추고,\n랭킹을 올려보세요!"
    $0.textAlignment = .center
    $0.textColor = .blue
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.numberOfLines = 0
  }
  
  var viewModel: PuzzleSuccessViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  var reloadAction: (() -> ())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurationNavigationItem()
    setView()
    setConstraint()
    bind()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    // Disable 했던 제스처를 다시 활성화
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if !viewModel.activeView {
      reloadAction?()
    }
  }
  
  private func bind() {
    viewModel.$activeView
      .filter { !$0 }
      .sink { _ in
        self.navigationController?.popViewController(animated: true)
      }
      .store(in: &subscriptions)
    
    viewModel.$activeRoowView
      .filter { !$0 }
      .sink { _ in
        self.navigationController?.popToRootViewController(animated: true)
      }
      .store(in: &subscriptions)
  }
}

// MARK: - UI
extension PuzzleSuccessViewController {
  private func configurationNavigationItem() {
    let closeImage = UIImage(named: "close")?.withRenderingMode(.alwaysOriginal)
    let closeButton = UIButton(type: .system)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    closeButton.setImage(closeImage, for: .normal)
    closeButton.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    
    // 스와이프 뒤로가기 제스처 Disable
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  private func setView() {
    view.backgroundColor = .white
    
    view.addSubview(imageView)
    view.addSubview(puzzleTitleLabel)
    view.addSubview(newGameButton)
    view.addSubview(newGameLabel)
  }
  
  private func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(UIScreen.main.bounds.width - 80)
      make.leading.equalToSuperview().offset(40)
      make.trailing.equalToSuperview().offset(-40)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(40)
    }
    
    puzzleTitleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(imageView.snp.bottom).offset(32)
    }
    
    newGameButton.snp.makeConstraints { make in
      make.height.equalTo(40)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-24)
    }
    
    newGameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(newGameButton.snp.top).offset(-24)
    }
  }
}

// MARK: - Action
extension PuzzleSuccessViewController {
  @objc private func closeButtonTapped() {
    viewModel.activeRoowView = false
  }
  
  @objc private func newGameButtonTapped() {
    viewModel.activeView = false
  }
}
