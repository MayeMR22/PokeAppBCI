import UIKit

class PokemonDetailView: UIView {
    private(set) lazy var backImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "header"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()

    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var imagePokemon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var infoView: InfoPokemonView = {
        let view = InfoPokemonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let components = [contentView, backImageView, imagePokemon, nameLabel, idLabel, descriptionLabel, infoView]
        components.forEach {  scrollView.addSubview($0) }
        addSubview(scrollView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpView(viewData: PokemonDetail.ViewData?) {
        loadImage(from: viewData?.image ?? "")
        nameLabel.text = viewData?.name
        if let number = viewData?.id {
            idLabel.text = String(format: "Nº %03d", number)
        }
        descriptionLabel.text = viewData?.description

        infoView.updateData(data: viewData?.info)
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imagePokemon.image = UIImage(data: data)
                }
            }
        }
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -20),
            backImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),

            imagePokemon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            imagePokemon.heightAnchor.constraint(equalToConstant: 180),
            imagePokemon.widthAnchor.constraint(equalToConstant: 180),
            imagePokemon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: imagePokemon.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),

            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),

            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 80),

            infoView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            infoView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
}
