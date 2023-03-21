//
//  DealPresenter.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import Foundation

protocol DealPresentationLogic: AnyObject {
    init(view: DealView)
    func getDeals()
}

final class DealPresenter {
    // MARK: - Public Properties
    
    weak var view: DealView?
    var server: Server?
    
    // MARK: - Initializer
    
    required init(view: DealView) {
        self.view = view
    }
}

// MARK: - Presentation Logic

extension DealPresenter: DealPresentationLogic {
    func getDeals() {
        var models: [DealModel] = []
        // FIXME: Временно для проверки
        server?.subscribeToDeals(callback: { deals in
            deals.forEach { deal in
                let dealModel = DealModel(
                    id: deal.id,
                    dateModifier: deal.dateModifier,
                    instrumentName: deal.instrumentName,
                    price: (deal.price * 100).rounded(.toNearestOrAwayFromZero) / 100,
                    amount: Int(deal.amount.rounded()),
                    side: deal.side.hashValue // FIXME: Временно для проверки
                )
                
                models.append(dealModel)
            }
            
            self.view?.display(models: models)
        })
    }
}
