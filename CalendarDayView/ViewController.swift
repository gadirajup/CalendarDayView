//
//  ViewController.swift
//  CalendarDayView
//
//  Created by Prudhvi Gadiraju on 4/5/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    // MARK :- Properties
    
    var collectionView: UICollectionView!
    
    let eventStore = EKEventStore.init()
    var calendars = [EKCalendar]()
    var events = [EKEvent]()
    var items = [Item]()

    // <MARK :- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupCollectionView()
        
        checkCalendarAuthorizationStatus()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Today"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(handleFetchButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddButtonTapped))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: CustomLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        if let layout = collectionView.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        
        view.addSubview(collectionView)
    }
    
    fileprivate func addRandomItem() {
        let randomName = "Random Item \(items.count + 1)"
        let randomStartDate = Date.generateRandomDate()
        let randomLength = Int.random(in: 10...120)
        let randomEndDate = Calendar.current.date(byAdding: .minute, value: randomLength, to: randomStartDate)!
        
        let item = Item(title: randomName, startDate: randomStartDate, endDate: randomEndDate)
        items.append(item)
        
        collectionView.reloadData()
    }
    
    // Mark :- Handlers
    
    @objc fileprivate func handleFetchButtonTapped() {
        loadEventsForDay()
        collectionView.reloadData()
    }
    
    @objc fileprivate func handleAddButtonTapped() {
        addRandomItem()
    }
}

// Mark :- EventKit

extension ViewController {
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            loadCalendars()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("Denied")
        @unknown default:
            fatalError()
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //
                })
            }
        })
    }
    
    fileprivate func loadEventsForDay() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let thursday = dateFormatter.date(from: "Apr 04, 2019")!
        let friday = dateFormatter.date(from: "Apr 05, 2019")!
        
        //print(thursday)
        //let yesterday = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        
        let predicate = eventStore.predicateForEvents(withStart: thursday, end: friday, calendars: calendars)
        events = eventStore.events(matching: predicate)
        
        for event in events{
    
            //let calendar = Calendar.current
            let startDate = event.startDate!
            let endDate = event.endDate!
            //let startTime = calendar.component(.hour, from: startDate)
            //let length = event.startDate.subtract(startDate: event.endDate)

            // Create Actual Event Item
            let item = Item(title: event.title, startDate: startDate, endDate: endDate)
            items.append(item)
        }
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
}

// Mark :- CollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //let item = items[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        cell.alpha = 0.5
        return cell
    }
}

extension ViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> Int {
        let item = items[indexPath.row]
        
        return item.length
    }
    
    func collectionView(_ collectionView: UICollectionView, startTimeForItemAt indexPath: IndexPath) -> Int {
        let item = items[indexPath.row]
        let startDate = item.startDate
        
        let startHour = Calendar.current.component(.hour, from: startDate)
        let startMinutes = Calendar.current.component(.minute, from: startDate)
        
        let totalMinutes = (startHour * 60) + startMinutes
        
        return totalMinutes
    }
}
