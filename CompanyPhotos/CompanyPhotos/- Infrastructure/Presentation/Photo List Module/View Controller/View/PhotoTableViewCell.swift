//
//  PhotoTableViewCell.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 17/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit
import Haneke

class PhotoTableViewCell: UITableViewCell {
  
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  
  func updateWithViewModel(viewModel: ViewModel) {

    if let url = NSURL(string:viewModel.urlThumbnailString) {
      photoImageView?.hnk_setImageFromURL(url)
    }
    nameLabel?.text = viewModel.name
  }
}

extension PhotoTableViewCell: Updatable {
  typealias ViewModel = PhotoViewModel
}
