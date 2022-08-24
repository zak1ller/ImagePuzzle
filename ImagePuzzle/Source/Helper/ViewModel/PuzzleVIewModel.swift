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
  
  @Published var activeView = true
  @Published var puzzleImages: [PuzzleImage] = []
  @Published var dropImages: [PuzzleImage] = [
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0),
    PuzzleImage(image: nil, index: 0)
  ]
  
  init(originImage: UIImage?) {
    self.originImage = originImage
  }
}

// MARK: - Image Woker
extension PuzzleViewModel {
  func makePuzzle(row: Int, column: Int) {
    PuzzleMaker(image: originImage!, numRows: row, numColumns: column)
      .generatePuzzles { throwableClosure in
        do {
          var index = 0
          let puzzleElements = try throwableClosure()
          for row in 0 ..< row {
            for column in 0 ..< column {
              guard let puzzleElement = puzzleElements[row][column] else { continue }
              let image = puzzleElement.image
              self.puzzleImages.append(PuzzleImage(image: image.pngData()!, index: index))
              index += 1
            }
          }
        } catch {
          debugPrint(error)
        }
        self.puzzleImages.shuffle()
      }
  }
}

extension PuzzleViewModel {
  func reload() {
    dropImages = [
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0),
      PuzzleImage(image: nil, index: 0)
    ]
    
    self.puzzleImages.removeAll()
    makePuzzle(row: 4, column: 4)
  }
  
  func removeRandomImage(id: String) {
    var i = 0
    for value in puzzleImages {
      if value.id == id {
        puzzleImages.remove(at: i)
        break
      }
      i += 1
    }
  }
  
  func removePuzzleImage(id: String) {
    var i = 0
    for value in dropImages {
      if value.id == id {
        dropImages[i] = PuzzleImage(image: nil, index: 0)
        break
      }
      i += 1
    }
  }
}
