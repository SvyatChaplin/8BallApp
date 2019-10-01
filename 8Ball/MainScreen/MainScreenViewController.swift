//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit
import Alamofire

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

    private func setupDataBindings() {
        mainScreenViewModel.didUpdateAnswer = { [weak answerLabel] answer in
            answerLabel?.text = answer ?? L10n.wellcomeText
        }
        mainScreenViewModel.didUpdateActivityState = { [weak self] shouldShow in
            if shouldShow {
                self?.startAnimatingIndicator()
            } else {
                self?.stopAnimatingIndicator()
            }
        }
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

    // По "встряхиванию" проверяем событие на "шейк"
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        answerLabel.text?.removeAll()
        mainScreenViewModel.attemptToRequestAnAnswer?()
    }
}
