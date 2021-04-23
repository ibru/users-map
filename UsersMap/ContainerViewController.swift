//
//  ContainerViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit

final class ContainerViewController: UIViewController {
    enum ContentSegment: Int {
        case map = 0, list
    }
    
    @IBOutlet weak var contentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var switchContentView: UIView!
    @IBOutlet weak var contentContainerView: UIView!

    private var mapController: UIViewController!
    private var listController: UIViewController!

    override func loadView() {
        super.loadView()

        switchContentView.layer.cornerRadius = 20
        switchContentView.layer.masksToBounds = true
        switchContentView.layer.shadowColor = UIColor.blue.withAlphaComponent(0.6).cgColor
        switchContentView.layer.shadowOffset = .init(width: 3, height: 3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentSegmentedControl.selectedSegmentIndex = ContentSegment.map.rawValue
    }

    @IBAction func contentSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let selectedSegment = ContentSegment(rawValue: sender.selectedSegmentIndex) else { return }

        switch selectedSegment {
        case .map: showMap()
        case .list: showList()
        }
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
        listController: UIViewController
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! Self
        viewController.set(mapController: mapController, listController: listController)
        return viewController
    }

    private func set(mapController: UIViewController, listController: UIViewController) {
        self.mapController = mapController
        self.listController = listController
    }
}


extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
