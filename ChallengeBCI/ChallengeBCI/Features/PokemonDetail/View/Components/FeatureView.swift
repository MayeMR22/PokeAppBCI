import UIKit

final class FeatureView: UIView {
    private(set) lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private(set) lazy var featureTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var featureValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        addSubview(contentStackView)
        let components = [image, featureTypeLabel]
        components.forEach { contentStackView.addArrangedSubview($0) }

        addSubview(containerView)
        containerView.addSubview(featureValueLabel)
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 16),
            image.widthAnchor.constraint(equalToConstant: 16),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            featureValueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            featureValueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            featureValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            featureValueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }

    func setData(info: PokemonDetail.InfoView) {
        featureTypeLabel.text = info.title
        featureValueLabel.text = info.value
        image.image = UIImage(named: info.image ?? "")
        setUpView()
        setupConstraint()
    }
}
