import Kingfisher

class BasicContentViewController: UIViewController {
    var data: FlowModel? {
        didSet {
            titleLabel.text = data?.title
            titleLabel.textAlignment = NSTextAlignment(from: data?.titleStyle?.textAlign)
            subtitleLabel.text = data?.subtitle
            if let imageUri = data?.imageUri {
                imageView.kf.setImage(with: imageUri)
            }
            imageView.isHidden = (data?.imageUri == nil)
        }
    }

    private lazy var titleLabel = ControlFactory.label(textStyle: .title1, multiline: true)
    private lazy var subtitleLabel: UILabel = ControlFactory.label(textStyle: .title2, multiline: true)
    private lazy var imageView: UIImageView = ControlFactory.imageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel, UIView()])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
        ])
    }
}

