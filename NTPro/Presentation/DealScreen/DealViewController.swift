//
//  DealViewController.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

protocol DealView: AnyObject {
    func display(models: [DealModel])
}

final class DealViewController: UIViewController {
    // MARK: - Public properties
    
    var presenter: DealPresentationLogic?
    var dataSourceProvider: IDealDataSourceProvider?
    
    // MARK: - Public properties
    
    private var dealTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter?.startSubscribeToDeals()
        presenter?.getDeals()
    }
}

// MARK: - Логика обновления данных View

extension DealViewController: DealView {
    func display(models: [DealModel]) {
        self.dataSourceProvider?.dealModels = models
        
        DispatchQueue.main.async { [weak self] in
            self?.dataSourceProvider?.updateDataSource()
        }
    }
}

// MARK: - Конфигурирование ViewController

private extension DealViewController {
    func setup() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTableView()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        title = "Deals"
    }
    
    func setupTableView() {
        registerElements()
        dataSourceProvider?.makeDataSource(with: dealTableView)
        dealTableView.delegate = dataSourceProvider
    }
    
    func registerElements() {
        dealTableView.register(
            DealCell.self,
            forCellReuseIdentifier: DealCell.identifier
        )
        
        dealTableView.register(
            DealHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: DealHeaderFooterView.identifier
        )
    }
    
    func setupConstraints() {
        view.addSubview(dealTableView)
        
        NSLayoutConstraint.activate([
            dealTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dealTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dealTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dealTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
