import Foundation

enum PokemonList {
    enum Constants {
        static let pokemonCell = "PokemonCell"
        static let searchPlaceholder = "Search Pokemón"
    }
    enum Event: ViewModelEvent, Equatable {
        case onViewDidLoad
    }

    struct Request: EndpointType {
        var baseURL: String { "https://pokeapi.co/api/v2/" }
        var path: String { "pokemon?limit=151&offset=0" }

        var urlRequest: URLRequest? {
            guard let url = URL(string: baseURL + path) else { return nil }
            return URLRequest(url: url)
        }
    }
}
