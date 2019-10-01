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

    private var answerProvider = AnswerProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 5
    }

    // Сохраняем введенный пользователем ответ в массив дефолтных ответов.
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
        answerProvider.answers.append(textField.text!)
            textField.text?.removeAll()
        }
    }

    // Данная кнопка позволяет удалить последний добавленный элемент
    @IBAction private func removeLastAnswer(_ sender: UIButton) {
        if answerProvider.answers.count > 1 {
        answerProvider.answers.removeLast()
        } else {
            answerProvider.answers = []
        }
    }

    // Данная кнопка удаляет все элементы массива
    @IBAction private func clearButton(_ sender: UIButton) {
        answerProvider.answers = []
    }

    // Данный метод нам нужен для того, что бы мы всегда могли убрать клавиатуру с экрана
    @IBAction private func endEditingOnTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
