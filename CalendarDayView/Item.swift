//
//  Item.swift
//  CalendarDayView
//
//  Created by Prudhvi Gadiraju on 4/5/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import Foundation

class Item {
    let title: String
    let startDate: Date
    let endDate: Date
    var length: Int {
        get {
            return endDate.subtract(startDate: startDate)
        }
    }
    
    init(title: String, startDate: Date, endDate: Date) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
