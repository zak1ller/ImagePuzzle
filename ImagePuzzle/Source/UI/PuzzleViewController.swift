//
//  PuzzleViewController.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import UIKit
import Combine

class PuzzleViewController: UIViewController {
  
  lazy var bottomButtonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.spacing = 16
  }
  
  lazy var stopButton = UIButton(type: .system) .then {
    $0.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    $0.setTitle("이 사진 그만 볼래요", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    $0.backgroundColor = .systemOrange
    $0.layer.cornerRadius = 20
  }
  
  lazy var passButton = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(passButtonTapped), for: .touchUpInside)
    $0.setTitle("넘기기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    $0.backgroundColor = .systemOrange
    $0.layer.cornerRadius = 20
  }
  
  let randomImagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  var viewModel: PuzzleViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    setConstraint()
    bind()
    viewModel.makePuzzle(row: 4, column: 4)
  }
  
  private func bind() {
    viewModel.$puzzleImages
      .sink { puzzleImages in
        self.randomImagesCollectionView.reloadData()
      }
      .store(in: &subscriptions)
  }
}

// MARK: - UI
extension PuzzleViewController {
  private func setView() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(bottomButtonStackView)
    view.addSubview(randomImagesCollectionView)
    
    randomImagesCollectionView.accessibilityValue = "PuzzleRnadomImageListCell"
    randomImagesCollectionView.register(PuzzleRnadomImageListCell.self, forCellWithReuseIdentifier: "PuzzleRnadomImageListCell")
    randomImagesCollectionView.delegate = self
    randomImagesCollectionView.dataSource = self
    randomImagesCollectionView.backgroundColor = .systemGroupedBackground
   
    bottomButtonStackView.addArrangedSubview(stopButton)
    bottomButtonStackView.addArrangedSubview(passButton)
  }
  
  private func setConstraint() {
    bottomButtonStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-16)
    }
    
    stopButton.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
    
    passButton.snp.makeConstraints { make in
      make.width.equalTo(80)
      make.height.equalTo(40)
    }
    
    randomImagesCollectionView.snp.makeConstraints { make in
      make.height.equalTo(100)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(bottomButtonStackView.snp.top).offset(-40)
    }
  }
}

// MARK: - Action
extension PuzzleViewController {
  @objc private func stopButtonTapped() {
    
  }
  
  @objc private func passButtonTapped() {
    
  }
}

// MARK: - CollectionView
extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.puzzleImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleRnadomImageListCell", for: indexPath) as! PuzzleRnadomImageListCell
    cell.configure(viewModel.puzzleImages[indexPath.item].image)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
}
