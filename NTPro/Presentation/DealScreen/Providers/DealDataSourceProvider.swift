//
//  DealDataSourceProvider.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

protocol IDealDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    var dealModels: [DealModel] { get set}
}

final class DealDataSourceProvider: NSObject, IDealDataSourceProvider {
    
    // MARK: - Public properties
    
    var dealModels: [DealModel] = []
}

// MARK: - Table view data source

extension DealDataSourceProvider {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dealModels.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DealCell.identifier,
            for: indexPath
        ) as? DealCell else {
            return UITableViewCell()
        }
        
        let dealModel = dealModels[indexPath.row]
        
        cell.config(
            date: dealModel.dateModifier,
            instrumentName: dealModel.instrumentName,
            price: dealModel.price,
            amount: dealModel.amount,
            side: dealModel.side
        )
        
        return cell
    }
}

// MARK: - Table view delegate

extension DealDataSourceProvider {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: DealHeaderFooterView.identifier
        ) as? DealHeaderFooterView
        
        return header
    }
}
