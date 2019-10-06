//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!

    var mainScreenViewModel: MainScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        answerLabel.text = L10n.wellcomeText
        imageView.image = Asset._8ballcut.image
        setupDataBindings()
    }

    // Устанавливаем связи с View Model
    private func setupDataBindings() {
        mainScreenViewModel.didUpdateAnswer = { [weak answerLabel] (answer, errorText) in
            answerLabel?.text = answer?.presentableAnswer ?? errorText
        }
        mainScreenViewModel.didReciveAnError = { [weak self] (error, errorText) in
            self?.alert(error: error)
            self?.answerLabel.text = errorText
        }
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
