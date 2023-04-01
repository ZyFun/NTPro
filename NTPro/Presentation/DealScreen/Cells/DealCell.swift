//
//  DealCell.swift
//  NTPro
//
//  Created by Дмитрий Данилин on 21.03.2023.
//

import UIKit

class DealCell: UITableViewCell, IdentifiableCell {
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "13:43:56 09.12.2022"
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var instrumentNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "USDRUB"
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "62.10"
        return label
    }()
    
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "1 000 000"
        return label
    }()
    
    private var sideLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Sell"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(instrumentNameLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(amountLabel)
        infoStackView.addArrangedSubview(sideLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            infoStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Public methods

extension DealCell {
    func config(
        date: Date,
        instrumentName: String,
        price: Double,
        amount: Int,
        side: Deal.Side
    ) {
        dateLabel.text = date.toString()
        instrumentNameLabel.text = instrumentName
        priceLabel.text = "\(price)"
        amountLabel.text = "\(amount)"
        
        switch side {
        case .sell:
            sideLabel.text = "Sell"
            sideLabel.textColor = .systemRed
        case .buy:
            sideLabel.text = "Buy"
            sideLabel.textColor = .systemGreen
        }
    }
}
