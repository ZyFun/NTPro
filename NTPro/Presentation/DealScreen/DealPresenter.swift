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
    
    // MARK: - Private Properties
    
    private var models: [DealModel] = []
    private var timer: Timer?
    
    // MARK: - Initializer
    
    required init(view: DealView) {
        self.view = view
    }
}

// MARK: - Presentation Logic

extension DealPresenter: DealPresentationLogic {
    func startSubscribeToDeals() {
        server?.subscribeToDeals(callback: { [weak self] deals in
            guard let self else { return }
            deals.forEach { deal in
                let dealModel = DealModel(
                    dateModifier: deal.dateModifier,
                    instrumentName: deal.instrumentName,
                    price: (deal.price * 100).rounded(.toNearestOrAwayFromZero) / 100,
                    amount: Int(deal.amount.rounded()),
                    side: deal.side
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
            block: { _ in
                // FIXME: Временное решение по сортировке для проверки работы
                self.models.sort() {
                    $0.dateModifier < $1.dateModifier
                }
                
                self.view?.display(models: self.models)
                print(self.models.count)
            }
        )
    }
}
