import UIKit

class PokemonDetailViewController: UIViewController {
    private let viewModel: PokemonDetailViewModelType
    let pokemonView = PokemonDetailView()

    init(viewModel: PokemonDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    override func loadView() {
        view = pokemonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBindings()
    }

    private func setUpView() {
        view.backgroundColor = .white
        setUpNavigationBar()
    }

    func setUpBindings() {
        viewModel.bind(viewModel.viewData) { [weak self] data in
            self?.pokemonView.setUpView(viewData: data)
        }

        viewModel.send(event: PokemonDetail.Event.onViewDidLoad)
    }

    private func setUpNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 11/255.0, green: 109/255.0, blue: 195/255.0, alpha: 1.0)

        let backButtonImage = UIImage(systemName: "arrow.left")
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
}
