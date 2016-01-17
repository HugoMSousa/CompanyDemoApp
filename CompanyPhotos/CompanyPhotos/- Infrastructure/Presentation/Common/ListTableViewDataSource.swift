//
//  ListTableViewDataSource.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 09/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import UIKit

class ListTableViewDataSource: NSObject, UITableViewDataSource {
  
  var items: [SectionConfigurator] = Array<SectionConfigurator>()
  
  override init() {}
  
  init(items: [SectionConfigurator]) {
    self.items = items
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return items.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items[section].cellConfigurators.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let sectionConfigurator = items[indexPath.section]
    let cellConfigurator = sectionConfigurator.cellConfigurators[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier(cellConfigurator
      .reuseIdentifier, forIndexPath: indexPath)
    cellConfigurator.updateCell(cell)
    return cell
  }
}
