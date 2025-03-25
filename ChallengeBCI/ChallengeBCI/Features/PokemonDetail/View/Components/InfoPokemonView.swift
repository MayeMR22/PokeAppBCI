import UIKit

final class InfoPokemonView: UIView {
    private var featureViews: [FeatureView] = []

    private(set) lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func updateData(data: [PokemonDetail.InfoView]?) {
        guard let data = data, data.count == 4 else { return }

        resetFeatureViews()
        configureFeatureViews(from: data)
        setupView()
    }

    private func resetFeatureViews() {
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        featureViews.removeAll()
    }

    private func configureFeatureViews(from data: [PokemonDetail.InfoView]) {
        featureViews = data.map { makeFeatureView(from: $0) }

        let topStackView = createHorizontalStackView(with: Array(featureViews.prefix(2)))
        let bottomStackView = createHorizontalStackView(with: Array(featureViews.suffix(2)))

        containerStackView.addArrangedSubview(topStackView)
        containerStackView.addArrangedSubview(bottomStackView)
    }

    private func makeFeatureView(from info: PokemonDetail.InfoView) -> FeatureView {
        let view = FeatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setData(info: info)
        return view
    }

    private func createHorizontalStackView(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .top
        stackView.distribution = .fillEqually
        return stackView
    }
}
