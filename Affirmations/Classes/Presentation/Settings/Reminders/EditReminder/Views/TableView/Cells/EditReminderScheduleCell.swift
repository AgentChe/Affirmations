//
//  EditReminderScheduleCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit

final class EditReminderScheduleCell: UITableViewCell {
    var didChange: (() -> Void)?
    
    lazy var suButton = makeDayButton(day: .su)
    lazy var moButton = makeDayButton(day: .mo)
    lazy var tuButton = makeDayButton(day: .tu)
    lazy var weButton = makeDayButton(day: .we)
    lazy var thButton = makeDayButton(day: .th)
    lazy var frButton = makeDayButton(day: .fr)
    lazy var saButton = makeDayButton(day: .sa)
    
    private var element: EditReminderSchedule!
    
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
extension EditReminderScheduleCell {
    func setup(element: EditReminderSchedule) {
        self.element = element
        
        [
            suButton,
            moButton,
            tuButton,
            weButton,
            thButton,
            frButton,
            saButton
        ].forEach { button in
            button.marked = element.selectedDays.contains(where: { $0 == button.day })
        }
    }
}

// MARK: Private
private extension EditReminderScheduleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTap(button: DayButton) {
        button.marked.toggle()
        
        if button.marked {
            element.selectedDays.append(button.day)
        } else {
            element.selectedDays.removeAll(where: { $0 == button.day })
        }
        
        didChange?()
    }
}

// MARK: Make constraints
private extension EditReminderScheduleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            suButton.widthAnchor.constraint(equalToConstant: 44.scale),
            suButton.heightAnchor.constraint(equalToConstant: 44.scale),
            suButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            suButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            suButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            moButton.widthAnchor.constraint(equalToConstant: 44.scale),
            moButton.heightAnchor.constraint(equalToConstant: 44.scale),
            moButton.leadingAnchor.constraint(equalTo: suButton.trailingAnchor, constant: 6.scale),
            moButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            moButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tuButton.widthAnchor.constraint(equalToConstant: 44.scale),
            tuButton.heightAnchor.constraint(equalToConstant: 44.scale),
            tuButton.leadingAnchor.constraint(equalTo: moButton.trailingAnchor, constant: 6.scale),
            tuButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            tuButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weButton.widthAnchor.constraint(equalToConstant: 44.scale),
            weButton.heightAnchor.constraint(equalToConstant: 44.scale),
            weButton.leadingAnchor.constraint(equalTo: tuButton.trailingAnchor, constant: 6.scale),
            weButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            weButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thButton.widthAnchor.constraint(equalToConstant: 44.scale),
            thButton.heightAnchor.constraint(equalToConstant: 44.scale),
            thButton.leadingAnchor.constraint(equalTo: weButton.trailingAnchor, constant: 6.scale),
            thButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            thButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            frButton.widthAnchor.constraint(equalToConstant: 44.scale),
            frButton.heightAnchor.constraint(equalToConstant: 44.scale),
            frButton.leadingAnchor.constraint(equalTo: thButton.trailingAnchor, constant: 6.scale),
            frButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            frButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            saButton.widthAnchor.constraint(equalToConstant: 44.scale),
            saButton.heightAnchor.constraint(equalToConstant: 44.scale),
            saButton.leadingAnchor.constraint(equalTo: frButton.trailingAnchor, constant: 6.scale),
            saButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale),
            saButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension EditReminderScheduleCell {
    func makeDayButton(day: DayOfWeek) -> DayButton {
        let view = DayButton(day: day)
        view.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
