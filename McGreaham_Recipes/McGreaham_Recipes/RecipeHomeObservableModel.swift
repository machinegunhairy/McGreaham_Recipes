//
//  RecipeHomeObservableModel.swift
//  Recipes_McGreaham
//
//  Created by William McGreaham on 3/7/25.
//

import Foundation

final class RecipeHomeObservableModel: ObservableObject {
    @Published var visibleRecipes: [RecipeDataModel]
    @Published var hasAttemptedToGetRecipes: Bool = false
    private var allRecipes: [RecipeDataModel]
    private let networkManager: NetworkingDelegate

    init(networkManager: NetworkingDelegate = NetworkManager()) {
        self.visibleRecipes = []
        self.allRecipes = []
        self.networkManager = networkManager
        loadAllRecipes()
    }

    public func refreshScreen() {
        loadAllRecipes()
    }

    private func loadAllRecipes() {
        Task {
            do {
                allRecipes = try await networkManager.getAllRecipes() ?? []
                await MainActor.run {
                    visibleRecipes = allRecipes
                    hasAttemptedToGetRecipes = true
                }
            } catch {
                await MainActor.run {
                    hasAttemptedToGetRecipes = true
                }
                print("All recipes download failure in \(#file) on \(#line)")
            }
        }
    }

    public func searchRecipes(searchString: String) {
        if searchString.isEmpty {
            visibleRecipes = allRecipes
            return
        }
        
        let searchResults = allRecipes.filter { $0.name.lowercased().contains(searchString.lowercased()) ||
            $0.cuisine.lowercased().contains(searchString.lowercased()) }
        Task {
            do {
                await MainActor.run {
                    visibleRecipes = searchResults
                }
            }
        }
    }
}
