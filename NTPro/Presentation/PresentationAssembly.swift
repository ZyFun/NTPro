//
//  PresentationAssembly.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

final class PresentationAssembly {
    private let serviceAssembly = ServiceAssembly()
    
    private let server: Server
    
    init() {
        server = serviceAssembly.server
    }
    
    lazy var deal: DealConfigurator = {
        return DealConfigurator(server: server)
    }()
}
