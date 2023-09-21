//
//  RemindersTableCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit

final class RemindersTableCell: UITableViewCell {
    var didChangeEnable: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var periodLabel = makeLabel()
    lazy var scheduleLabel = makeLabel()
    lazy var countPlaceholderView = makeCountPlacehoderView()
    lazy var countLabel = makeLabel()
    lazy var separator = makeSeparator()
    lazy var categoriesLabel = makeLabel()
    lazy var switchView = makeSwitch()
    
    private lazy var periodAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 18.scale))
        .lineHeight(21.92.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var countAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.ProximaNova.bold(size: 18.scale))
        .lineHeight(21.92.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var scheduleAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.regular(size: 14.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var categoriesAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 14.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RemindersTableCell {
    func setup(element: Reminder) {
        let period = String(format: "%i:00 - %i:00", element.start, element.end)
        periodLabel.attributedText = period.attributed(with: periodAttrs)
        
        let count = String(format: "%ix", element.count)
        countLabel.attributedText = count.attributed(with: countAttrs)
        
        var schedule: String {
            let schedule = element.weekSchedule
            
            var days = [DayOfWeek]()
            
            if schedule.su { days.append(.su) }
            if schedule.mo { days.append(.mo) }
            if schedule.tu { days.append(.tu) }
            if schedule.we { days.append(.we) }
            if schedule.th { days.append(.th) }
            if schedule.fr { days.append(.fr) }
            if schedule.sa { days.append(.sa) }
            
            if days.count == 7 {
                return "Reminders.EveryDay".localized
            }
            
            return days
                .map { $0.localized }
                .joined(separator: ", ")
        }
        scheduleLabel.attributedText = schedule.attributed(with: scheduleAttrs)
        
        let categories = element.categories
            .map { $0.name }
            .joined(separator: ", ")
        categoriesLabel.attributedText = categories.attributed(with: categoriesAttrs)
        
        switchView.isOn = element.enable
        
        container.alpha = element.enable ? 1 : 0.25
    }
}

// MARK: Private
private extension RemindersTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didSwitch() {
        didChangeEnable?()
    }
}

// MARK: Make constraints
private extension RemindersTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 116.scale)
        ])
        
        NSLayoutConstraint.activate([
            periodLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            periodLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 13.scale),
            periodLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -70.scale)
        ])
        
        NSLayoutConstraint.activate([
            scheduleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            scheduleLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 5.scale),
            scheduleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -70.scale)
        ])
        
        NSLayoutConstraint.activate([
            countPlaceholderView.widthAnchor.constraint(equalToConstant: 45.scale),
            countPlaceholderView.heightAnchor.constraint(equalToConstant: 45.scale),
            countPlaceholderView.topAnchor.constraint(equalTo: container.topAnchor, constant: 13.scale),
            countPlaceholderView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -17.scale)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: countPlaceholderView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countPlaceholderView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -17.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            categoriesLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            categoriesLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -70.scale),
            categoriesLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            switchView.widthAnchor.constraint(equalToConstant: 47.scale),
            switchView.heightAnchor.constraint(equalToConstant: 27.scale),
            switchView.centerYAnchor.constraint(equalTo: categoriesLabel.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -17.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RemindersTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 245, green: 247, blue: 249)
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCountPlacehoderView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 22.5.scale
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.tintColor = UIColor(integralRed: 217, green: 217, blue: 217)
        view.onTintColor = UIColor.white
        view.thumbTintColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
