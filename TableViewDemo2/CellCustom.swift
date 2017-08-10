//
//  CellCustom.swift
//  TableViewDemo2
//
//  Created by ThietTB on 8/1/17.
//  Copyright © 2017 bipbipdinang. All rights reserved.
//

import UIKit

class CellCustom : UITableViewCell{
    
    @IBOutlet weak var textLabelCustom: UILabel!
    
    func configureCell(nameCountry : String){
        
        self.textLabelCustom?.text = nameCountry
        
    }
}
