//
//  ViewController.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import UIKit
import Combine

class ImageListViewController: UIViewController {
  
  lazy var tableView = UITableView().then {
    $0.register(ImageListViewCell.self, forCellReuseIdentifier: "ImageListViewCell")
    $0.delegate = self
    $0.dataSource = self
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 100
    $0.separatorStyle = .none
  }
  
  let viewModel = ImageListViewModel()
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    setConstraint()
    bind()
  }

  private func bind() {
    viewModel.$images
      .sink { image in
        self.tableView.reloadData()
      }
      .store(in: &subscriptions)
  }
}

// MARK: - UI
extension ImageListViewController {
  private func setView() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(tableView)
  }
  
  private func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.layoutMarginsGuide.snp.top)
      make.bottom.equalToSuperview()
    }
  }
}

// MARK: - UITableView
extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.images.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListViewCell", for: indexPath) as! ImageListViewCell
    cell.configure(viewModel.images[indexPath.item])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = viewModel.images[indexPath.item]
    
    let vc = PuzzleViewController()
    vc.viewModel = PuzzleViewModel(originImage: item.image)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
