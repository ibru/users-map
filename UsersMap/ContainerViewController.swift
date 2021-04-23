//
//  ContainerViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    @IBOutlet weak var contentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var switchContentView: UIView!

    override func loadView() {
        super.loadView()

        switchContentView.layer.cornerRadius = 20
        switchContentView.layer.masksToBounds = true
        switchContentView.layer.shadowColor = UIColor.blue.withAlphaComponent(0.6).cgColor
        switchContentView.layer.shadowOffset = .init(width: 3, height: 3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentSegmentedControl.selectedSegmentIndex = 0
    }

    @IBAction func contentSegmentedControlValueChanged(_ sender: UISegmentedControl) {
    }
}
