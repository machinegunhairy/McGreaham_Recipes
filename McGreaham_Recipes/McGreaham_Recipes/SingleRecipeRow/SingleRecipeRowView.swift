//
//  SingleRecipeRowView.swift
//  Recipes_McGreaham
//
//  Created by William McGreaham on 3/7/25.
//

import SwiftUI

struct SingleRecipeRowView: View {
    @ObservedObject var observableModel: SingleRecipeRowObservableModel
    @Environment(\.openURL) var openURL
    private let darkGray = Color(red: 210.0/255.0,
                                 green: 210.0/255.0,
                                 blue: 210.0/255.0)

    private let lightGray = Color(red: 140.0/255.0,
                                  green: 140.0/255.0,
                                  blue: 140.0/255.0)
    var body: some View {
        ZStack {
            HStack (alignment: .top) {
                imageView
                textViewBlock
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [darkGray, lightGray]), startPoint: .trailing, endPoint: .leading))
            .cornerRadius(20)
            if observableModel.getRecipeUrlIfPossible() != nil {
                webLinkImage
            }
        }
        .onTapGesture {
            if let url = observableModel.getRecipeUrlIfPossible() {
                openURL(url)
            }
        }
    }

    var textViewBlock: some View {
        VStack (alignment: .leading) {
            Text(observableModel.recipeData.cuisine)
                .foregroundStyle(.white)
                .font(.callout)
            Text(observableModel.recipeData.name)
                .font(.title2)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var imageView: some View {
        ZStack(alignment: .center) {
            Image(uiImage: observableModel.recipeImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(.gray)
                .clipShape(.circle)
            if observableModel.loadingImage {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.cyan)
            }
        }
    }

    var webLinkImage: some View {
        Image(systemName: "link")
            .font(.title3)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 8)
            .padding(.bottom, 8)
    }
}

#Preview {
    SingleRecipeRowView(observableModel: SingleRecipeRowObservableModel(recipeData: RecipeDataModel(cuisine: "Malaysian",
                                                                                                    name: "Apam Balik",
                                                                                                    photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                                                                                                    id: UUID(uuidString:  "0c6ca6e7-e32a-4053-b824-1dbf749910d") ?? UUID(), source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
                                                                        )
                        )
}
