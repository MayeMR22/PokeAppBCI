import XCTest
import Combine
@testable import ChallengeBCI

final class PokemonListViewModelTests: XCTestCase {
    private var viewModel: PokemonListViewModel!
    private var useCaseMock: PokemonListUseCaseMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCaseMock = PokemonListUseCaseMock()
        viewModel = PokemonListViewModel(pokemonListUseCase: useCaseMock)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        useCaseMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_WhenFetchPokemonList_ThenReturnSuccess() async {
        let expectedResponse = PokemonResponse(pokemons: [PokemonItem(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")])
        useCaseMock.result = .success(expectedResponse)
        
        let expectation = XCTestExpectation(description: "Receive Pokemon data")
        
        viewModel.viewData.sink { response in
            XCTAssertEqual(response.pokemons?[0].name, "Pikachu")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.fetchPokemonList()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_WhenFetchPokemonList_ThenReturnFailure() async {
        let expectedError = NetworkError.invalidResponse
        useCaseMock.result = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Receive error message")
        
        viewModel.error.sink { errorMessage in
            XCTAssertEqual(errorMessage, expectedError.message)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.fetchPokemonList()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_WhenFetchPokemonList_ThenReturnFailureUnknownError() async {
        useCaseMock.result = .failure(NSError(domain: "Unknown", code: 0))
        
        let expectation = XCTestExpectation(description: "Receive unknown error message")
        
        viewModel.error.sink { errorMessage in
            XCTAssertEqual(errorMessage, NetworkError.unknown.message)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.fetchPokemonList()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}
