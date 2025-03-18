import Foundation

enum CustomErrors: Error {
    case decodingDataModelError(String)
}

struct AllRecipesDataModel: Codable {
    let recipes: [RecipeDataModel]
}

struct RecipeDataModel: Identifiable, Codable {
    let cuisine: String
    let name: String
    let photo_url_small: String?
    let id: UUID
    let source_url: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photo_url_small
        case source_url
    }

    init(cuisine: String, name: String, photo_url_small: String?, id: UUID, source_url: String?) {
        self.cuisine = cuisine
        self.name = name
        self.photo_url_small = photo_url_small
        self.id = id
        self.source_url = source_url
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cuisine = try container.decode(String.self, forKey: .cuisine)
        self.name = try container.decode(String.self, forKey: .name)
        let idAsString = try container.decode(String.self, forKey: .id)
        if let idAsUUID = UUID(uuidString: idAsString) {
            self.id = idAsUUID
        } else {
            throw CustomErrors.decodingDataModelError("Could not create UUID from server information")
        }

        self.photo_url_small = try container.decodeIfPresent(String.self, forKey: .photo_url_small)
        self.source_url = try container.decodeIfPresent(String.self, forKey: .source_url)
    }
}
