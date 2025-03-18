//
//  PersistanceManager.swift
//  Recipes_McGreaham
//
//  Created by William McGreaham on 3/7/25.
//

import Foundation
import UIKit

protocol PersistanceManagerDelegate {
    func writeImageToDisk(image: UIImage, imagePath: String)
    func readImageFromDisk(imagePath: String) -> UIImage?

}
class PersistanceManager: PersistanceManagerDelegate {
    private let baseFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    func writeImageToDisk(image: UIImage, imagePath: String) {
        guard let data = image.pngData(), let baseFilePath else { return }
        let filenamePath = baseFilePath.appendingPathComponent(imagePath)
        try? data.write(to: filenamePath)
    }

    func readImageFromDisk(imagePath: String) -> UIImage? {
        guard let baseFilePath else { return nil }
        let filenamePath = baseFilePath.appendingPathComponent(imagePath)
        do {
            let imageData = try Data(contentsOf: filenamePath)
            return UIImage(data: imageData)
        } catch {
            print("Image not found at \(imagePath)")
        }
        return nil
    }
}

class MockPersistanceManager: PersistanceManagerDelegate {
    private let shouldReturnImageOnRead: Bool

    init(shouldReturnImageOnRead: Bool = true) {
        self.shouldReturnImageOnRead = shouldReturnImageOnRead
    }

    func writeImageToDisk(image: UIImage, imagePath: String) {
        print("Writing \(imagePath) to disk")
    }

    func readImageFromDisk(imagePath: String) -> UIImage? {
        if shouldReturnImageOnRead {
            return UIImage.checkmark
        }
        return nil
    }
}
