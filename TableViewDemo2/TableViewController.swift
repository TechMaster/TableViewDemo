//
//  TableViewController.swift
//  TableViewDemo2
//
//  Created by ThietTB on 7/28/17.
//  Copyright © 2017 bipbipdinang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController ,ExpandableHeaderViewDelegate {
    
    //MARK:: Parameters - User
    
    var continent_Array = [String]() // Mảng lưu tên các Châu lục -> tạo section cho TableView
    var status : Bool = false
    
    var country_Dict = NSMutableDictionary() // Dictionary lưu key là Continent(Các châu lục) với value tương ứng là 1 mảng Object Coutry(tên nước,thủ đô,cờ)
    
    var All_Array = [[String: Bool]]()
    
    //MARK:: Methods - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDataFromPlist()
    }
    
    //MARK:: Methods - Data
    // Khởi tạo dữ liệu từ file Data.plist
    func loadDataFromPlist(){
        var path : String = ""
        path = Bundle.main.path(forResource: "Data", ofType: "plist")!
        let dataArray: NSArray! = NSArray(contentsOfFile: path)
        
        for i in 0 ..< dataArray.count{
            let dict = dataArray[i] as! NSDictionary
            
            let continent = dict.value(forKey: "continent") as! String
            
            self.continent_Array.append(continent)
            
            let country_Obj = dict.value(forKey: "countries") as! NSArray
            
            self.country_Dict.setValue(country_Obj, forKey: continent)
            
            let dic = [continent: false]
            
            self.All_Array.append(dic)
            
        }
        print(All_Array)
        
    }
    
    // MARK: - Table view data source
    // Trả về số lượng Section
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return continent_Array.count
        
    }
    // Trả về số lượng Row(Hàng) trong Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectiontitle = continent_Array[section]
        let sectionObject = country_Dict.object(forKey: sectiontitle) as! NSArray
        return sectionObject.count
    }

    // Hiển thị dữ liệu cho từng Cell trong mỗi hàng(Row)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! CellCustom
        
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "labelCell") as! CellCustom
        }
        // Lấy ra châu lục mà tương ứng với section
        let sectionTitle = continent_Array[indexPath.section]
        // Lấy ra Mảng Obj_Country thông qua key(Châu lục-Continent) ứng với nó
        let sectionValueCountry = country_Dict[sectionTitle] as! NSArray
        // Lấy ra 1 cái Obj_Country
        let countryObject = sectionValueCountry[indexPath.row] as! NSDictionary
        
        let valueForCell = countryObject.value(forKey: "country") as! String?
        
        cell.configureCell(nameCountry: valueForCell!)
        
        return cell
    }

    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        All_Array[section][continent_Array[section]] = !All_Array[section][continent_Array[section]]!

        tableView.beginUpdates()
        let sectionTitle = continent_Array[section]
        let sectionValueCountry = country_Dict[sectionTitle] as! NSArray
        
        for i in 0 ..< sectionValueCountry.count{
            
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            print("toggle")
        }
        tableView.endUpdates()

    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: continent_Array[section], section: section, delegate: self)
        return header
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if All_Array[indexPath.section][continent_Array[indexPath.section]] == true {
            return 44
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.gray
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    // Dùng Segue để truyền dữ liệu qua ViewDetail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowDetail") {
            
            let detailVC = segue.destination as! ViewDetail
            
            let selectedRowIndex: IndexPath = self.tableView.indexPathForSelectedRow!
            
            let sectionTitle = continent_Array[selectedRowIndex.section]

            let sectionValueCountry = country_Dict[sectionTitle] as! NSArray
            
            let countryObject = sectionValueCountry[selectedRowIndex.row] as! NSDictionary
            
            detailVC.dictCountry =  countryObject as! NSMutableDictionary
            
        }
    }
    
    


}
