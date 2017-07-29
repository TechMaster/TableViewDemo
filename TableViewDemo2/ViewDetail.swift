//
//  ViewController.swift
//  TableViewDemo2
//
//  Created by ThietTB on 7/28/17.
//  Copyright © 2017 bipbipdinang. All rights reserved.
//

import UIKit

class ViewDetail: UIViewController {

    //MARK:: Parameter - UI
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblQG: UILabel!
    @IBOutlet weak var lblTĐ: UILabel!
    
    //MARK:: Parameter - User
    var dictCountry = NSMutableDictionary()
    
    //MARK:: Methods - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        let capital = dictCountry.value(forKey: "capital") as! String?
        self.lblTĐ.text = capital
        
        self.lblQG.text = dictCountry.value(forKey: "country") as! String?
        
        let stringImage = dictCountry.value(forKey: "flag") as! String?
        self.image.image = UIImage(named: stringImage!)
    }

}

