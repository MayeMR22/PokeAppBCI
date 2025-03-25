import XCTest
import Combine
@testable import ChallengeBCI

final class PokemonListViewControllerTests: XCTestCase {
    var viewModel: PokemonListViewModelSpy!
    var viewController: PokemonListViewController!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = PokemonListViewModelSpy()
        viewController = PokemonListViewController(viewModel: viewModel)
        cancellables = []
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewModel = nil
        viewController = nil
        cancellables = nil
        super.tearDown()
    }

    func test_WhenCallViewDidLoad_ThenCallsViewModelEvent() {
        viewController.viewDidLoad()
        XCTAssertTrue(viewModel.didSendEvent)
    }

    func test_WhenSetUpBindings_ThenErrorSubjectReceivesMessage() {
        viewController.viewDidLoad()
        let errorMessage = "Test Error"
        let expectation = expectation(description: "Error message received")

        viewModel.error
            .sink { error in
                XCTAssertEqual(error, errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.errorDataSubject.send(errorMessage)
        wait(for: [expectation], timeout: 1.0)
    }
}
