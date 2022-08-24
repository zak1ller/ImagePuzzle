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
  
  lazy var puzzleCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  var viewModel: PuzzleViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  enum Section: String {
    case puzzle = "puzzle"
    case images = "images"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
      .sink { puzzleImages in
        self.puzzleCollectionView.reloadData()
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
    view.addSubview(puzzleCollectionView)
    
    randomImagesCollectionView.accessibilityValue = Section.images.rawValue
    randomImagesCollectionView.register(PuzzleRnadomImageListCell.self, forCellWithReuseIdentifier: "PuzzleRnadomImageListCell")
    randomImagesCollectionView.delegate = self
    randomImagesCollectionView.dataSource = self
    randomImagesCollectionView.dragDelegate = self
    randomImagesCollectionView.dropDelegate = self
    randomImagesCollectionView.backgroundColor = .systemGroupedBackground
   
    puzzleCollectionView.accessibilityValue = Section.puzzle.rawValue
    puzzleCollectionView.register(PuzzleCell.self, forCellWithReuseIdentifier: "PuzzleCell")
    puzzleCollectionView.delegate = self
    puzzleCollectionView.dataSource = self
    puzzleCollectionView.dragDelegate = self
    puzzleCollectionView.dropDelegate = self
    puzzleCollectionView.layer.cornerRadius = 16
    puzzleCollectionView.clipsToBounds = true
    
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
    
    puzzleCollectionView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(24)
      
      let width = UIScreen.main.bounds.width - 32
      let height = width
      make.height.equalTo(height)
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
    if collectionView.accessibilityValue == Section.images.rawValue {
      return viewModel.puzzleImages.count
    } else {
      return 16
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.accessibilityValue == Section.images.rawValue {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleRnadomImageListCell", for: indexPath) as! PuzzleRnadomImageListCell
      cell.configure(viewModel.puzzleImages[indexPath.item].image ?? Data())
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as! PuzzleCell
      cell.configure(viewModel.dropImages[indexPath.item].image ?? Data())
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.accessibilityValue == Section.images.rawValue {
      return CGSize(width: 100, height: 100)
    } else {
      let width = (UIScreen.main.bounds.width - 32 - 3)
      let size = (width / 4)
      return CGSize(width: size, height: size)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView.accessibilityValue == Section.images.rawValue {
      return 4
    } else {
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView.accessibilityValue == Section.images.rawValue {
      return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    } else {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
}

extension PuzzleViewController: UICollectionViewDragDelegate {
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let provider: NSItemProvider
    if collectionView.accessibilityValue == Section.images.rawValue {
      provider = NSItemProvider(object: viewModel.puzzleImages[indexPath.item])
    } else {
      provider = NSItemProvider(object: viewModel.dropImages[indexPath.item])
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
    
    // 퍼즐에 맞출 이미지 선택 칸으로는 이동이 불가능하다.
    if collectionView.accessibilityValue == Section.images.rawValue {
      return UICollectionViewDropProposal(operation: .cancel)
    }
    
    // 퍼즐에 이미지가 이미 있는 경우에는 해당 칸에 이동이 불가능하다.
    if viewModel.dropImages[destination].image != nil {
      return UICollectionViewDropProposal(operation: .cancel)
    } else {
      return UICollectionViewDropProposal(operation: .move)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    if collectionView.accessibilityValue == Section.puzzle.rawValue {
      let destinationIndexPath = coordinator.destinationIndexPath!
      let item = coordinator.items[0]
      
      switch coordinator.proposal.operation {
      case .move:
        let itemProvider = item.dragItem.itemProvider
        itemProvider.loadObject(ofClass: PuzzleImage.self) { puzzle, error in
          if let puzzle = puzzle as? PuzzleImage {
            var isDropped = false
            for value in self.viewModel.dropImages {
              if value.id == puzzle.id {
                isDropped = true
              }
            }
            if isDropped { // 이미지 위치 변경
              self.viewModel.removePuzzleImage(id: puzzle.id)
              self.viewModel.dropImages[destinationIndexPath.item] = puzzle
            } else { // 하단 이미지 퍼즐 이미지로 이동
              self.viewModel.dropImages[destinationIndexPath.item] = puzzle
              self.viewModel.removeRandomImage(id: puzzle.id)
            }
          }
        }
      default:
        return
      }
    }
  }
}
