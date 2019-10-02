//
//  SettingScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class SettingScreenViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!

    var settingScreenViewModel: SettingScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 5
    }

    // Обращаемся к View Model и передаем туда новое значение для сохранения
    // Далее удаляем содержимое текстового поля, чтобы этого не делал пользователь вручную.
    // Также не даем сохранять пустую строку и выводим соответствующий "алерт".
    @IBAction private func saveButtonAction(_ sender: UIButton) {
        if textField.text!.isEmpty {
            let alert = UIAlertController(title: L10n.EmptyTFAlert.title,
                                          message: L10n.EmptyTFAlert.message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
        settingScreenViewModel.newAnswer = textField.text
            textField.text?.removeAll()
        }
    }

    // Обращаемся к View Model и просим удалить последний элемент из хранилища
    @IBAction private func removeLastAnswer(_ sender: UIButton) {
        settingScreenViewModel.removeLastAnswer()
    }

    // Обращаемся к View Model и просим удалить все элементы из хранилища
    @IBAction private func clearButton(_ sender: UIButton) {
        settingScreenViewModel.removeAllAnswers()
    }

    // Данный метод нам нужен для того, что бы мы всегда могли убрать клавиатуру с экрана
    @IBAction private func endEditingOnTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
