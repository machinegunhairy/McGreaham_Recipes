//
//  NetworkManager.swift
//  Recipes_McGreaham
//
//  Created by William McGreaham on 3/7/25.
//

import Foundation
import SwiftUI

protocol NetworkingDelegate {
    func getAllRecipes() async throws -> [RecipeDataModel]?
    func getImageWithUrl(url: URL) async throws -> UIImage
}

enum ImageError: Error {
    case invalidData
}

class NetworkManager: NetworkingDelegate {
    func getAllRecipes() async throws -> [RecipeDataModel]? {
//        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json") else { return nil } // malformed
//        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json") else { return nil } // empty

        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)

        let responseCast = try JSONDecoder().decode(AllRecipesDataModel.self, from: data)
        return responseCast.recipes
    }

    func getImageWithUrl(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidData
        }

        return image
    }
}

enum MockNetworkManagerAllRecipeResponseStates {
    case goodData
    case emptyData
    case noData
}
class MockNetworkManager: NetworkingDelegate {
    private let getRecipesResponseState: MockNetworkManagerAllRecipeResponseStates
    private let twoRecipesGood = [RecipeDataModel(cuisine: "Malaysian",
                                             name: "Apam Balik",
                                             photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                                             id: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8") ?? UUID(),
                                             source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
                              RecipeDataModel(cuisine: "British",
                                              name: "Apple & Blackberry Crumble",
                                              photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                                              id: UUID(uuidString: "599344f4-3c5c-4cca-b914-2210e3b3312f") ?? UUID(),
                                              source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble")]

    init(getRecipesResponseState: MockNetworkManagerAllRecipeResponseStates = .goodData) {
        self.getRecipesResponseState = getRecipesResponseState
    }

    func getAllRecipes() async throws -> [RecipeDataModel]? {
        switch self.getRecipesResponseState {
        case .goodData:
            return twoRecipesGood
        case .emptyData:
            return []
        case .noData:
            return nil
        }
    }
    
    func getImageWithUrl(url: URL) async throws -> UIImage {
        switch self.getRecipesResponseState {
        case .goodData:
            return UIImage.add
        default:
            throw ImageError.invalidData
        }
    }
}
