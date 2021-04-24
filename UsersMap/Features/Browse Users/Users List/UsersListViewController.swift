//
//  UsersListViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit
import Combine

final class UsersListViewController: UIViewController {

    private(set) var viewModel: UsersListViewModel!

    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        viewModel.$users
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: view.bounds.width, height: 60)
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
