protocol PokemonListRespositoryType {
    func pokemonList() async throws -> PokemonResponse
}

final class PokemonListRespository: PokemonListRespositoryType {
    private let serviceFactory: ServiceFactoryType

    init(serviceFactory: ServiceFactoryType = ServiceFactory()) {
        self.serviceFactory = serviceFactory
    }

    func pokemonList() async throws -> PokemonResponse {
        let request = PokemonList.Request()
        let service: BaseService<PokemonResponse> = serviceFactory.createService(for: request)
        guard let data = try await service.execute() else {
            throw APINetworkError.invalidData
        }

        return data
    }
}
