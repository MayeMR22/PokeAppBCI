import Combine

protocol BindableType {
    var cancellables: Set<AnyCancellable> { get set }
    func bind<T>(_ publisher: AnyPublisher<T, Never>, to binding: @escaping (T) -> Void)
}

protocol ViewModelEvent {}

protocol BaseViewModelType: BindableType {
    func send(event: ViewModelEvent)
}

class BaseViewModel: BaseViewModelType {
    var cancellables = Set<AnyCancellable>()

    func bind<T>(_ publisher: AnyPublisher<T, Never>, to binding: @escaping (T) -> Void) {
        var cancellable: AnyCancellable?

        cancellable = publisher
            .sink { [weak self] value in
                binding(value)
            }

        if let cancellable {
            cancellables.insert(cancellable)
        }
    }

    func send(event: ViewModelEvent) {}

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
