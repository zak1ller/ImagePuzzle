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
  var originImage: OriginImage
  var latestSelectedSection: PuzzleSection? // 선택중인 섹션을 구분하기 위한 변수
  
  @Published var activeView = true
  @Published var isSuccessedPuzzle: Bool?
  @Published var randomImagesScrollToFirst = false
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
  ] {
    didSet {
      var nilCount = 0
      for value in dropImages {
        if value.image == nil {
          nilCount += 1
        }
      }
      
      if nilCount == 0 {
        checkPuzzleSuccess()
      }
    }
  }
  
  init(originImage: OriginImage) {
    self.originImage = originImage
  }
}

// MARK: - Image Woker
extension PuzzleViewModel {
  func makePuzzle(row: Int, column: Int) {
    PuzzleMaker(image: originImage.image!, numRows: row, numColumns: column)
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
//        self.puzzleImages.shuffle()
      }
  }
}

// MARK: - Functions
extension PuzzleViewModel {
  func checkPuzzleSuccess() {
    var i = 0
    var isSuccess = true
    dropImages.forEach {
      if $0.index != i {
        isSuccess = false
      }
      i += 1
    }
    isSuccessedPuzzle = isSuccess
  }
  
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
  
  func changeDropImage(i: Int, item: PuzzleImage) {
    dropImages[i] = item
  }
  
  func revertPuzzleImage(id: String) {
    var i = 0
    var image = PuzzleImage(image: nil, index: 0)
    for value in dropImages {
      if value.id == id {
        image = dropImages[i]
        dropImages[i] = PuzzleImage(image: nil, index: 0)
        break
      }
      i += 1
    }
    puzzleImages.insert(image, at: 0)
    
    randomImagesScrollToFirst = true
  }
}
