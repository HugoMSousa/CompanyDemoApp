//
//  UserTableViewCell.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var catchPhraseLabel: UILabel!
  
  func updateWithViewModel(viewModel: ViewModel) {
    nameLabel?.text = viewModel.name
    emailLabel?.text = viewModel.email
    catchPhraseLabel?.text = viewModel.catchPhrase
  }
}

extension UserTableViewCell: Updatable {
  typealias ViewModel = UserViewModel
}
