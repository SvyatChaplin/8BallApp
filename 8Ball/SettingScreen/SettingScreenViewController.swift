//
//  SettingScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class SettingScreenViewController: UIViewController {

    private lazy var textField = UITextField()
    private lazy var saveButton = UIButton()
    private lazy var removeAllButton = UIButton()
    private lazy var screenNameLabel = UILabel()

    var settingScreenViewModel: SettingScreenViewModel

    init(settingScreenViewModel: SettingScreenViewModel) {
        self.settingScreenViewModel = settingScreenViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupUI()
        setupLayout()
    }

    // Обращаемся к View Model и передаем туда новое значение для сохранения
    // Далее удаляем содержимое текстового поля, чтобы этого не делал пользователь вручную.
    // Также не даем сохранять пустую строку и выводим соответствующий "алерт".
    @objc private func saveAnswer(_ sender: UIButton!) {
        // Добавляем анимацию
        buttonAnimation(sender)
        if textField.text!.isEmpty {
            let alert = UIAlertController(title: L10n.EmptyTFAlert.title,
                                          message: L10n.EmptyTFAlert.message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            settingScreenViewModel.sendNewAnswer(textField.text!)
            textField.text?.removeAll()
        }
    }

    // Обращаемся к View Model и просим удалить все элементы из хранилища
    @objc private func removeAllAnswers(_ sender: UIButton!) {
        buttonAnimation(sender)
        settingScreenViewModel.removeAllAnswers()
    }

    // Данный метод нам нужен для того, что бы мы всегда могли убрать клавиатуру с экрана
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // Анимация для кнопок
    private func buttonAnimation(_ sender: UIButton!) {
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96) },
                         completion: { _ in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }

}

extension SettingScreenViewController {

    private func setupUI() {
        // screenName setup
        screenNameLabel.text = L10n.settingScreen
        screenNameLabel.numberOfLines = 0
        screenNameLabel.textAlignment = .center
        screenNameLabel.textColor = .white
        screenNameLabel.font = UIFont(name: L10n.fontName, size: 25)
        screenNameLabel.shadowColor = ColorName.darkPurple.color
        screenNameLabel.shadowOffset = .init(width: 2, height: 2)
        screenNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenNameLabel)
        // textLabel setup
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .yes
        textField.keyboardType = .default
        textField.placeholder = L10n.textFieldText
        textField.autocapitalizationType = .sentences
        textField.font = UIFont(name: L10n.fontName, size: 13)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        // saveButton setup
        saveButton.backgroundColor = ColorName.darkPurple.color
        saveButton.setTitle(L10n.Buttons.save, for: .normal)
        saveButton.layer.cornerRadius = 5
        saveButton.titleLabel?.font = UIFont(name: L10n.fontName, size: 19)
        saveButton.addTarget(self, action: #selector(saveAnswer(_:)), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(saveButton)
        // removeAllButton setup
        removeAllButton.backgroundColor = .none
        removeAllButton.setTitle(L10n.Buttons.removeAll, for: .normal)
        removeAllButton.setTitleColor(.systemRed, for: .normal)
        removeAllButton.layer.cornerRadius = 5
        removeAllButton.titleLabel?.font = UIFont(name: L10n.fontName, size: 17)
        removeAllButton.addTarget(self, action: #selector(removeAllAnswers(_:)), for: .touchUpInside)
        removeAllButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(removeAllButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            // textField constraints
            textField.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -40),
            textField.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 40),
            textField.centerYAnchor.constraint(equalTo:
                self.view.centerYAnchor),
            textField.heightAnchor.constraint(equalTo:
                self.textField.widthAnchor, multiplier: 6/59),
            // screenName constraints
            screenNameLabel.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -62),
            screenNameLabel.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 62),
            screenNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            screenNameLabel.heightAnchor.constraint(equalTo:
                self.textField.widthAnchor, multiplier: 4/21),
            // saveButton constraints
            saveButton.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -68),
            saveButton.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 68),
            saveButton.topAnchor.constraint(equalTo:
                self.textField.bottomAnchor, constant: 25),
            saveButton.heightAnchor.constraint(equalTo:
                self.textField.widthAnchor, multiplier: 40/239),
            // removeAllButton constraints
            removeAllButton.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -68),
            removeAllButton.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 68),
            removeAllButton.bottomAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            removeAllButton.heightAnchor.constraint(equalTo:
                self.removeAllButton.widthAnchor, multiplier: 40/239)
        ])
    }
}
