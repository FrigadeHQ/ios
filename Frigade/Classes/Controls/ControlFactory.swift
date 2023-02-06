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
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
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
    static let darkText = UIColor(fromRGB: 0x000000)
    static let lightText = UIColor(fromRGB: 0x6B6B6B)
}

extension UIColor {
    convenience init(fromRGB value: Int) {
        assert(value >= 0 && value <= 0xFFFFFF)
        self.init(red: CGFloat((Float((value & 0xff0000) >> 16)) / 255.0),
                  green: CGFloat((Float((value & 0x00ff00) >> 8)) / 255.0),
                  blue: CGFloat((Float((value & 0x0000ff) >> 0)) / 255.0),
                  alpha: 1.0)
    }
}
