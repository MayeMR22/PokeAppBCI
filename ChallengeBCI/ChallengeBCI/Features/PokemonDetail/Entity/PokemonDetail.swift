import Foundation

enum PokemonDetail {
    enum Event: ViewModelEvent, Equatable {
        case onViewDidLoad
    }

    struct ViewData {
        let id: Int?
        let image: String?
        let name: String?
        let height: Double?
        let weight: Double?
        let abilities: String?
        let description: String?
        let category: String?
        let info: [InfoView]?
    }

    struct InfoView {
        let image: String?
        let title: String?
        let value: String?
    }

    struct RequestDetail: EndpointType {
        let id: String
        var baseURL: String { "https://pokeapi.co/api/v2/" }
        var path: String { "pokemon/\(id)" }

        var urlRequest: URLRequest? {
            guard let url = URL(string: baseURL + path) else { return nil }
            return URLRequest(url: url)
        }
    }

    struct RequestSpecies: EndpointType {
        let id: String
        var baseURL: String { "https://pokeapi.co/api/v2/" }
        var path: String { "pokemon-species/\(id)" }

        var urlRequest: URLRequest? {
            guard let url = URL(string: baseURL + path) else { return nil }
            return URLRequest(url: url)
        }
    }
}
