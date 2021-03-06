//
//  ContainerViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit
import Combine

final class ContainerViewController: UIViewController {

    var viewModel: ContainerViewModel!

    enum ContentSegment: Int {
        case map = 0, list
    }
    
    @IBOutlet weak var contentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var switchContentView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var countButton: UIButton!

    private var mapController: UIViewController!
    private var listController: UIViewController!

    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        super.loadView()

        switchContentView.makeRoundedAndShadowed()

        countButton.titleLabel?.font = Theme.current.fontTheme.usersCountFont()
        countButton.titleLabel?.adjustsFontSizeToFitWidth = true
        countButton.setTitleColor(Theme.current.colorTheme.primaryFontColor(), for: .normal)
        countButton.makeRoundedAndShadowed(cornerRadius: 24)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentSegmentedControl.selectedSegmentIndex = ContentSegment.map.rawValue
        showMap()

        viewModel
            .$usersCount
            .map(String.init)
            .sink { [weak self] in
                self?.countButton.setTitle("\($0)", for: .normal)
            }
            .store(in: &cancellables)
    }

    @IBAction func contentSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let selectedSegment = ContentSegment(rawValue: sender.selectedSegmentIndex) else { return }

        switch selectedSegment {
        case .map: showMap()
        case .list: showList()
        }
    }

    @IBAction func countButtonTouched(_ sender: UIButton) {
        viewModel.changeUsersCount()
    }

}

extension ContainerViewController {
    private func showMap() {
        cycle(from: listController, to: mapController)
    }

    private func showList() {
        cycle(from: mapController, to: listController)
    }

    private func cycle(from oldViewController: UIViewController, to newViewController: UIViewController) {
        oldViewController.willMove(toParent: nil)

        self.addChild(newViewController)
        contentContainerView.addSubview(newViewController.view)

        newViewController.view.frame = contentContainerView.bounds
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        }) { (finished) in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
            newViewController.didMove(toParent: self)
        }
    }
}

extension ContainerViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withMapController mapController: UIViewController,
        listController: UIViewController,
        viewModel: ContainerViewModel
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! Self
        viewController.set(mapController: mapController, listController: listController)
        viewController.viewModel = viewModel
        return viewController
    }

    private func set(mapController: UIViewController, listController: UIViewController) {
        self.mapController = mapController
        self.listController = listController
    }
}
