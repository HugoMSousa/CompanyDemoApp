//
//  ListViewIO.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 08/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation

protocol IListView: class {
  //func setBeginRefresh()
  func setListTitle(title: String)
  func setListItems(items: Array<SectionConfigurator>)
  func setErrorAlert(title: String, message: String)
  // Filter Mode
  func setListFilterModeEnabled(enable: Bool)
}

protocol IListViewEventHandler {
  func didLoad()
  func didBeginRefresh()
  func didSelectItemAtIndexPath(indexPath: NSIndexPath)
  
  // Filter Mode
  func didChangeFilterMode(enabled: Bool)
  func didChangeFilterValue(value: String)
}

