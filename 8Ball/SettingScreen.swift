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
    }
    
    // Сохраняем введенный пользователем ответ в массив дефолтных ответов. Также фильтруем массив на наличие пустых строк, которые могут возникать, когда мы удаляем содержимое массива либо если пользователь просто нажал "Сохранить" и при этом ничего не ввел в текстовое поле. Далее удаляем содержимое текстового поля, чтобы этого не делал пользователь вручную.
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        userArray.append(textField.text!)
        userArray = userArray.filter(){ $0 != "Please add your answers at the setting screen!" }
        textField.text = ""
        print(userArray)
    }
    
    // Данная кнопка позволяет удалить последний добавленный элемент, но всегда оставляет один дефолтный ответ
    
    @IBAction func removeLastAnswer(_ sender: UIButton) {
        if userArray.count > 1 {
        userArray.removeLast()
        }
    }
    
    // Данная кнопка удаляет все элементы массива и присваивает ему один стандартный элемент с нейтральным ответом
    
    @IBAction func clearButton(_ sender: UIButton) {
        userArray = ["Please add your answers at the setting screen!"]
        print(userArray)
    }
    
    // Данный метод нам нужен для того, что бы мы всегда могли убрать клавиатуру с экрана
    
    @IBAction func endEditingOnTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    



}
