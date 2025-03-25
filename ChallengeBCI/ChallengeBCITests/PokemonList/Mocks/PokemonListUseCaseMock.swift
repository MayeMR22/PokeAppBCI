import XCTest
@testable import ChallengeBCI

final class PokemonListUseCaseMock: PokemonListUseCaseType {
    var result: Result<PokemonResponse, Error>!

    func execute() async throws -> PokemonResponse {
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case .none:
            fatalError("Result not set in mock")
        }
    }
}
