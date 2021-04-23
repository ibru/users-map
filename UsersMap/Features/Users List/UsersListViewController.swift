//
//  UsersListViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit

final class UsersListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: view.bounds.width, height: 60)
    }
}

extension UsersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserInfoCell.reuseIdentifier,
            for: indexPath
        ) as! UserInfoCell


        //cell.configure(with: <#T##UserInfo#>)

        return cell
    }
}

extension UsersListViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: Any
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UsersListViewController") as! Self
        //viewController.viewModel = viewModel
        return viewController
    }
}
