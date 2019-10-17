//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    private lazy var nameLabel = UILabel()
    private lazy var answerLabel = UILabel()
    private lazy var viewForAnswer = UIView()
    private lazy var backgroundImageView = UIImageView()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var counterLabel = UILabel()

    var mainScreenViewModel: MainScreenViewModel

    init(mainScreenViewModel: MainScreenViewModel) {
        self.mainScreenViewModel = mainScreenViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupDataBindings()
        askForCounterData()
        setupUI()
        setupLabelsLayout()
        setupLayout()
    }

    // Устанавливаем связи с View Model
    private func setupDataBindings() {
        // Обновляем ответ
        mainScreenViewModel.didUpdateAnswer = { [weak answerLabel] (answer, errorText) in
            answerLabel?.text = answer?.text ?? errorText
        }
        // Обновляем количество шеков
        mainScreenViewModel.didUpdateCounter = { [weak counterLabel] count in
            counterLabel?.text = count
        }
        // Обрабатываем ошибки
        mainScreenViewModel.didReciveAnError = { [weak self] (error, errorText) in
            self?.alert(error: error)
            self?.answerLabel.text = errorText
        }
        // Обновляем состояние индикатора активности
        mainScreenViewModel.didUpdateActivityState = { [weak self] shouldShow in
            if shouldShow {
                self?.startAnimatingIndicator()
            } else {
                self?.stopAnimatingIndicator()
            }
        }
    }

    // По "встряхиванию" проверяем событие на "шейк" и просим View Model выдать нам ответ
    // Также отправляем данные для записи в KeyChain
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        answerLabel.text?.removeAll()
        mainScreenViewModel.attemptToRequestAnAnswer?()
    }

    // Запрос данных для счетчика
    private func askForCounterData() {
        mainScreenViewModel.requestCounter?()
    }

    // Метод для настройки UI - элементов
    private func setupUI() {
        // counterLabel setup
        counterLabel.numberOfLines = 0
        counterLabel.textColor = .white
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont(name: L10n.fontName, size: 20)
        counterLabel.shadowColor = ColorName.darkPurple.color
        counterLabel.shadowOffset = .init(width: 2, height: 2)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(counterLabel)
        // logoLabel setup
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = L10n.logo
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: L10n.fontName, size: 57)
        nameLabel.shadowColor = ColorName.darkPurple.color
        nameLabel.shadowOffset = .init(width: 4, height: 4)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameLabel)
        // viewForAnswer setup
        viewForAnswer.contentMode = .scaleToFill
        viewForAnswer.backgroundColor = .none
        viewForAnswer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewForAnswer)
        // backgroundImage setup
        backgroundImageView.image = Asset._8ballcut.image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImageView)
        // answerLabel setup
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        answerLabel.text = L10n.wellcomeText
        answerLabel.textColor = .white
        answerLabel.font = UIFont(name: L10n.fontName, size: 24)
        answerLabel.shadowColor = ColorName.darkPurple.color
        answerLabel.shadowOffset = .init(width: 3, height: 3)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(answerLabel)
        // activityIndicator setup
        activityIndicator.isHidden = true
        activityIndicator.style = .whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)

    }

    // Методы для настройки Layout
    private func setupLabelsLayout() {
        NSLayoutConstraint.activate([
            // counterLabel constraints
            counterLabel.topAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            counterLabel.centerXAnchor.constraint(equalTo:
                self.view.centerXAnchor),
            counterLabel.heightAnchor.constraint(equalTo:
                counterLabel.widthAnchor, multiplier: 1/2),
            // nameLabel constraints
            nameLabel.topAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 112),
            nameLabel.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -112),
            nameLabel.heightAnchor.constraint(equalTo:
                nameLabel.widthAnchor, multiplier: 79/150),
            // answerLabel constraints
            answerLabel.bottomAnchor.constraint(equalTo:
                self.viewForAnswer.bottomAnchor, constant: -51),
            answerLabel.leadingAnchor.constraint(equalTo:
                self.viewForAnswer.leadingAnchor, constant: 81),
            answerLabel.trailingAnchor.constraint(equalTo:
                self.viewForAnswer.trailingAnchor, constant: -81),
            answerLabel.heightAnchor.constraint(equalTo:
                self.answerLabel.widthAnchor, multiplier: 229/213)
        ])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            // viewForAnswer constraints
            viewForAnswer.bottomAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            viewForAnswer.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 0),
            viewForAnswer.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: 0),
            viewForAnswer.heightAnchor.constraint(equalTo:
                viewForAnswer.widthAnchor, multiplier: 473/375),
            // backgroundImageView constraints
            backgroundImageView.bottomAnchor.constraint(equalTo:
                self.viewForAnswer.bottomAnchor, constant: 0),
            backgroundImageView.leadingAnchor.constraint(equalTo:
                self.viewForAnswer.leadingAnchor, constant: 0),
            backgroundImageView.trailingAnchor.constraint(equalTo:
                self.viewForAnswer.trailingAnchor, constant: 0),
            backgroundImageView.heightAnchor.constraint(equalTo:
                self.backgroundImageView.widthAnchor, multiplier: 473/375),
            // activityIndicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo:
                self.answerLabel.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo:
                self.answerLabel.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalTo:
                self.activityIndicator.widthAnchor, multiplier: 229/37)
        ])
    }
}

extension MainScreenViewController {

    // Алерт ошибки загрузки ответа из сети
    private func alert(error: Error) {
        let alert = UIAlertController(title: L10n.ConnectionError.title,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // Функция запуска индикатора активности
    private func startAnimatingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    // Функция остановки индикатора активности
    private func stopAnimatingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

}
