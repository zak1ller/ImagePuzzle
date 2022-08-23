//
//  PuzzleImage.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

final class PuzzleImage: NSObject, Codable, NSItemProviderReading, NSItemProviderWriting {
  static var readableTypeIdentifiersForItemProvider: [String] {
    return [(kUTTypeData) as String]
  }
  
  static var writableTypeIdentifiersForItemProvider: [String] {
    return [(kUTTypeData) as String]
  }
  
  var id = UUID().uuidString
  let image: Data?
  let index: Int
  
  init(image: Data?, index: Int) {
    self.image = image
    self.index = index
  }
  
  static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> PuzzleImage {
    let decoder = JSONDecoder()
    do {
      let model = try decoder.decode(PuzzleImage.self, from: data)
      return model
    } catch {
      fatalError()
    }
  }
  
  func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
    let progress = Progress(totalUnitCount: 100)
    do {
      let data = try JSONEncoder().encode(self)
      progress.completedUnitCount = 100
      completionHandler(data, nil)
    } catch {
      completionHandler(nil, error)
    }
    return progress
  }
}
