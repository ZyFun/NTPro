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
    
    // MARK: - Private properties
    
    private var isButtonTitleReversed = false
    private var dealTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var ascendingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "A-Z",
            style: .plain,
            target: self,
            action: #selector(ascendingButtonPressed)
        )
        return button
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Sort",
            style: .plain,
            target: self,
            action: #selector(sortButtonPressed)
        )
        return button
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
        DispatchQueue.main.async { [weak self] in
            self?.dataSourceProvider?.dealModels = models
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
        addBarButtons()
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
    
    func addBarButtons() {
        navigationItem.leftBarButtonItem = sortButton
        navigationItem.rightBarButtonItem = ascendingButton
    }
    
    @objc func sortButtonPressed() {
        showSortActionSheet()
    }
    
    @objc func ascendingButtonPressed() {
        presenter?.reversedSort()
        
        if isButtonTitleReversed {
            ascendingButton.title = "A-Z"
        } else {
            ascendingButton.title = "Z-A"
        }
        
        isButtonTitleReversed.toggle()
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

// MARK: - actionSheet

private extension DealViewController {
    func showSortActionSheet() {
        let actionSheet = UIAlertController(
            title: "Sorting by...",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortingByDateModifier = UIAlertAction(
            title: "Date modifier",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sort(.byDateModifier)
        }
        
        let sortingByInstrumentName = UIAlertAction(
            title: "Instrument name",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sort(.byInstrumentName)
        }
        
        let sortingByPrice = UIAlertAction(
            title: "Price",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sort(.byPrice)
        }
        
        let sortingByAmount = UIAlertAction(
            title: "Amount",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sort(.byAmount)
        }
        
        let sortingBySide = UIAlertAction(
            title: "Side",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sort(.bySide)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(sortingByDateModifier)
        actionSheet.addAction(sortingByInstrumentName)
        actionSheet.addAction(sortingByPrice)
        actionSheet.addAction(sortingByAmount)
        actionSheet.addAction(sortingBySide)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}
