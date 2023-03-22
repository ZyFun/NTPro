//
//  DealModel.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import Foundation

struct DealModel {
    let dateModifier: Date
    let instrumentName: String
    let price: Double
    let amount: Int
    let side: Deal.Side
}
