import XCTest
import Combine
@testable import ChallengeBCI

final class PokemonDetailViewModelSpy: PokemonDetailViewModelType {
    var cancellables: Set<AnyCancellable> = []
    var didSendEvent = false
    var viewDataSubject = PassthroughSubject<PokemonDetail.ViewData, Never>()
    var errorDataSubject = PassthroughSubject<String, Never>()
    var viewData: AnyPublisher<PokemonDetail.ViewData, Never> {
        viewDataSubject.eraseToAnyPublisher()
    }
    var error: AnyPublisher<String, Never>{
        errorDataSubject.eraseToAnyPublisher()
    }

    func send(event: ViewModelEvent) {
        if case PokemonDetail.Event.onViewDidLoad = event {
            didSendEvent = true
        }
    }

    func bind<T>(_ publisher: AnyPublisher<T, Never>, to listener: @escaping (T) -> Void) {
        publisher.sink(receiveValue: listener).store(in: &CancellableHolder.shared.cancellables)
    }
}

final class CancellableHolder {
    static let shared = CancellableHolder()
    var cancellables = Set<AnyCancellable>()
}
