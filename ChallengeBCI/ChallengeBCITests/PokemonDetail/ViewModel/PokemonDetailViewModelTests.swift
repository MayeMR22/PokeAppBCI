import XCTest
import Combine
@testable import ChallengeBCI

final class PokemonDetailViewModelTests: XCTestCase {
    private var viewModel: PokemonDetailViewModel!
    private var useCaseMock: PokemonDetailUseCaseSpy!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        useCaseMock = PokemonDetailUseCaseSpy()
        let pokemonItem = PokemonItem(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")
        viewModel = PokemonDetailViewModel(item: pokemonItem, pokemonDetailUseCase: useCaseMock)
    }

    override func tearDown() {
        viewModel = nil
        useCaseMock = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func test_WhenCallViewDidLoad_ThenSuccessfulDataFetch() async {
        let expectedData = PokemonDetailMock.makeCombinedPokemon()
        useCaseMock.result = .success(expectedData)

        let expectation = XCTestExpectation(description: "Expect viewData to emit values")

        viewModel.viewData.sink { viewData in
            XCTAssertEqual(viewData.id, expectedData.details.id)
            XCTAssertEqual(viewData.name, expectedData.details.name)
            XCTAssertEqual(viewData.info?[0].value, "6.0 kg")
            XCTAssertEqual(viewData.info?[1].value, "4.0 m")
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.send(event: PokemonDetail.Event.onViewDidLoad)

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func test_WhenCallViewDidLoad_ThenReturnFailure() async {
        useCaseMock.result = .failure(NSError(domain: "TestError", code: 123, userInfo: nil))

        let expectation = XCTestExpectation(description: "Execute called")

        Task {
            viewModel.send(event: PokemonDetail.Event.onViewDidLoad)
            await Task.yield()
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(useCaseMock.executeWasCalled)
    }
}
