class PokemonDetailFactory {
    static func setUp(with item: PokemonItem) -> PokemonDetailViewController {
        let detailUseCase = PokemonDetailUseCase()
        let viewModel = PokemonDetailViewModel(
            item: item,
            pokemonDetailUseCase: detailUseCase
        )

        return PokemonDetailViewController(viewModel: viewModel)
    }
}
