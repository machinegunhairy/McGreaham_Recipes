//
//  McGreaham_RecipesTests.swift
//  McGreaham_RecipesTests
//
//  Created by William McGreaham on 3/13/25.
//

import XCTest
@testable import McGreaham_Recipes

class McGreaham_RecipesTests: XCTestCase {
    // MARK: - Network response tests
    func testEmptyRecipeData() async {
        let networkManager = MockNetworkManager(getRecipesResponseState: .emptyData)
        Task {
            do {
                guard let getAllResult = try await networkManager.getAllRecipes() else {
                    XCTFail()
                    return
                }
                XCTAssert(getAllResult.count == 0)
            } catch {
                XCTFail()
            }
        }
    }

    func testNilRecipeData() async {
        let networkManager = MockNetworkManager(getRecipesResponseState: .noData)
        Task {
            do {
                if let _ = try await networkManager.getAllRecipes() {
                    XCTFail()
                    return
                }
                XCTAssert(true)
            } catch {
                XCTFail()
            }
        }
    }

    func testGoodRecipeData() async {
        let networkManager = MockNetworkManager(getRecipesResponseState: .goodData)
        Task {
            do {
                guard let getAllResult = try await networkManager.getAllRecipes() else {
                    XCTFail()
                    return
                }
                XCTAssert(getAllResult.count == 2)
            } catch {
                XCTFail()
            }
        }
    }

    // MARK: - RecipeHomeObservableModel Tests

    func testGoodDataRefresh() {
        let networkManager = MockNetworkManager(getRecipesResponseState: .goodData)
        let observableModel = RecipeHomeObservableModel(networkManager: networkManager)
        observableModel.refreshScreen()
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(observableModel.hasAttemptedToGetRecipes)
            XCTAssert(observableModel.visibleRecipes.count == 2)
        }
    }

    func testEmptyDataRefresh() {
        let networkManager = MockNetworkManager(getRecipesResponseState: .emptyData)
        let observableModel = RecipeHomeObservableModel(networkManager: networkManager)
        observableModel.refreshScreen()
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(observableModel.hasAttemptedToGetRecipes)
            XCTAssert(observableModel.visibleRecipes.count == 0)
        }
    }

    func testNoDataRefresh() {
        let networkManager = MockNetworkManager(getRecipesResponseState: .noData)
        let observableModel = RecipeHomeObservableModel(networkManager: networkManager)
        observableModel.refreshScreen()
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(observableModel.hasAttemptedToGetRecipes)
            XCTAssert(observableModel.visibleRecipes.count == 0)
        }
    }

    func testSearch() {
        let networkManager = MockNetworkManager(getRecipesResponseState: .goodData)
        let observableModel = RecipeHomeObservableModel(networkManager: networkManager)
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(observableModel.hasAttemptedToGetRecipes)
            XCTAssert(observableModel.visibleRecipes.count == 2)
            observableModel.searchRecipes(searchString: "British")
            XCTAssert(observableModel.visibleRecipes.count == 1)
            observableModel.searchRecipes(searchString: "z")
            XCTAssert(observableModel.visibleRecipes.count == 0)
            observableModel.searchRecipes(searchString: "")
            XCTAssert(observableModel.visibleRecipes.count == 2)

        }
    }

    // MARK: - SingleRecipeRowObservableModel Tests
    
    func testGetImageFromDisk() {
        // This viewModel loads the image on init
        let singleRowModel = SingleRecipeRowObservableModel(recipeData: getRecipeDataModel(),
                                                            networkingDelegate: MockNetworkManager(getRecipesResponseState: .noData),
                                                            persistanceManager: MockPersistanceManager(shouldReturnImageOnRead: true))
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(singleRowModel.recipeImage == UIImage.checkmark)
        }

    }

    func testGetImageFromNetwork() {
        // This viewModel loads the image on init
        let singleRowModel = SingleRecipeRowObservableModel(recipeData: getRecipeDataModel(),
                                                            networkingDelegate: MockNetworkManager(getRecipesResponseState: .goodData),
                                                            persistanceManager: MockPersistanceManager(shouldReturnImageOnRead: false))
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(singleRowModel.recipeImage == UIImage.add)
        }
    }

    func testGetNoImage() {
        // This viewModel loads the image on init
        let singleRowModel = SingleRecipeRowObservableModel(recipeData: getRecipeDataModel(),
                                                            networkingDelegate: MockNetworkManager(getRecipesResponseState: .noData),
                                                            persistanceManager: MockPersistanceManager(shouldReturnImageOnRead: false))
        let awaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + awaitDuration) {
            XCTAssert(singleRowModel.recipeImage == UIImage())
        }

    }

    private func getRecipeDataModel() -> RecipeDataModel {
        return RecipeDataModel(cuisine: "Malaysian",
                               name: "Apam Balik",
                               photo_url_small: "small.jpg",
                               id: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8") ?? UUID(),
                               source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
    }

}
