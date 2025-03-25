@testable import ChallengeBCI
import XCTest

enum PokemonDetailMock {
    static func makeCombinedPokemon() -> PokemonDetailsResponse {
        PokemonDetailsResponse(
            species: PokemonSpecies(
                flavorTextEntries: [
                    FlavorTextEntry(
                        flavorText: "Un Pokémon ratón eléctrico.",
                        language: Language(name: "es")
                    )
                ],
                genera: [
                    Genus(
                        genus: "Pokémon Ratón",
                        language: Language(name: "es")
                    )
                ]
            ), details: PokemonDetailModel(
                id: 1,
                name: "Pikachu",
                height: 40.0,
                weight: 60.0,
                abilities: [AbilityEntry(ability: Ability(name: "Static"))],
                pokemonType: Types(name: "Electric")
            )
        )
    }
}
