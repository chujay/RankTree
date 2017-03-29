//
//  ScheduleViewController.swift
//  RankTree
//
//  Created by Chujay on 22/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import UIKit
import CVCalendar

class TimeViewController: UIViewController{
    
    @IBOutlet weak var theTime: UILabel!
    let menuView = CVCalendarMenuView()
    let calendarView = CVCalendarView()
    static var scheduleTime: [Any] = []
    var timeArray: [Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
    }
    
    func setUp() {
        self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 15)
        self.calendarView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 250)
        self.view.addSubview(self.menuView)
        self.view.addSubview(self.calendarView)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: currentDate)
        self.navigationItem.title = convertedDate
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    @IBAction func todayMonthView(_ sender: Any) {
        self.calendarView.toggleCurrentDayView()
    }
    @IBAction func nextMonth(_ sender: Any) {
        self.calendarView.loadNextView()
    }
    @IBAction func lastMonth(_ sender: Any) {
        self.calendarView.loadPreviousView()
    }
    
    
}
extension TimeViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    func firstWeekday() -> Weekday {
        return .sunday
    }
    func presentedDateUpdated(_ date: CVDate) {
        self.navigationItem.title = date.globalDescription
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        let alert = UIAlertController(title: "Select time", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 50, width: alert.view.frame.width, height: 100))
        TimeViewController.scheduleTime.removeAll()
        datePickerView.datePickerMode = .time
        datePickerView.date = Date()
        datePickerView.addTarget(self, action: #selector(self.timeChanged), for: .valueChanged)
        alert.view.addSubview(datePickerView)
        let okAction = UIAlertAction(title: "Confirm", style: .default, handler: { action in
            TimeViewController.scheduleTime.append(dayView.date.year)
            TimeViewController.scheduleTime.append(dayView.date.month)
            TimeViewController.scheduleTime.append(dayView.date.day)
            TimeViewController.scheduleTime.append(self.timeArray[0])
            TimeViewController.scheduleTime.append(self.timeArray[1])
        })
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func timeChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.none
        timeFormatter.timeStyle = DateFormatter.Style.short
        let timeString = timeFormatter.string(from: sender.date).components(separatedBy: ":")
        var hour = Int(timeString[0])
        let minuteString = timeString[1].components(separatedBy: " ")
        let minute = Int(minuteString[0])
        let type = minuteString[1]
        if type == "PM"{
           hour = hour! + 12
        }
        self.timeArray.removeAll()
        self.timeArray.append(hour!)
        self.timeArray.append(minute!)
    }
    
}

