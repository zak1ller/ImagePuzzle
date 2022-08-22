//
//  ImageListViewModel.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import Combine

final class ImageListViewModel {
  @Published var images: [OriginImage] = OriginImage.originSampleImages
}
