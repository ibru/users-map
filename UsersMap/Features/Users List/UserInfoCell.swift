//
//  UserInfoCell.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit

final class UserInfoCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!

    func configure(with userInfo: UserInfo) {
        if let imageURL = userInfo.avatarImageURL {
            // load image using https://github.com/SDWebImage/SDWebImage
            //avatarView.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
        } else {
            avatarView.backgroundColor = UIColor.gray // TOOD: set some default "unknown" image
        }
        nameLabel.text = userInfo.fullName
        nicknameLabel.text = userInfo.userName
    }
}

struct UserInfo {
    let avatarImageURL: URL?
    let fullName: String
    let userName: String
}

extension UserInfoCell {
    static var reuseIdentifier = "User Cell"
}
