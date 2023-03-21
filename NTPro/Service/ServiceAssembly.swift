//
//  ServiceAssembly.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

final class ServiceAssembly {
    lazy var server: Server = {
        return Server()
    }()
}
