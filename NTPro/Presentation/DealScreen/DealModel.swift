//
//  DealModel.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import Foundation

struct DealModel {
    let id: Int64
    let dateModifier: Date
    let instrumentName: String
    let price: Double
    let amount: Int
    let side: Int // 0: sell, 1: buy
}
