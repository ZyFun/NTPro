//
//  DealDataSourceProvider.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

protocol IDealDataSourceProvider: UITableViewDelegate {
    var dealModels: [DealModel] { get set}
    func makeDataSource(with dealTableView: UITableView)
    func updateDataSource()
}

final class DealDataSourceProvider: NSObject, IDealDataSourceProvider {
    
    // MARK: - Public properties
    
    var dealModels: [DealModel] = []
    
    // MARK: - Private properties
    
    private var dataSource: UITableViewDiffableDataSource<Section, DealModel>?
    private var infiniteScrollModel: [DealModel] = []
    
    private var countModels = 25
    private func getNewModels() {
        countModels += 25
        infiniteScrollModel.append(contentsOf: dealModels.prefix(countModels))
    }
}

// MARK: - Table view data source

extension DealDataSourceProvider {
    enum Section {
        case main
    }
    
    func makeDataSource(with dealTableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(
            tableView: dealTableView,
            cellProvider: { tableView, indexPath, model -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DealCell.identifier,
                    for: indexPath
                ) as? DealCell else {
                    return UITableViewCell()
                }
                
                cell.config(
                    date: model.dateModifier,
                    instrumentName: model.instrumentName,
                    price: model.price,
                    amount: model.amount,
                    side: model.side
                )
                
                return cell
            }
        )
    }
    
    func updateDataSource() {
        infiniteScrollModel = Array(dealModels.prefix(countModels))
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, DealModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(infiniteScrollModel, toSection: .main)
        
        dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
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
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == infiniteScrollModel.count - 2 {
            getNewModels()
        }
    }
}
