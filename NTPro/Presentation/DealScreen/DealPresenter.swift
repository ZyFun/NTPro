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
}

final class DealPresenter {
    // MARK: - Public Properties
    
    weak var view: DealView?
    var server: Server?
    var models: [DealModel] = []
    
    // MARK: - Initializer
    
    required init(view: DealView) {
        self.view = view
    }
}

// MARK: - Presentation Logic

extension DealPresenter: DealPresentationLogic {
    func startSubscribeToDeals() {
        server?.subscribeToDeals(callback: { [weak self] deals in
            deals.forEach { deal in
                let dealModel = DealModel(
                    dateModifier: deal.dateModifier,
                    instrumentName: deal.instrumentName,
                    price: (deal.price * 100).rounded(.toNearestOrAwayFromZero) / 100,
                    amount: Int(deal.amount.rounded()),
                    side: deal.side
                )
                
                self?.models.append(dealModel)
            }
        })
    }
    
    func getDeals() {
        // FIXME: Временно для проверки
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.display(models: self.models)
        }
    }
}
