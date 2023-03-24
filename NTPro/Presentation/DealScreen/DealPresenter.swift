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
                
                self.models[Int(deal.id)] = dealModel
            }
        })
    }
    
    func getDeals() {
        // Делаю задержку для обновления данных, для уменьшения нагрузки на процессор
        // при сортировке массива. 1 секунды достаточно, чтобы отображать актуальную
        // информацию.
        
        // Это решение не оптимально, так как идёт постоянная сортировка полностью
        // не отсортированных данных.
        
        // Первый вариант (можно посмотреть в истории коммитов), был без учёта того, что id
        // должен быть уникальным и это работало лучше. Так как не отсортированные данные
        // добавлялись в конец массива и я работал с почти полностью отсортированными данными.
        // Нагрузка шла только при полной пересортировке по другому полю. При таком подходе
        // нагрузка на процессор была около 40% при 900_000 объектов в массиве.
        
        // Пытался написать алгоритм, чтобы не обновлять массив целиком, а только часть
        // или добавлять новые данные, обновляя структуру. Но оно оказалось еще хуже.
        // Нагрузка на процессор зашкаливала уже на 20_000 объектов. К сожалению этот вариант
        // решения не оставил.
        
        // После множества разных попыток, сдался на этом варианте.
        // Слишком большой поток данных и уже просто не знаю что с этим делать.
        
        // У этой задачи вообще есть решение?))
        // Если взять к примеру любое приложение с инвестициями и представить что 1 стакан,
        // это 1 ячейка, то даже там такого количества одновременно загруженных
        // ячеек и массивов в память нет :)
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                
                self.sortedModels = Array(self.models.values)
                self.dealsSorting()
                self.view?.display(models: self.sortedModels)
                debugPrint("Array \(self.sortedModels.count)")
            }
        )
    }
}
