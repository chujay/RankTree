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
    
    let menuView = CVCalendarMenuView()
    let calendarView = CVCalendarView()
    
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
        print("========Time Data(for day)=========")
        print(dayView.date.description)
        
        
    }
    
}

