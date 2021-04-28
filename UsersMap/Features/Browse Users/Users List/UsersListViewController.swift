//
//  UsersListViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit
import Combine

final class UsersListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private(set) var viewModel: UsersListViewModel!

    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()
        collectionView.dataSource = self
        collectionView.delegate = self

        titleLabel.font = Theme.current.fontTheme.navigationTitleFont()
        titleLabel.textColor = Theme.current.colorTheme.primaryFontColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$users
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$error
            .sink { [weak self] in
                if let error = $0, self?.isViewLoaded ?? false, self?.view.window != nil {
                    let alertController = UIAlertController(
                        title: NSLocalizedString("Error", comment: ""),
                        message: NSLocalizedString("Oops. An error happened:\n \(error.localizedDescription)", comment: ""),
                        preferredStyle: .alert)
                    alertController.addAction(
                        .init(
                            title: NSLocalizedString("Okay", comment: ""),
                            style: .cancel)
                    )
                    self?.present(alertController, animated: true)
                }
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let insetsWidth = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.contentInset.left + collectionView.contentInset.right
            flowLayout.itemSize = .init(width: collectionView.bounds.width - insetsWidth, height: 60)
        }
    }
}

extension UsersListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserInfoCell.reuseIdentifier,
            for: indexPath
        ) as! UserInfoCell

        let user = viewModel.users[indexPath.item]
        cell.configure(with: user)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.item]
        viewModel.select(user: user)
    }
}

extension UsersListViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: UsersListViewModel
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UsersListViewController") as! Self
        viewController.viewModel = viewModel
        return viewController
    }
}
