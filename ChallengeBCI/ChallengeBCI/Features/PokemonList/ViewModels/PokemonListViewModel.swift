import Combine

protocol PokemonListViewModelType: BaseViewModelType {
    var pokemonData: [PokemonItem] { get }
    var viewData: AnyPublisher<PokemonResponse, Never> { get }
    var error: AnyPublisher<String, Never> { get }
    func fetchPokemonList()
}

final class PokemonListViewModel: BaseViewModel, PokemonListViewModelType {
    private let pokemonListUseCase: PokemonListUseCaseType
    private let viewDataSubject = PassthroughSubject<PokemonResponse, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    var pokemonData: [PokemonItem] = []

    var viewData: AnyPublisher<PokemonResponse, Never>{
        viewDataSubject.eraseToAnyPublisher()
    }

    var error: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    init(pokemonListUseCase: PokemonListUseCaseType) {
        self.pokemonListUseCase = pokemonListUseCase
        super.init()
    }

    override func send(event: ViewModelEvent) {
        guard let event = event as? PokemonList.Event else { return }

        switch event {
        case PokemonList.Event.onViewDidLoad:
            fetchPokemonList()
        }
    }

    func fetchPokemonList() {
        Task { @MainActor in
            do {
                let data = try await self.pokemonListUseCase.execute()
                pokemonData = data.pokemons ?? []
                self.viewDataSubject.send(data)
            } catch let error as AppError {
                errorSubject.send(error.message)
            } catch {
                errorSubject.send(NetworkError.unknown.message)
            }
        }
    }
}
