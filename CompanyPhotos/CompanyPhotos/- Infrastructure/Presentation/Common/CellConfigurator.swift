//
//  CellConfigurator.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 09/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

struct SectionConfigurator {
  var cellConfigurators: [CellConfiguratorType] = Array<CellConfiguratorType>() 
  
  init(cellConfigurators:[CellConfiguratorType]) {
    self.cellConfigurators = cellConfigurators
  }
}

protocol CellConfiguratorType {
  
  var reuseIdentifier: String { get }
  var cellClass: AnyClass { get }
  
  func updateCell(cell: UITableViewCell)
}

struct CellConfigurator<Cell where Cell: Updatable, Cell: UITableViewCell> {
 
  let viewModel: Cell.ViewModel
  let reuseIdentifier: String = Cell.className
  let cellClass: AnyClass = Cell.self

  func updateCell(cell: UITableViewCell) {
    if let cell = cell as? Cell {
      cell.updateWithViewModel(viewModel)
    }
  }
}

extension CellConfigurator: CellConfiguratorType {}