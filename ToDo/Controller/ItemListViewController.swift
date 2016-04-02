//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Anko Top on 24/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: protocol<UITableViewDataSource, UITableViewDelegate, ItemManagerSettable>!
    
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        dataProvider.itemManager = itemManager
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ItemListViewController.showDetails(_:)), name: "ItemSelectedNotification", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addItem(sender: UIBarButtonItem) {
        
        if let nextViewController = storyboard?.instantiateViewControllerWithIdentifier("InputViewController")
        as? InputViewController {
            nextViewController.itemManager = self.itemManager
            presentViewController(nextViewController, animated: true, completion: nil)
        }
    }
    
    func showDetails(sender: NSNotification) {
        
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }
        
        if let nextViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController {
            
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
