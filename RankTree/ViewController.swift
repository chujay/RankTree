//
//  ViewController.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Item: String {
        case title = "Title"
        case time = "Time"
        case location = "Location"
        case context = "Context"
        case level = "Level"
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItems: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    let items:[Item] = [.title, .time ,.location, .context, .level]
    var schedules: [Schedules] = []
    var myDatePicker: UIDatePicker!
    var myDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setUp()
        
    }
    
    func setUp() {
        
        self.navigationItem.title = "RankTree"
        self.customView.isHidden = true
        self.customView.layer.borderWidth = 1.0
        self.customView.layer.borderColor = UIColor.gray.cgColor
        self.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.addItems.addTarget(self, action: #selector(addSchedule), for: .touchUpInside)
        
    }
    
    func addSchedule(_ sender: Any) {
        self.customView.isHidden = false
    }
    
    func confirm(_ sender: Any) {
        self.customView.isHidden = true
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.row]
        switch item {
        case .title:
            return 50
        case .time:
            return 100
        case .location:
            return 50
        case .context:
            return 50
        case .level:
            return 50
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        switch item {
        case .title:
            let text = UITextField(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            text.placeholder = "Enter the project title!"
            text.borderStyle = .roundedRect
            text.clearButtonMode = .whileEditing
            text.keyboardType = .asciiCapable
            text.returnKeyType = .done
            text.textColor = UIColor.blue
            text.delegate = self
            cell.addSubview(text)
        case .time:
//            self.myDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0 , width: cell.frame.width, height: cell.frame.height))
//            self.myDatePicker.datePickerMode = .dateAndTime
//            self.myDatePicker.minuteInterval = 30
//            self.myDatePicker.date = Date()
//            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm"
//            let fromDate = formatter.date(from: "2016-01-02 00:00")
//            self.myDatePicker.minimumDate = fromDate
//            self.myDatePicker.locale = Locale(identifier: "zh_TW")
//            cell.addSubview(self.myDatePicker)
            cell.textLabel?.text = item.rawValue
            
            
        case .location:
            cell.textLabel?.text = item.rawValue
        case .level:
            cell.textLabel?.text = item.rawValue
        case .context:
            cell.textLabel?.text = item.rawValue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        switch item {
        case .time:
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeViewController") as! TimeViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        case .location:
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)

        default:
            return
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

