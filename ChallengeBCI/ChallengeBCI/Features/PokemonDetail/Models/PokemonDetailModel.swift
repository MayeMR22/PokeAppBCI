struct PokemonDetailModel : Codable {
    let id : Int?
    let name : String?    
    let height: Double?
    let weight: Double?
    let abilities: [AbilityEntry]?
    let pokemonType: Types?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abilities
        case height
        case weight
        case pokemonType
    }
}
