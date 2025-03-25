protocol PokemonListUseCaseType {
    func execute() async throws -> PokemonResponse
}

struct PokemonListUseCase: PokemonListUseCaseType {
    private let repository: PokemonListRespositoryType

    init(repository: PokemonListRespositoryType = PokemonListRespository()) {
        self.repository = repository
    }

    func execute() async throws -> PokemonResponse {
        return try await repository.pokemonList()
    }
}
