struct PokemonResponse : Codable {
    var pokemons : [PokemonItem]?

    enum CodingKeys: String, CodingKey {
        case pokemons = "results"
    }
}
