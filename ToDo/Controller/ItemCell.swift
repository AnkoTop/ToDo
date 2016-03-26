//
//  ItemCell.swift
//  ToDo
//
//  Created by Anko Top on 24/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configCellWithItem(item: ToDoItem) {
    
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        
        if let timestamp = item.timestamp {
            let date = NSDate(timeIntervalSince1970: timestamp)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            dateLabel.text = dateFormatter.stringFromDate(date)
        }
    }
}
