//
//  DealConfigurator.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

final class DealConfigurator {
    let server: Server
    
    init(server: Server) {
        self.server = server
    }
    
    func config(
        view: UIViewController,
        navigationController: UINavigationController?
    ) {
        guard let view = view as? DealViewController else { return }
        let presenter = DealPresenter(view: view)
        let dataSourceProvider: IDealDataSourceProvider = DealDataSourceProvider()
        
        view.presenter = presenter
        view.dataSourceProvider = dataSourceProvider
        presenter.server = server
    }
}
