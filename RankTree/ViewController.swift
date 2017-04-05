//
//  ViewController.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit
import Firebase
import IBAnimatable

enum Item: String {
    case title = "Title"
    case startTime = "Start"
    case endTime = "End"
    case context = "Description"
    case level = "Level"
    case location = "location"
}

enum CollectionItem {
    case todayItems
    case supItems
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItems: AnimatableButton!
    @IBOutlet var customView: AnimatableView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var todayCollectionView: UICollectionView!
    @IBOutlet weak var suppleCollectionView: UICollectionView!

    let items: [Item] = [.title, .context, .startTime, .endTime, .location, .level]
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
        self.dragAndDropManager = KDDragAndDropManager(canvas: self.view, collectionViews: [todayCollectionView, suppleCollectionView])
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func setUp() {
        Data().produceData() //Fake data
        let year = String(calendar.component(.year, from: self.date))
        let month = String(calendar.component(.month, from: self.date))
//        let day = String(calendar.component(.day, from: self.date))
        self.schedules = RankData().rankTime(year: year, month: "3", day: "28")
        self.navigationItem.title = "RankTree"
        self.customView.isHidden = true
        self.customView.layer.borderWidth = 1.0
        self.customView.layer.borderColor = UIColor.gray.cgColor
        self.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.addItems.maskType = .circle
        self.addItems.addTarget(self, action: #selector(addSchedule), for: .touchUpInside)
    }

    func addSchedule(_ sender: Any) {
        self.addItems.pop(repeatCount: 1)
        self.customView.squeeze(.in, direction: .down)
        self.customView.isHidden = false
        self.view.addSubview(customView)
        self.customView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - 44)
    }

    @IBAction func cancell(_ sender: Any) {

//        self.customView.isHidden = true
        self.tableView.reloadData()
        self.customView.squeezeFade(.out, direction: .up)
    }
    func confirm(_ sender: Any) {

        if (itemTitle == nil) || (startTime == nil) {
            let alert = UIAlertController(title: "Oops", message: "You forget your title and start time!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        if endTime == nil {
            self.endTime = self.startTime
        }
        if itemContext == nil {
            self.itemContext = ""
        }
        if level == nil {
            self.level = "Medium level"
        }

        self.customView.isHidden = true
        let schedule = Schedules(title: self.itemTitle!, startTime: self.startTime!, endTime: self.endTime!, context: self.itemContext!, level: self.level!)
        Data.scheduleArray.append(schedule)
        self.tableView.reloadData()
        let year = String(calendar.component(.year, from: self.date))
        let month = String(calendar.component(.month, from: self.date))
//        let day = String(calendar.component(.day, from: self.date))
        self.schedules = RankData().rankTime(year: year, month: "3", day: "28")
        self.customView.squeezeFade(.out, direction: .down)
        self.supSchedules.removeAll()
        self.todayCollectionView.reloadData()
        self.suppleCollectionView.reloadData()
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
        case .location:
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
        case .location:
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
        case .location:
            guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
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

extension ViewController: KDDragAndDropCollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionItem = [self.schedules, self.supSchedules]
       return collectionItem[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
        let collectionItem = [self.schedules, self.supSchedules]
        cell.label.text = collectionItem[collectionView.tag][indexPath.item].title
        cell.numberLabel.text = String(indexPath.item + 1)
        cell.isHidden = false
        cell.layer.cornerRadius = 10.0
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let collectionItem = [self.schedules, self.supSchedules]
        let title = collectionItem[collectionView.tag][indexPath.item].title
        let startTime = collectionItem[collectionView.tag][indexPath.item].startTime
        let endTime = collectionItem[collectionView.tag][indexPath.item].endTime
        let level = collectionItem[collectionView.tag][indexPath.item].level
        let messsage = "Title: \(title) \n Start time: \(startTime) \n End time: \(endTime) \n Level: \(level)"
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)

    }

}
