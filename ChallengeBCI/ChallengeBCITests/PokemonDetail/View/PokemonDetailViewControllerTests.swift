import XCTest
import Combine
@testable import ChallengeBCI

final class PokemonDetailViewControllerTests: XCTestCase {
    var viewModel: PokemonDetailViewModelSpy!
    var viewController: PokemonDetailViewController!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = PokemonDetailViewModelSpy()
        viewController = PokemonDetailViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewModel = nil
        viewController = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func test_WhenInitialize_ThenSetView() {
        XCTAssertNotNil(viewController.view)
    }

    func test_WhenCallViewDidLoad_ThenCallsViewModelEvent() {
        XCTAssertTrue(viewModel.didSendEvent)
    }

    func test_WhenCallViewModel_ThenCallDataBinding() {
        let viewData = PokemonDetail.ViewData(
            id: 1,
            image: "pikachu.png",
            name: "Pikachu",
            height: 4,
            weight: 60,
            abilities: "Electric",
            description: "A cute electric mouse Pokémon.",
            category: "Mouse Pokémon",
            info: []
        )
        viewModel.viewDataSubject.send(viewData)
        XCTAssertEqual(viewController.pokemonView.nameLabel.text, viewData.name)
        XCTAssertEqual(viewController.pokemonView.idLabel.text, "Nº 001")
        XCTAssertEqual(viewController.pokemonView.descriptionLabel.text, viewData.description)
    }
}
