import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = [ModalFullScreenExample(), PageSheetExample(), InlineExample()]
        viewControllers![0].tabBarItem.title = "Modal"
        viewControllers![1].tabBarItem.title = "Sheet"
        viewControllers![2].tabBarItem.title = "Inline"
    }
}
