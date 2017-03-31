//
//  ViewController.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit
import Firebase

enum Item: String {
    case title = "Title"
    case startTime = "Start"
    case endTime = "End"
    case context = "Description"
    case level = "Level"
}

enum CollectionItem {
    case todayItems
    case supItems
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItems: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var todayCollectionView: UICollectionView!
    @IBOutlet weak var suppleCollectionView: UICollectionView!
    
    let items: [Item] = [.title, .context, .startTime, .endTime, .level]
    let collectionItems: [CollectionItem] = [.todayItems, .supItems]
    let date = Date()
    let calendar = Calendar.current
    var schedules: [Schedules] = []
    var supSchedules: [Schedules] = []
    var myDatePicker: UIDatePicker!
    var myDateLabel: UILabel!
    var dragAndDropManager: KDDragAndDropManager?
    var itemTitle: String?
    var startTime: [Int]?
    var endTime: [Int]?
    var itemContext: String?
    var level: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        Data().produceData() //Fake data
        let year = String(calendar.component(.year, from: self.date))
        let month = String(calendar.component(.month, from: self.date))
//        let day = String(calendar.component(.day, from: self.date))
        self.schedules = RankData().rankTime(year: year, month: month, day: "28")
        self.dragAndDropManager = KDDragAndDropManager(canvas: self.view, collectionViews: [todayCollectionView, suppleCollectionView])
        self.tableView.delegate = self
        self.tableView.dataSource = self
        print(supSchedules)
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
        self.view.addSubview(customView)
        self.customView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - 44)
    }

    @IBAction func cancell(_ sender: Any) {

        self.customView.isHidden = true
        self.tableView.reloadData()
    }
    func confirm(_ sender: Any) {
        self.customView.isHidden = true
        let schedule = Schedules(title: self.itemTitle!, startTime: self.startTime!, endTime: self.endTime!, context: self.itemContext!, level: self.level!)
        Data.scheduleArray.append(schedule)
        self.tableView.reloadData()
        let year = String(calendar.component(.year, from: self.date))
        let month = String(calendar.component(.month, from: self.date))
//        let day = String(calendar.component(.day, from: self.date))
        self.schedules = RankData().rankTime(year: year, month: month, day: "28")
        self.todayCollectionView.reloadData()
        print(schedules)
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
            self.startTime = TimeViewController.scheduleTime
            let timeString = "\(time[0]).\(time[1]).\(time[2])-\(time[3]):\(time[4])"
            tableView.cellForRow(at: indexPath)?.textLabel?.text = timeString
            TimeViewController.scheduleTime.removeAll()
        case .endTime:
            let time = TimeViewController.scheduleTime
            self.endTime = TimeViewController.scheduleTime
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

extension ViewController: KDDragAndDropCollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionItem = [self.schedules, self.supSchedules]
       return collectionItem[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
        let collectionItem = [self.schedules, self.supSchedules]
        cell.label.text = collectionItem[collectionView.tag][indexPath.item].title
        
        cell.isHidden = false

        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {

            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {

                if draggingPathOfCellBeingDragged.item == indexPath.item {

                    cell.isHidden = true

                }
            }
        }
        return cell
    }
    // MARK: KDDragAndDropCollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        let collectionItem = [self.schedules, self.supSchedules]
        return collectionItem[collectionView.tag][indexPath.item] as AnyObject
    }

    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem: AnyObject, atIndexPath indexPath: IndexPath) {
        let collectionItem = self.collectionItems[collectionView.tag]
        switch collectionItem {
        case .todayItems:
            if let insertItem = dataItem as? Schedules {
                schedules.insert(insertItem, at: indexPath.item)
            }
        case .supItems:
            if let insertItem = dataItem as? Schedules {
                supSchedules.insert(insertItem, at: indexPath.item)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {

        let collectionItem = self.collectionItems[collectionView.tag]
        switch collectionItem {
        case .todayItems:
            schedules.remove(at: indexPath.item)
        case .supItems:
           supSchedules.remove(at: indexPath.item)
        }

    }

    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to: IndexPath) {

        let collectionItem = self.collectionItems[collectionView.tag]
        switch collectionItem {
        case .todayItems:
            let fromDataItem: Schedules = schedules[from.item]
            schedules.remove(at: from.item)
            schedules.insert(fromDataItem, at: to.item)
        case .supItems:
            let fromDataItem: Schedules = supSchedules[from.item]
            supSchedules.remove(at: from.item)
            supSchedules.insert(fromDataItem, at: to.item)
        }

    }

    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {

        let collectionItem = [self.schedules, self.supSchedules]
        if let candidate: Schedules = dataItem as? Schedules {
            for item: Schedules in collectionItem[collectionView.tag] {
                if candidate == item {
                    let position = collectionItem[collectionView.tag].index(of: item)!
                    let indexPath = IndexPath(item: position, section: 0)
                    return indexPath
                }
            }
        }
        return nil
    }

}
