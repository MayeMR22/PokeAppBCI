import XCTest
@testable import ChallengeBCI

class MockBaseService<T: Decodable>: BaseService<T> {
    var mockResult: T?
    var mockError: Error?

    override func execute() async throws -> T? {
        if let error = mockError { throw error }
        return mockResult
    }
}

class MockServiceFactory: ServiceFactoryType {
    var mockService: Any?

    func createService<T>(for endpoint: EndpointType) -> BaseService<T> where T : Decodable {
        return mockService as! BaseService<T>
    }
}
