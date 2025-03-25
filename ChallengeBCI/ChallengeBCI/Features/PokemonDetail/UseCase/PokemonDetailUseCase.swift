protocol PokemonDetailUseCaseType {
    func execute(id: String) async throws -> PokemonDetailsResponse
}

struct PokemonDetailUseCase: PokemonDetailUseCaseType {
    private let repository: PokemonDetailRespositoryType

    init(repository: PokemonDetailRespositoryType = PokemonDetailRespository()) {
        self.repository = repository
    }

    func execute(id: String) async throws -> PokemonDetailsResponse {
        return try await repository.fetchPokemonData(id: id)
    }
}
