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
//        presenter?.getDeals()
    }
}

// MARK: - Логика обновления данных View

extension DealViewController: DealView {
    func display(models: [DealModel]) {
        dataSourceProvider?.dealModels = models
        dealTableView.reloadData()
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
        dealTableView.dataSource = dataSourceProvider
        dealTableView.delegate = dataSourceProvider
        
        registerElements()
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
            dealTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dealTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dealTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
