//
//  ListViewController.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 08/01/16.
//  Copyright © 2015 OpenSource. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {

  // MARK: Event Handler
  var eventHandler: IListViewEventHandler?
  
  // MARK: Views
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var tableView: UITableView!
  private let refreshControl = UIRefreshControl()
  
  // MARK: TableViewDataSource
  var dataSource: ListTableViewDataSource = ListTableViewDataSource()
  
  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupInterface()
    
    eventHandler?.didLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if self.tableView.indexPathForSelectedRow != nil {
      self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
    }
  }
  
  private func setupInterface() {
    
    // Table View setup
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: "refreshControlDidChange", forControlEvents: UIControlEvents.ValueChanged)
    tableView.addSubview(refreshControl)
    
    searchBar.delegate = self
    
    refreshControl.beginRefreshing()
    refreshControlDidChange()
  }
  
  // MARK: UIRefreshControl Delegate
  func refreshControlDidChange() {
    refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
    eventHandler?.didBeginRefresh()
  }
  
  // MARK: UISearchBarDelegate
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
    eventHandler?.didChangeFilterMode(true)
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()
    eventHandler?.didChangeFilterMode(false)
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    if searchBar.showsCancelButton == false {
      searchBar.text = ""
    }
    searchBar.resignFirstResponder()
  }
  
  /*
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    print(searchBar.text)
  }*/
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    eventHandler?.didChangeFilterValue(searchText)
  }
  
  // MARK: UITableView Delegate
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    eventHandler?.didSelectItemAtIndexPath(indexPath)
  }
  
}

extension ListViewController: IListView {
  
  func setListFilterModeEnabled(enable: Bool) {
    
  }
  
  func setListTitle(title: String) {
    self.title = title
  }
  
  func setListItems(items: Array<SectionConfigurator>) {
    for sectionConfigurator in items {
      for cellConfigurator in sectionConfigurator.cellConfigurators {
        tableView.registerNib(UINib(nibName: cellConfigurator.reuseIdentifier, bundle: nil), forCellReuseIdentifier: cellConfigurator.reuseIdentifier)
      }
    }
    
    refreshControl.endRefreshing()
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    
    dataSource.items = items
    tableView.reloadData()
  }
  
  func setErrorAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

