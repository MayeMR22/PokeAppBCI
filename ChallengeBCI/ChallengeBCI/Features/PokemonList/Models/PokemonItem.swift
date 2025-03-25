struct PokemonItem: Codable {
    var name: String?
    var url: String?

    var id: String {
        guard let url = url,
              let lastComponent = url.split(separator: "/").filter({ !$0.isEmpty }).last else {
            return "0"
        }
        return String(lastComponent)
    }

    var image: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
