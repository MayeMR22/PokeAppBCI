class PokemonListFactory {
    static func setUp() -> PokemonListViewController {
        let useCase = PokemonListUseCase()
        let viewModel = PokemonListViewModel(pokemonListUseCase: useCase)

        return PokemonListViewController(viewModel: viewModel)
    }
}
