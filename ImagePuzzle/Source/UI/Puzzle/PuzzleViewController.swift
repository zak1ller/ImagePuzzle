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
    $0.setTitle("넘기기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    $0.backgroundColor = .systemOrange
    $0.layer.cornerRadius = 20
  }
  
  lazy var randomImagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  lazy var puzzleCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  lazy var textStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 8
  }
  
  lazy var puzzleTitleLabel = UILabel().then {
    $0.text = "퍼즐 조각"
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }
  
  lazy var puzzleDescriptionLabel = UILabel().then {
    $0.text = "조각을 꾹 눌러서 위 퍼즐판에 넣고 뺄 수 있어요!"
    $0.textColor = .secondaryLabel
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }
  
  var viewModel: PuzzleViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurationNavigationItem()
    setView()
    setConstraint()
    bind()
    
    viewModel.makePuzzle(row: 4, column: 4)
  }
  
  private func bind() {
    viewModel.$puzzleImages
      .receive(on: DispatchQueue.main)
      .sink { puzzleImages in
        self.randomImagesCollectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    viewModel.$dropImages
      .receive(on: DispatchQueue.main)
      .sink { dropImages in
        self.puzzleCollectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    viewModel.$activeView
      .sink { activeView in
        if !activeView {
          self.navigationController?.popViewController(animated: true)
        }
      }
      .store(in: &subscriptions)
    
    viewModel.$randomImagesScrollToFirst
      .receive(on: DispatchQueue.main)
      .sink { scrollToFirst in
        if scrollToFirst {
          self.randomImagesCollectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0),
            at: .left,
            animated: true
          )
        }
      }
      .store(in: &subscriptions)
    
    viewModel.$isSuccessedPuzzle
      .receive(on: DispatchQueue.main)
      .compactMap { $0 }
      .sink { isSuccessedPuzzle in
        if isSuccessedPuzzle {
          let vc = PuzzleSuccessEfffectViewController()
          vc.modalPresentationStyle = .overFullScreen
          vc.dismissedAction = {
            let vc = PuzzleSuccessViewController()
            vc.viewModel = PuzzleSuccessViewModel(originImage: self.viewModel.originImage)
            vc.reloadAction = {
              self.viewModel.reload()
            }
            self.navigationController?.pushViewController(vc, animated: true)
          }
          self.present(vc, animated: false, completion: nil)
        } else {
          let alert = UIAlertController( title: "알림", message: "퍼즐이 맞지 않아요...", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "다시하기", style: .cancel, handler: { _ in
            self.viewModel.reload()
          }))
          self.present(alert, animated: true, completion: nil)
        }
      }
      .store(in: &subscriptions)
  }
}

// MARK: - UI
extension PuzzleViewController {
  private func configurationNavigationItem() {
    let closeImage = UIImage(named: "close")?.withRenderingMode(.alwaysOriginal)
    let closeButton = UIButton(type: .system)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    closeButton.setImage(closeImage, for: .normal)
    closeButton.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
    
    let reloadImage = UIImage(named: "reload")?.withRenderingMode(.alwaysOriginal)
    let reloadButton = UIButton(type: .system)
    reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    reloadButton.setImage(reloadImage, for: .normal)
    reloadButton.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
    
    let warningImage = UIImage(named: "warning")?.withRenderingMode(.alwaysOriginal)
    let warningButton = UIButton(type: .system)
    warningButton.setImage(warningImage, for: .normal)
    warningButton.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
    
    let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    fixedSpace.width = 16
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(customView: warningButton),
      fixedSpace,
      UIBarButtonItem(customView: reloadButton)
    ]
    
    // 뒤로가기 스와이프 제스처 안 될 때
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
  }
  
  private func setView() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(bottomButtonStackView)
    view.addSubview(randomImagesCollectionView)
    view.addSubview(puzzleCollectionView)
    view.addSubview(textStackView)
    
    bottomButtonStackView.addArrangedSubview(stopButton)
    bottomButtonStackView.addArrangedSubview(passButton)
    
    randomImagesCollectionView.accessibilityValue = PuzzleSection.images.rawValue
    randomImagesCollectionView.register(PuzzleRnadomImageListCell.self, forCellWithReuseIdentifier: "PuzzleRnadomImageListCell")
    randomImagesCollectionView.delegate = self
    randomImagesCollectionView.dataSource = self
    randomImagesCollectionView.dragDelegate = self
    randomImagesCollectionView.dropDelegate = self
    randomImagesCollectionView.backgroundColor = .systemGroupedBackground
   
    puzzleCollectionView.accessibilityValue = PuzzleSection.puzzle.rawValue
    puzzleCollectionView.register(PuzzleCell.self, forCellWithReuseIdentifier: "PuzzleCell")
    puzzleCollectionView.delegate = self
    puzzleCollectionView.dataSource = self
    puzzleCollectionView.dragDelegate = self
    puzzleCollectionView.dropDelegate = self
    puzzleCollectionView.layer.cornerRadius = 16
    puzzleCollectionView.clipsToBounds = true
    
    textStackView.addArrangedSubview(puzzleTitleLabel)
    textStackView.addArrangedSubview(puzzleDescriptionLabel)
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
    
    puzzleCollectionView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(24)
      make.height.equalTo(UIScreen.main.bounds.width - 32)
    }
    
    textStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(randomImagesCollectionView.snp.top).offset(-24)
    }
  }
}

