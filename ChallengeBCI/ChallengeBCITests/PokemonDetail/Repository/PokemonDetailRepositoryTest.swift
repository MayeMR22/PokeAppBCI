import XCTest
@testable import ChallengeBCI

final class PokemonDetailRepositoryTests: XCTestCase {
//    private var repository: PokemonDetailRespository!
//    private var serviceFactoryMock: ServiceFactoryMock!
//
//    override func setUp() {
//        super.setUp()
//        serviceFactoryMock = ServiceFactoryMock()
//        repository = PokemonDetailRespository(serviceFactory: serviceFactoryMock)
//    }
//
//    override func tearDown() {
//        repository = nil
//        serviceFactoryMock = nil
//        super.tearDown()
//    }

    func testFetchPokemonData_Success() async throws {
        // Given
        let request = PokemonList.Request()
        let mockService = MockBaseService<PokemonResponse>(endpoint: request)
        mockService.mockResult = response

        let mockFactory = MockServiceFactory()
        mockFactory.mockService = mockService

        // When
        let response = try await repository.fetchPokemonData(id: "25")

        // Then
        XCTAssertEqual(response.species.name, "Pikachu")
        XCTAssertEqual(response.details.height, 10)
        XCTAssertEqual(response.details.weight, 20)
    }

    func testFetchPokemonData_Failure_InvalidData() async {
        // Given
        serviceFactoryMock.speciesResponse = nil
        serviceFactoryMock.detailResponse = nil

        // When / Then
        do {
            _ = try await repository.fetchPokemonData(id: "25")
            XCTFail("Expected an error to be thrown")
        } catch let error as APINetworkError {
            XCTAssertEqual(error, APINetworkError.invalidData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchPokemonData_Failure_BadResponse() async {
        // Given
        serviceFactoryMock.shouldThrowError = true

        // When / Then
        do {
            _ = try await repository.fetchPokemonData(id: "25")
            XCTFail("Expected an error to be thrown")
        } catch let error as APINetworkError {
            XCTAssertEqual(error, APINetworkError.badResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
