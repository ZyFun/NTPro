//
//  DealHeaderFooterView.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

class DealHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = String(describing: DealHeaderFooterView.self)
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var instrumentNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Instrument"
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Price"
        return label
    }()
    
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Amount"
        return label
    }()
    
    private var sideLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Side"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(headerStackView)
        headerStackView.addArrangedSubview(instrumentNameLabel)
        headerStackView.addArrangedSubview(priceLabel)
        headerStackView.addArrangedSubview(amountLabel)
        headerStackView.addArrangedSubview(sideLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.heightAnchor.constraint(equalTo: heightAnchor),
            headerStackView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}
