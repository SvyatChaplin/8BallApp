//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    private let nameLabel = UILabel()
    private var answerLabel = UILabel()
    private let viewForAnswer = UIView()
    private let backgroundImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()

    var mainScreenViewModel: MainScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        answerLabel.text = L10n.wellcomeText
        setupDataBindings()
        setupUI()
        setupLayout()
    }

    // Устанавливаем связи с View Model
    private func setupDataBindings() {
        // Обновляем ответ
        mainScreenViewModel.didUpdateAnswer = { [weak answerLabel] (answer, errorText) in
            answerLabel?.text = answer?.presentableAnswer ?? errorText
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
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        answerLabel.text?.removeAll()
        mainScreenViewModel.attemptToRequestAnAnswer?()
    }

    // Метод для настройки UI - элементов
    private func setupUI() {

        // logoLabel setup
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = L10n.logo
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: L10n.fontName, size: 57)
        nameLabel.shadowColor = #colorLiteral(red: 0.06855161488, green: 0.1916376352, blue: 0.5435847044, alpha: 1)
        nameLabel.shadowOffset = .init(width: 4, height: 4)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameLabel)

        // viewForAnswer setup
        viewForAnswer.contentMode = .scaleToFill
        viewForAnswer.backgroundColor = .black
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
        answerLabel.shadowColor = #colorLiteral(red: 0.06855161488, green: 0.1916376352, blue: 0.5435847044, alpha: 1)
        answerLabel.shadowOffset = .init(width: 3, height: 3)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(answerLabel)

        // activityIndicator setup
        activityIndicator.isHidden = true
        activityIndicator.style = .whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)

    }

    // Метод для настройки Layout
    private func setupLayout() {

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 112),
            nameLabel.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -112),
            nameLabel.heightAnchor.constraint(equalTo:
                nameLabel.widthAnchor, multiplier: 79/150),

            // viewForanswer setup
            viewForAnswer.bottomAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            viewForAnswer.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 0),
            viewForAnswer.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: 0),
            viewForAnswer.heightAnchor.constraint(equalTo:
                viewForAnswer.widthAnchor, multiplier: 473/375),

            // imageView setup
            backgroundImageView.bottomAnchor.constraint(equalTo:
                self.viewForAnswer.bottomAnchor, constant: 0),
            backgroundImageView.leadingAnchor.constraint(equalTo:
                self.viewForAnswer.leadingAnchor, constant: 0),
            backgroundImageView.trailingAnchor.constraint(equalTo:
                self.viewForAnswer.trailingAnchor, constant: 0),
            backgroundImageView.heightAnchor.constraint(equalTo:
                self.backgroundImageView.widthAnchor, multiplier: 473/375),

            // answerLabel setup
            answerLabel.bottomAnchor.constraint(equalTo:
                self.viewForAnswer.bottomAnchor, constant: -51),
            answerLabel.leadingAnchor.constraint(equalTo:
                self.viewForAnswer.leadingAnchor, constant: 81),
            answerLabel.trailingAnchor.constraint(equalTo:
                self.viewForAnswer.trailingAnchor, constant: -81),
            answerLabel.heightAnchor.constraint(equalTo:
                self.answerLabel.widthAnchor, multiplier: 229/213),

            // activity indicator setup
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
