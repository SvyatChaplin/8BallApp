//
//  SettingScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class SettingScreen: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 5
    }
    
    // Сохраняем введенный пользователем ответ в массив дефолтных ответов и удаляем из него призыв добавить свой ответ. Далее удаляем содержимое текстового поля, чтобы этого не делал пользователь вручную. Также не даем сохранять пустую строку и выводим соответствующий "алерт".
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if textField.text == "" {
            let alert = UIAlertController(title: "Empty answer", message: "Please enter a little bit longer answer 😉", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
        userArray.append(textField.text!)
        userArray = userArray.filter(){ $0 != "Please add your answers at the setting screen!" }
        textField.text = ""
        }
    }
    
    // Данная кнопка позволяет удалить последний добавленный элемент, но всегда оставляет один дефолтный ответ
    @IBAction func removeLastAnswer(_ sender: UIButton) {
        if userArray.count > 1 {
        userArray.removeLast()
        }
    }
    
    // Данная кнопка удаляет все элементы массива и присваивает значение, котороее сообщит пользователю о необходимости добавить свои варианты ответов
    @IBAction func clearButton(_ sender: UIButton) {
        userArray = ["Please add your answers at the setting screen!"]
    }
    
    // Данный метод нам нужен для того, что бы мы всегда могли убрать клавиатуру с экрана
    @IBAction func endEditingOnTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    



}
