import Foundation

struct ControlFactory {
    static func setupDefaultAppearance() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControl.pageIndicatorTintColor = UIColor(white: 0.6, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(white: 0.1, alpha: 1)
    }
    
    static func button(title: String?=nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .black
        return button
    }
    
    static func label(textStyle: UIFont.TextStyle, multiline: Bool=false) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = CommonColor.lightText
        label.numberOfLines = multiline ? 0 : 1
        
        switch textStyle {
        case .title1: label.textColor = CommonColor.darkText
        case .title2: label.textColor = CommonColor.lightText
        default: break
        }
        return label
    }
    
    static func imageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
}

struct CommonColor {
    static let darkText = UIColor(white: 0.01, alpha: 1)
    static let lightText = UIColor(white: 0.1, alpha: 1)
}
