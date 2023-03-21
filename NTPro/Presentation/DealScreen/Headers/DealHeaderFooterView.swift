//
//  DealHeaderFooterView.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

class DealHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = String(describing: DealHeaderFooterView.self)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // добавить элементы
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // установить констреинты
    }
}
