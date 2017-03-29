//
//  ViewController.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    enum Item: String {
        case title = "Title"
        case startTime = "Start"
        case endTime = "End"
        case context = "Description"
        case level = "Level"
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItems: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var confirmButton: UIButton!

    let items: [Item] = [.title, .context, .startTime, .endTime, .level]
    let date = Date()
    let calendar = Calendar.current
    var schedules: [Schedules] = []
    var myDatePicker: UIDatePicker!
    var myDateLabel: UILabel!

    var itemTitle: String?
    var startTime: [Int]?
    var endTime: [Int]?
    var itemContext: String?
    var level: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        Data().produceData() //Fake data
        let year = String(calendar.component(.year, from: self.date))
        let month = String(calendar.component(.month, from: self.date))
        let day = String(calendar.component(.day, from: self.date))
        self.schedules = RankData().rankTime(year: year, month: month, day: day)
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
        let schedule = Schedules(title: self.itemTitle!, startTime: self.startTime!, endTime: self.endTime!, context: self.itemContext!, level: self.level!)
        Data.scheduleArray.append(schedule)
        self.tableView.reloadData()
        let year = String(calendar.component(.year, from: self.date))
        let month = String(calendar.component(.month, from: self.date))
        let day = String(calendar.component(.day, from: self.date))
        self.schedules = RankData().rankTime(year: year, month: month, day: day)
        
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
        case .startTime:
            return 50
        case .endTime:
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
            self.itemTitle = text.text
            text.delegate = self
            cell.addSubview(text)
        case .startTime:
            cell.textLabel?.text = item.rawValue
        case .endTime:
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
        case .startTime:
            guard
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController
                else { return }
            self.navigationController?.pushViewController(secondViewController, animated: true)
        case .endTime:
            guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController
                else { return }
            self.navigationController?.pushViewController(secondViewController, animated: true)
        case .level:
            let alert = UIAlertController(title: "Level", message: "Choose level!", preferredStyle: .actionSheet)
            let lowLevel = UIAlertAction(title: "Low", style: .default, handler: { _ in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = "Low level"
                self.level = "Low level"
            })
            let medLevel = UIAlertAction(title: "Medium", style: .default, handler: {_ in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = "Medium level"
                self.level = "Medium level"
            })
            let highLevel = UIAlertAction(title: "High", style: .default, handler: {_ in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = "High level"
                self.level = "High level"
            })
            alert.addAction(lowLevel)
            alert.addAction(medLevel)
            alert.addAction(highLevel)
            present(alert, animated: true, completion: nil)
        case .context:
            let alert = UIAlertController(title: "Context", message: "Key the detail", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { _ in

            })
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = alert.textFields?.first?.text
                self.itemContext = alert.textFields?.first?.text
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        default:
            return
        }

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        switch item {
        case .startTime:
            let time = TimeViewController.scheduleTime
            self.startTime = TimeViewController.scheduleTime as? [Int]
            let timeString = "\(time[0]).\(time[1]).\(time[2])-\(time[3]):\(time[4])"
            tableView.cellForRow(at: indexPath)?.textLabel?.text = timeString
            TimeViewController.scheduleTime.removeAll()
        case .endTime:
            let time = TimeViewController.scheduleTime
            self.endTime = TimeViewController.scheduleTime as? [Int]
            let timeString = "\(time[0]).\(time[1]).\(time[2])-\(time[3]):\(time[4])"
            tableView.cellForRow(at: indexPath)?.textLabel?.text = timeString
            TimeViewController.scheduleTime.removeAll()
        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.itemTitle = textField.text
        return true
    }

}
