//
//  Date+StringFormatter.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 24.03.2023.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: self)
        
        return formattedDate
    }
}
