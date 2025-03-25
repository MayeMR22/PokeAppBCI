protocol PokemonDetailRespositoryType {
    func fetchPokemonData(id: String) async throws -> PokemonDetailsResponse
}

enum ServiceType {
    case species
    case details
}

final class PokemonDetailRespository: PokemonDetailRespositoryType {
    private let serviceFactory: ServiceFactoryType

    init(serviceFactory: ServiceFactoryType = ServiceFactory()) {
        self.serviceFactory = serviceFactory
    }

    func fetchPokemonData(id: String) async throws -> PokemonDetailsResponse {
        return try await withThrowingTaskGroup(of: (ServiceType, Any).self) { group in
            group.addTask {
                let response: PokemonSpecies = try await self.fetchData(
                    with: PokemonDetail.RequestSpecies(id: id),
                    serviceType: .species
                )
                return (.species, response)
            }

            group.addTask {
                let response: PokemonDetailModel = try await self.fetchData(
                    with: PokemonDetail.RequestDetail(id: id),
                    serviceType: .details
                )
                return (.details, response)
            }

            var speciesResponse: PokemonSpecies?
            var detailResponse: PokemonDetailModel?

            for try await (serviceType, response) in group {
                switch serviceType {
                case .species:
                    speciesResponse = response as? PokemonSpecies
                case .details:
                    detailResponse = response as? PokemonDetailModel
                }
            }

            guard let speciesResponse, let detailResponse else {
                throw APINetworkError.invalidData
            }

            return PokemonDetailsResponse(species: speciesResponse, details: detailResponse)
        }
    }

    private func fetchData<T: Decodable>(with request: EndpointType, serviceType: ServiceType) async throws -> T {
        let service: BaseService<T> = serviceFactory.createService(for: request)
        guard let data = try await service.execute() else {
            throw APINetworkError.badResponse
        }
        return data
    }
}
