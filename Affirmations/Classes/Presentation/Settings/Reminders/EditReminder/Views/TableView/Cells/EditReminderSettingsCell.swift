//
//  EditReminderSettingsCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit

final class EditReminderSettingsCell: UITableViewCell {
    lazy var countView = makeCountView()
    lazy var starView = makeStartView()
    lazy var endView = makeEndView()
    
    private var element: EditReminderSettings!
    
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
extension EditReminderSettingsCell {
    func setup(element: EditReminderSettings) {
        self.element = element
        
        starView.value = element.start
        starView.setup(end: element.end)
        endView.value = element.end
        endView.setup(start: element.start)
        countView.value = element.count
        changeCountValues()
    }
}

// MARK: Private
private extension EditReminderSettingsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        starView.changedValue = { [weak self] value in
            self?.endView.setup(start: value)
            self?.changeCountValues()
            self?.element.start = value
        }
        endView.changedValue = { [weak self] value in
            self?.starView.setup(end: value)
            self?.changeCountValues()
            self?.element.end = value
        }
        countView.changedValue = { [weak self] value in
            self?.element.count = value
        }
    }
    
    func changeCountValues() {
        let diffInHours = endView.value - starView.value
        countView.setup(diffInHours: diffInHours)
    }
}

// MARK: Make constraints
private extension EditReminderSettingsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            countView.leadingAnchor.constraint(equalTo: leadingAnchor),
            countView.trailingAnchor.constraint(equalTo: trailingAnchor),
            countView.heightAnchor.constraint(equalToConstant: 55.scale),
            countView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            starView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starView.trailingAnchor.constraint(equalTo: trailingAnchor),
            starView.heightAnchor.constraint(equalToConstant: 55.scale),
            starView.topAnchor.constraint(equalTo: countView.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            endView.leadingAnchor.constraint(equalTo: leadingAnchor),
            endView.trailingAnchor.constraint(equalTo: trailingAnchor),
            endView.heightAnchor.constraint(equalToConstant: 55.scale),
            endView.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 5.scale),
            endView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension EditReminderSettingsCell {
    func makeCountView() -> ONSCountView {
        let view = ONSCountView(style: .settings)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStartView() -> ONSStartView {
        let view = ONSStartView(values: Array(0...9), value: 9, style: .settings)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeEndView() -> ONSEndView {
        let view = ONSEndView(values: Array(10...24), value: 10, style: .settings)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
