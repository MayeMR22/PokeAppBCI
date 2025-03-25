import XCTest
import Combine
@testable import ChallengeBCI

final class PokemonListViewModelSpy: PokemonListViewModelType {
    var pokemonData: [PokemonItem] = []
    var cancellables: Set<AnyCancellable> = []
    var didSendEvent = false
    var viewDataSubject = PassthroughSubject<PokemonResponse, Never>()
    var errorDataSubject = PassthroughSubject<String, Never>()
    var viewData: AnyPublisher<PokemonResponse, Never> {
        viewDataSubject.eraseToAnyPublisher()
    }
    var error: AnyPublisher<String, Never>{
        errorDataSubject.eraseToAnyPublisher()
    }
    
    func send(event: ViewModelEvent) {
        if case PokemonList.Event.onViewDidLoad = event {
            didSendEvent = true
        }
    }
    
    func bind<T>(_ publisher: AnyPublisher<T, Never>, to listener: @escaping (T) -> Void) {
        publisher.sink(receiveValue: listener).store(in: &CancellableHolder.shared.cancellables)
    }
    
    func fetchPokemonList() { }
}
