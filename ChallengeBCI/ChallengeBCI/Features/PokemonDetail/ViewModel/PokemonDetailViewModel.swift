import Combine

protocol PokemonDetailViewModelType: BaseViewModelType {
    var viewData: AnyPublisher<PokemonDetail.ViewData, Never> { get }
    var error: AnyPublisher<String, Never> { get }
}

final class PokemonDetailViewModel: BaseViewModel, PokemonDetailViewModelType {
    private let pokemonDetailUseCase: PokemonDetailUseCaseType
    private let viewDataSubject = PassthroughSubject<PokemonDetail.ViewData, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    private var pokemonItem: PokemonItem

    var viewData: AnyPublisher<PokemonDetail.ViewData, Never>{
        viewDataSubject.eraseToAnyPublisher()
    }

    var error: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    init(item: PokemonItem, pokemonDetailUseCase: PokemonDetailUseCaseType) {
        self.pokemonDetailUseCase = pokemonDetailUseCase
        self.pokemonItem = item

        super.init()
    }

    override func send(event: ViewModelEvent) {
        guard let event = event as? PokemonDetail.Event else { return }
        
        switch event {
        case PokemonDetail.Event.onViewDidLoad:
            pokemonDetail()
        }
    }

    private func pokemonDetail() {
        Task { @MainActor in
            do {
                let data = try await pokemonDetailUseCase.execute(id: pokemonItem.id)
                self.viewDataSubject.send(pokemonViewData(data: data))
            } catch let error as AppError {
                errorSubject.send(error.message)
            } catch {
                errorSubject.send(NetworkError.unknown.message)
            }
        }
    }

    func pokemonViewData(data: PokemonDetailsResponse) -> PokemonDetail.ViewData {
        let description = data.species.spanishFlavorText?.flavorText.replacingOccurrences(of: "\n", with: "")
        return PokemonDetail.ViewData(
            id: data.details.id,
            image: pokemonItem.image,
            name: data.details.name,
            height: data.details.height,
            weight: data.details.weight,
            abilities: data.details.abilities?.first?.ability.name ?? "Desconocida",
            description: description ?? "Descripción no disponible",
            category: data.species.spanishGenus?.genus ?? "Desconocida",
            info: makeInfoViews(from: data)
        )
    }

    private func makeInfoViews(from data: PokemonDetailsResponse) -> [PokemonDetail.InfoView] {
        let weight = FormatHelper.toKilograms(data.details.weight)
        let height = FormatHelper.toMeters(data.details.height)
        let ability = data.details.abilities?.first?.ability.name ?? "N/A"
        let category = data.species.spanishGenus?.genus.replacingOccurrences(of: "Pokémon", with: "").trimmingCharacters(in: .whitespacesAndNewlines)

        return [
            PokemonDetail.InfoView(image: "weight", title: "Peso", value: weight),
            PokemonDetail.InfoView(image: "height", title: "Altura", value: height),
            PokemonDetail.InfoView(image: "category", title: "Categoría", value: category),
            PokemonDetail.InfoView(image: "ability", title: "Habilidad", value: ability)
        ]
    }
}
