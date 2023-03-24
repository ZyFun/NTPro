//
//  DealPresenter.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import Foundation

protocol DealPresentationLogic: AnyObject {
    init(view: DealView)
    func startSubscribeToDeals()
    func getDeals()
    func reversedSort()
    func sort(_ sortingMethod: DealPresenter.DealSortingMethod)
}

final class DealPresenter {
    // MARK: - Public Properties
    
    weak var view: DealView?
    var server: Server?
    
    // MARK: - Private Properties
    
    private var models: [DealModel] = []
    private var timer: Timer?
    private var isReversedSort = false
    private var dealSortingMethod = DealSortingMethod.byDateModifier
    
    // MARK: - Initializer
    
    required init(view: DealView) {
        self.view = view
    }
    
    // MARK: - Private Methods
    
    private func dealsSorting() {
        switch dealSortingMethod {
        case .byDateModifier:
            models.sort {
                isReversedSort
                ? $0.dateModifier < $1.dateModifier
                : $0.dateModifier > $1.dateModifier
            }
        case .byInstrumentName:
            models.sort {
                isReversedSort
                ? $0.instrumentName < $1.instrumentName
                : $0.instrumentName > $1.instrumentName
            }
        case .byPrice:
            models.sort {
                isReversedSort
                ? $0.price < $1.price
                : $0.price > $1.price
            }
        case .byAmount:
            models.sort {
                isReversedSort
                ? $0.amount < $1.amount
                : $0.amount > $1.amount
            }
        case .bySide:
            models.sort {
                isReversedSort
                ? $0.side.hashValue < $1.side.hashValue
                : $0.side.hashValue > $1.side.hashValue
            }
        }
    }
}

// MARK: - DealSortingMethod

extension DealPresenter {
    enum DealSortingMethod {
        case byDateModifier
        case byInstrumentName
        case byPrice
        case byAmount
        case bySide
    }
}

// MARK: - Presentation Logic

extension DealPresenter: DealPresentationLogic {
    func reversedSort() {
        isReversedSort.toggle()
        dealsSorting()
    }
    
    func sort(_ sortingMethod: DealSortingMethod) {
        dealSortingMethod = sortingMethod
        dealsSorting()
    }
    
    func startSubscribeToDeals() {
        server?.subscribeToDeals(callback: { [weak self] deals in
            guard let self else { return }
            deals.forEach { deal in
                
                let dateModifier = deal.dateModifier
                let instrumentName = deal.instrumentName
                let price = (deal.price * 100).rounded(.toNearestOrAwayFromZero) / 100
                let amount = Int(deal.amount.rounded())
                let side = deal.side
                
                let dealModel = DealModel(
                    dateModifier: dateModifier,
                    instrumentName: instrumentName,
                    price: price,
                    amount: amount,
                    side: side
                )
                
                self.models.append(dealModel)
            }
        })
    }
    
    func getDeals() {
        // Делаю задержку для обновления данных, для уменьшения нагрузки на процессор
        // при сортировке массива. 1 секунды достаточно, чтобы отображать актуальную
        // информацию.
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                self.dealsSorting()
                self.view?.display(models: self.models)
                print(self.models.count)
            }
        )
    }
}
