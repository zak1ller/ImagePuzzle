//
//  PuzzleVIewModel.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import Combine
import UIKit
import PuzzleMaker

final class PuzzleViewModel {
  let originImage: UIImage?
  
  @Published var puzzleImages: [PuzzleImage] = []
  
  init(originImage: UIImage?) {
    self.originImage = originImage
  }
}

// MARK: - Image Woker
extension PuzzleViewModel {
  func makePuzzle(row: Int, column: Int) {
    PuzzleMaker(image: originImage!, numRows: 4, numColumns: 4)
      .generatePuzzles { throwableClosure in
        do {
          let puzzleElements = try throwableClosure()
          for row in 0 ..< row {
            for column in 0 ..< column {
              guard let puzzleElement = puzzleElements[row][column] else { continue }
              let position = puzzleElement.position
              let image = puzzleElement.image
              self.puzzleImages.append(PuzzleImage(image: image, position: position))
            }
          }
        } catch {
          debugPrint(error)
        }
        self.puzzleImages.shuffle()
      }
  }
}
