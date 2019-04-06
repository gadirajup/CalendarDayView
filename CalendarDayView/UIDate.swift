//
//  UIDate.swift
//  CalendarDayView
//
//  Created by Prudhvi Gadiraju on 4/5/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

extension Date {
    func subtract(startDate: Date) -> Int {
        return Int(abs(self.timeIntervalSince1970 - startDate.timeIntervalSince1970) / 60)
    }
    
    static func generateRandomDate() -> Date {
        let year = 2019
        let month = 4
        let day = 4
        let hour = Int.random(in: 8..<24)
        let minute = Int.random(in: 0..<60)
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        
        let randomDate = Calendar.current.date(from: components)!
        return randomDate
    }
}