// MARK: - Action
extension PuzzleViewController {
  @objc private func closeButtonTapped() {
    viewModel.activeView = false
  }
  
  @objc private func stopButtonTapped() {
    viewModel.activeView = false
  }

  @objc private func reloadButtonTapped() {
    viewModel.reload()
  }
}

// MARK: - CollectionView Delegate, Datasource
extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      return viewModel.puzzleImages.count
    } else {
      return 16
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleRnadomImageListCell", for: indexPath) as! PuzzleRnadomImageListCell
      cell.configure(viewModel.puzzleImages[indexPath.item].image ?? Data())
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as! PuzzleCell
      cell.configure(viewModel.dropImages[indexPath.item])
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      return CGSize(width: 100, height: 100)
    } else {
      let width = (UIScreen.main.bounds.width - 32 - 3)
      let size = (width / 4)
      return CGSize(width: size, height: size)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      return 4
    } else {
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    } else {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
}

// MARK: - CollectionView Drag and Drop
extension PuzzleViewController: UICollectionViewDragDelegate {
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let provider: NSItemProvider
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      provider = NSItemProvider(object: viewModel.puzzleImages[indexPath.item])
      viewModel.latestSelectedSection = .images
    } else {
      provider = NSItemProvider(object: viewModel.dropImages[indexPath.item])
      viewModel.latestSelectedSection = .puzzle
    }
    let dragItem = UIDragItem(itemProvider: provider)
    return [dragItem]
  }
}

extension PuzzleViewController: UICollectionViewDropDelegate {
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    guard let destination = destinationIndexPath?.item else {
      return UICollectionViewDropProposal(operation: .move)
    }
    
    // 퍼즐에 맞출 이미지 선택 칸 내에서는 상호 이동이 불가능하다.
    if collectionView.accessibilityValue == PuzzleSection.images.rawValue {
      if viewModel.latestSelectedSection == .images {
        return UICollectionViewDropProposal(operation: .cancel)
      }
    }
    
    // 퍼즐에 이미지가 이미 있는 경우에는 해당 칸에 이동이 불가능하다.
    if viewModel.dropImages[destination].image != nil {
      return UICollectionViewDropProposal(operation: .cancel)
    } else {
      return UICollectionViewDropProposal(operation: .move)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

    let item = coordinator.items[0]
    let itemProvider = item.dragItem.itemProvider
    
    if collectionView.accessibilityValue == PuzzleSection.puzzle.rawValue { // 퍼즐판에 퍼즐을 놓을 경우
      switch coordinator.proposal.operation {
      case .move:
        itemProvider.loadObject(ofClass: PuzzleImage.self) { puzzle, error in
          if let puzzle = puzzle as? PuzzleImage {
            var isDropped = false
            for value in self.viewModel.dropImages {
              if value.id == puzzle.id {
                isDropped = true
              }
            }
            if isDropped { // 퍼즐판 내 이미지 위치 변경
              self.viewModel.removePuzzleImage(id: puzzle.id)
              self.viewModel.changeDropImage(i: destinationIndexPath.item, item: puzzle)
            } else { // 하단의 이미지를 퍼즐판으로 이동
              self.viewModel.changeDropImage(i: destinationIndexPath.item, item: puzzle)
              self.viewModel.removeRandomImage(id: puzzle.id)
            }
          }
        }
      default:
        return
      }
    } else { // 퍼즐판에서 퍼즐선택칸으로 이동시
      switch coordinator.proposal.operation {
      case .move:
        itemProvider.loadObject(ofClass: PuzzleImage.self) { puzzle, error in
          if let puzzle = puzzle as? PuzzleImage {
            self.viewModel.revertPuzzleImage(id: puzzle.id)
          }
        }
      default:
        break
      }
    }
  }
}
