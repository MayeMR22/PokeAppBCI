import Foundation

enum APINetworkError: Error {
    case invalidURL
    case badResponse
    case invalidData
    case invalidRequest
    case noFound
}

extension APINetworkError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString("En estos momentos la aplicación no está disponible, por favor ingresa más tarde.", comment: "apiError")
    }
}

protocol EndpointType {
    var baseURL: String { get }
    var path: String { get }
    var urlRequest: URLRequest? { get }
}

protocol ServiceContractType {
    associatedtype ResponseType: Decodable
    func execute() async throws -> ResponseType?
}

class BaseService<T: Decodable>: ServiceContractType {
    private var endpoint: EndpointType

    init(endpoint: EndpointType) {
        self.endpoint = endpoint
    }

    func execute() async throws -> T? {
        guard let request = endpoint.urlRequest else {
            throw APINetworkError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw APINetworkError.badResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
