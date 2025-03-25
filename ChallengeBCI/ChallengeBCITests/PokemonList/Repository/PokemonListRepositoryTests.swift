import XCTest
@testable import ChallengeBCI

final class PokemonListRepositoryTests: XCTestCase {
    func test_WhenCallPokemonList_ThenReturnPokemonListSuccess() async throws {
        let expectedPokemon = PokemonItem(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let response = PokemonResponse(pokemons: [expectedPokemon])
        
        let request = PokemonList.Request()
        let mockService = MockBaseService<PokemonResponse>(endpoint: request)
        mockService.mockResult = response
        
        let mockFactory = MockServiceFactory()
        mockFactory.mockService = mockService
        
        let repository = PokemonListRespository(serviceFactory: mockFactory)
        
        let result = try await repository.pokemonList()
        
        XCTAssertEqual(result.pokemons?.count, 1)
        XCTAssertEqual(result.pokemons?.first?.name, "Pikachu")
    }
    
    func test_WhenCallPokemonList_ThenReturnPokemonListFailure() async {
        let request = PokemonList.Request()
        let mockService = MockBaseService<PokemonResponse>(endpoint: request)
        mockService.mockError = APINetworkError.invalidData
        
        let mockFactory = MockServiceFactory()
        mockFactory.mockService = mockService
        
        let repository = PokemonListRespository(serviceFactory: mockFactory)
        
        do {
            _ = try await repository.pokemonList()
            XCTFail("Se esperaba un error pero no se lanzó ninguno")
        } catch let error as APINetworkError {
            XCTAssertEqual(error, .invalidData)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
}
