# Load data from file plist in TableView

Mục đích:

* Hiểu được 1 số override methods hay dùng của UITableViewDelegate và UITableViewDataSourse 
* Cách load dữ liệu từ 1 file .plist bất kỳ

## Cấu trúc file .plist trong bài toán

![](/assets/1.png)

Yêu cầu ở View 1 lấy ra được các tên quốc gia\(country\) cùng thuộc 1 châu lục nằm trong 1 Section.Sau đó ở view 2 đưa ra thông tin chi tiết của quốc gia đó.

## Hướng giải quyết

Ta sẽ tạo 1 mảng kiểu Dictionary với key là các châu lục - value là 1 mảng Obj\_Country.Mỗi Object trong mảng đó chứa 3 biến \(country,capital,flag\)

Để lấy ra được số lượng section ta sẽ lấy số lượng  của 1 mảng mới với giá trị là tên các châu lục.

## Code

```Swift
//MARK:: Parameters - User

var continent_Array = [String]() // Mảng lưu tên các Châu lục -> tạo section cho TableView

var country_Dict = NSMutableDictionary() // Dictionary lưu key là Continent(Các châu lục) với value tương ứng là 1 mảng Object Coutry(tên nước,thủ đô,cờ)
```

```Swift
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

            }

    }
```

## Một số Override Methods trong UiTableView

```Swift
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

        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        // Lấy ra châu lục mà tương ứng với section
        let sectionTitle = continent_Array[indexPath.section]
        // Lấy ra Mảng Obj_Country thông qua key(Châu lục-Continent) ứng với nó
        let sectionValueCountry = country_Dict[sectionTitle] as! NSArray
        // Lấy ra 1 cái Obj_Country
        let countryObject = sectionValueCountry[indexPath.row] as! NSDictionary

        cell.textLabel?.text = countryObject.value(forKey: "country") as! String?

        return cell
    }
    // Hiển thị tên mục Section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return continent_Array[section]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.gray
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
```

## Sử dụng Segue để truyền dữ liệu qua view khác

* ```Swift
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
  ```

# Expand/Collapse Section trong TableView

## Custom 1 class để bắt được sự kiện người dùng bấm vào section

Để expand và collapse section thì chúng ta phải bắt được sự kiện khi người dùng bấm vào Section.Tuy nhiên thằng Apple chưa có hàm sẵn cho chúng ta nên chúng ta phải Custom 1 class mới để giải quyết được vấn đề này.

Class này được kế thừa từ class UITableViewHeaderFooterView.Vì class này cho phép người dùng có thể thêm thông tin trong Section.

Trong Class này sẽ có 2 parameters: 1 là biến section để xác định thứ tự của Section khi người dùng bấm vào.2 là biến để bắt được sự kiện người dùng bấm vào.

Tạo 1 protocol có func với 2 đầu vào là : 1 biến với kiểu là 1 class trên và biến với kiểu Int để xác định thứ tự trong section

Code

```Swift
class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }

    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.darkGray
    }


}
///////////////////////////////////////////////////////////
protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}
```

## Triển khai hướng giải quyết để Expand/Collapse trong section

Ta sẽ có 1 biến lưu trạng thái expand/Collapse =&gt; nó chỉ có 2 trạng thái nên ta quy ước rằng expand là true và collapse là false

Do đó ở mảng lưu Section ta phải add thêm 1 biến để lưu trạng thái của nó.Quy ước lúc đầu sẽ là False cho tất cả.

Trong UiTableViewDatasourse có func heightForRowAt indexPath =&gt; Dùng cái này để cho nó Expand hay collapse hiển thị nội dung trong từng section

Để Expand thì mỗi lần ta phải update lại tableView bằng cách dùng tableview.reloadreloadRow cho từng cell trong section



