//
//  ImageListViewModel.swift
//  ImagePuzzle
//
//  Created by Min-Su Kim on 2022/08/22.
//

import Foundation
import Combine
import UIKit

final class ImageListViewModel {
  @Published var images: [OriginImage] = OriginImage.originSampleImages
  @Published var selectedImage: UIImage?
}
