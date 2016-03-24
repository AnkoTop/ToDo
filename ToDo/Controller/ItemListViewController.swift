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
    @IBOutlet var dataProvider: protocol<UITableViewDataSource, UITableViewDelegate>!
    
    override func viewDidLoad() {
        
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
       
    }
    
}
