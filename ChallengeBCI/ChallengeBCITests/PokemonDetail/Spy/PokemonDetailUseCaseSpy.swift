import XCTest
@testable import ChallengeBCI

final class PokemonDetailUseCaseSpy: PokemonDetailUseCaseType {
    var result: Result<PokemonDetailsResponse, Error>?
    var executeWasCalled = false

    func execute(id: String) async throws -> PokemonDetailsResponse {
        executeWasCalled = true
        guard let result = result else { throw NSError(domain: "No Result", code: 0) }
        
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}
