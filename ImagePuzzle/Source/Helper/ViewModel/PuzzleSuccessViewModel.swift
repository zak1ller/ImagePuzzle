//
//  PuzzleSuccessViewModel.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/25.
//

import Foundation
import Combine

final class PuzzleSuccessViewModel {
  let originImage: OriginImage
  
  @Published var activeRoowView = true
  @Published var activeView = true
  
  init(originImage: OriginImage) {
    self.originImage = originImage
  }
}
