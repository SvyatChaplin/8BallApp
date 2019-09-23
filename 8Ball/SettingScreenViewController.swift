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
    private var userOrDefaultAnswers = AnswerProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 5
    }
    // Сохраняем введенный пользователем ответ в массив дефолтных ответов.
    // Далее удаляем содержимое текстового поля, чтобы этого не делал пользователь вручную.
    // Также не даем сохранять пустую строку и выводим соответствующий "алерт".
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if textField.text == "" {
            let alert = UIAlertController(title: "Empty answer",
                                          message: "Please enter a little bit longer answer 😉",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
        userOrDefaultAnswers.answers.append(textField.text!)
        textField.text = ""
        }
    }
    // Данная кнопка позволяет удалить последний добавленный элемент
    @IBAction func removeLastAnswer(_ sender: UIButton) {
        if userOrDefaultAnswers.answers.count > 1 {
        userOrDefaultAnswers.answers.removeLast()
        } else {
            userOrDefaultAnswers.answers = []
        }
    }
    // Данная кнопка удаляет все элементы массива
    @IBAction func clearButton(_ sender: UIButton) {
        userOrDefaultAnswers.answers = []
    }
    // Данный метод нам нужен для того, что бы мы всегда могли убрать клавиатуру с экрана
    @IBAction func endEditingOnTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
