import UIKit

final class PokemonListViewController: UIViewController {
    private let viewModel: PokemonListViewModelType
    private let pokemonDetailView = PokemonListView()
    private var pokemonData: [PokemonItem] = []
    private var filteredData: [PokemonItem] = []

    init(viewModel: PokemonListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    override func loadView() {
        view = pokemonDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBindings()
    }

    private func setUpView() {
        view.backgroundColor = .white
        setUpNavigationBar()

        pokemonDetailView.searchBar.delegate = self
        pokemonDetailView.tableView.dataSource = self
        pokemonDetailView.tableView.delegate = self
    }

    func setUpBindings() {
        viewModel.bind(viewModel.viewData) { [weak self] data in
            self?.pokemonData = data.pokemons ?? []
            self?.filteredData = self?.pokemonData ?? []

            self?.pokemonDetailView.tableView.reloadData()
        }

        viewModel.bind(viewModel.error) { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }

        viewModel.send(event: PokemonList.Event.onViewDidLoad)
    }

    private func setUpNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 11/255.0, green: 109/255.0, blue: 195/255.0, alpha: 1.0)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    private func navigateToDetail(for pokemon: PokemonItem) {
        let detailVC = PokemonDetailFactory.setUp(with: pokemon)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonList.Constants.pokemonCell, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        cell.configure(with: pokemonData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(for: pokemonData[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PokemonListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pokemonData = searchText.isEmpty
        ? viewModel.pokemonData
        : filteredData.filter { ($0.name?.lowercased() ?? "").contains(searchText.lowercased()) }
        pokemonDetailView.tableView.reloadData()
    }
}
