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
    
    private var models: [Int: DealModel] = [:]
    private var sortedModels: [DealModel] = []
    private var isReversedSort = false
    private var dealSortingMethod = DealSortingMethod.byDateModifier
    
    private var timer: Timer?
    private var group = DispatchGroup()
    private let queue = DispatchQueue(label: "sorting-deals")
    
    // MARK: - Initializer
    
    required init(view: DealView) {
        self.view = view
    }
    
    // MARK: - Private Methods
    
    private func dealsSorting() {
        switch dealSortingMethod {
        case .byDateModifier:
            sortedModels.sort {
                isReversedSort
                ? $0.dateModifier < $1.dateModifier
                : $0.dateModifier > $1.dateModifier
            }
        case .byInstrumentName:
            sortedModels.sort {
                isReversedSort
                ? $0.instrumentName < $1.instrumentName
                : $0.instrumentName > $1.instrumentName
            }
        case .byPrice:
            sortedModels.sort {
                isReversedSort
                ? $0.price < $1.price
                : $0.price > $1.price
            }
        case .byAmount:
            sortedModels.sort {
                isReversedSort
                ? $0.amount < $1.amount
                : $0.amount > $1.amount
            }
        case .bySide:
            sortedModels.sort {
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
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            self.stopUpdateData()
        }
        
        queue.async { [weak self] in
            guard let self else { return }
            self.isReversedSort.toggle()
            self.dealsSorting()
            self.view?.display(models: self.sortedModels)
            self.group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.startUpdateData()
        }
    }
    
    func sort(_ sortingMethod: DealSortingMethod) {
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            self.stopUpdateData()
        }
        
        queue.async { [weak self] in
            guard let self else { return }
            self.dealSortingMethod = sortingMethod
            self.dealsSorting()
            self.view?.display(models: self.sortedModels)
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            self.startUpdateData()
        }
    }
    
    func startSubscribeToDeals() {
        server?.subscribeToDeals(callback: { [weak self] deals in
            guard let self else { return }
            
            self.queue.async {
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
                    
                    self.models[Int(deal.id)] = dealModel
                }
            }
        })
    }
    
    func getDeals() {
        startUpdateData()
    }
    
    private func startUpdateData() {
        timer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(updateData),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopUpdateData() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateData() {
        queue.async { [weak self] in
            guard let self else { return }
            self.sortedModels = Array(self.models.values)
            self.dealsSorting()
            self.view?.display(models: self.sortedModels)
            debugPrint("Array \(self.sortedModels.count)")
        }
    }
}
