//
//  ExpandableRowView.swift
//  TableViewDemo2
//
//  Created by ThietTB on 8/10/17.
//  Copyright © 2017 bipbipdinang. All rights reserved.
//

import UIKit



protocol ExpandableRowDelegate{
    func toggleSection(header: ExpandableRow, section: Int)
}


class ExpandableRow: UITableViewCell{
    var delegate: ExpandableRowDelegate
    var row: Int!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(selectRowAction)))
    }
    
    func selectRowAction(gestureRecognizer: UISwipeGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpandableRow
        self.delegate.toggleSection(header: self, section: cell.row)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func customInit(title: String, section: Int, delegate: ExpandableRowDelegate) {
        self.textLabel?.text = title
        self.row = section
        self.delegate = delegate
    }
    
    
    
}
