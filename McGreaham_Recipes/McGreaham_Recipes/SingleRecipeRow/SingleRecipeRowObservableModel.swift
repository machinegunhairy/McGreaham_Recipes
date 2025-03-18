//
//  SingleRecipeRowObservableModel.swift
//  Recipes_McGreaham
//
//  Created by William McGreaham on 3/7/25.
//

import Foundation
import UIKit

class SingleRecipeRowObservableModel: ObservableObject {
    @Published var recipeImage: UIImage = UIImage()
    @Published var loadingImage: Bool = false
    public let recipeData: RecipeDataModel

    private let networkingManager: NetworkingDelegate
    private let persistanceManager: PersistanceManagerDelegate

    init(recipeData: RecipeDataModel,
         networkingDelegate: NetworkingDelegate = NetworkManager(),
         persistanceManager: PersistanceManagerDelegate = PersistanceManager()) {
        self.recipeData = recipeData
        self.networkingManager = networkingDelegate
        self.persistanceManager = persistanceManager
        loadImage()
    }

    func getRecipeUrlIfPossible() -> URL? {
        guard let urlString = recipeData.source_url,
              let urlFromString = URL(string: urlString) else { return nil }
        return urlFromString

    }

    private func loadImage() {
        guard let url = getValidUrlIfPossible() else {
            // We could set a default image here if we wanted
            return
        }

        // Load image from disk if possible
        if let savedImage = persistanceManager.readImageFromDisk(imagePath: getSavedFilePath()) {
            recipeImage = savedImage
            return
        }

        Task {
            do {
                await MainActor.run {
                    loadingImage = true
                }

                let downloadedImage = try await networkingManager.getImageWithUrl(url: url)
                persistanceManager.writeImageToDisk(image: downloadedImage, imagePath: getSavedFilePath())

                await MainActor.run {
                    recipeImage = downloadedImage
                    loadingImage = false
                }
            } catch {
                await MainActor.run {
                    loadingImage = false
                }
                print("Image download failure in \(#file) on \(#line)")
            }
        }
    }

    private func getValidUrlIfPossible() -> URL? {
        guard let smallImage = recipeData.photo_url_small else { return nil }
        return URL(string: smallImage)
    }

    private func getSavedFilePath() -> String {
        return  recipeData.cuisine + recipeData.name
    }
}
