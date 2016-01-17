//
//  AlbumTableViewCell.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 16/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  func updateWithViewModel(viewModel: ViewModel) {
    nameLabel?.text = viewModel.title
  }
}

extension AlbumTableViewCell: Updatable {
  typealias ViewModel = AlbumViewModel
}