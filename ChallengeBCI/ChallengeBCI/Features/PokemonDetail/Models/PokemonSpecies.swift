struct PokemonSpecies: Codable {
    var flavorTextEntries: [FlavorTextEntry]?
    var genera: [Genus]

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case genera
    }

    var spanishGenus: Genus? {
        genera.first(where: { $0.language.name.lowercased() == "es" })
    }

    var spanishFlavorText: FlavorTextEntry? {
        flavorTextEntries?.first(where: { $0.language.name.lowercased() == "es" })
    }
}

struct Genus: Codable {
    let genus: String
    let language: Language
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Language

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct Language: Codable {
    let name: String
}
