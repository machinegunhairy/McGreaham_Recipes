//
//  ContentView.swift
//  Recipes_McGreaham
//
//  Created by William McGreaham on 3/7/25.
//

import SwiftUI

struct RecipeHomeView: View {
    @ObservedObject var observableModel = RecipeHomeObservableModel()
    @State var searchString: String = ""
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                titleView
                searchView
                if observableModel.visibleRecipes.count == 0 && observableModel.hasAttemptedToGetRecipes {
                    nothingToSeeHere
                }
                allRecipeRows
            }
            .padding()
        }
        .padding(.top, 1)
        .background(.black)
        .scrollIndicators(.never)
        .refreshable {
            observableModel.refreshScreen()
            searchString = ""
        }
    }

    private var titleView: some View {
        Text("Recipes")
            .foregroundStyle(.white)
            .font(.largeTitle)
    }

    private var searchView: some View {
        TextField("", text: $searchString, prompt: Text("Search recipes...").foregroundStyle(.gray))
            .keyboardType(.default)
            .submitLabel(.done)
            .foregroundStyle(.black)
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .background(RoundedRectangle(cornerRadius: 8).fill(.white))
            .onChange(of: searchString) {
                observableModel.searchRecipes(searchString: searchString)
            }
    }

    private var nothingToSeeHere: some View {
        Text("It doesn't look like we have any recipes to show you at the moment!")
            .padding()
            .cornerRadius(12)
            .font(.title)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .background(.gray)
            .cornerRadius(12)
    }

    private var allRecipeRows: some View {
        ForEach(observableModel.visibleRecipes) { recipe in
            let recipeModel = SingleRecipeRowObservableModel(recipeData: recipe)
            SingleRecipeRowView(observableModel: recipeModel)
        }
    }
}

#Preview {
    RecipeHomeView()
}
