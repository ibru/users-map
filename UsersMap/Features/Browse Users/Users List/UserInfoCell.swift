//
//  UserInfoCell.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit
import SDWebImage

final class UserInfoCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()

        avatarView.layer.cornerRadius = 27

        Theme.current.style(headlineBolderLabel: nameLabel)
        Theme.current.style(captionLabel: nicknameLabel)
    }

    func configure(with userInfo: UsersListViewModel.UserInfo) {
        if let imageURL = userInfo.avatarImageURL {
            avatarView.sd_setImage(with: imageURL, completed: nil)
        } else {
            avatarView.backgroundColor = UIColor.gray // TOOD: set some default "unknown" image
        }
        nameLabel.text = userInfo.fullName
        nicknameLabel.text = userInfo.userName
    }
}

extension UserInfoCell {
    static var reuseIdentifier = "User Cell"
}
