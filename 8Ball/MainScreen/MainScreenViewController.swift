//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {

    private lazy var logoLabel = UILabel()
    private lazy var answerLabel = UILabel()
    private lazy var viewForAnswer = UIView()
    private lazy var ballImageView = UIImageView()
    private lazy var counterLabel = UILabel()

    private lazy var safeAreaView = UIView()
    private lazy var animationBall = UIView()
    private lazy var animationBall1 = UIView()

    private var shouldAnimate: Bool = false
    private let disposeBag = DisposeBag()

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
        setupRxBindings()
        askForCounterData()
        setupUI()
        setupLabelsLayout()
        setupLayout()
        setupAnimationViews()
        setupAnimationViewsLayouts()
    }

    private func setupRxBindings() {
        mainScreenViewModel.loadingState
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                self.shouldAnimate = state
                self.ballAnimation()
                self.ballAnimation1()
            })
            .disposed(by: disposeBag)

        mainScreenViewModel.didUpdateAnswer
            .map { $0.text }
            .bind(to: answerLabel.rx.text)
            .disposed(by: disposeBag)

        mainScreenViewModel.didReceiveAnError
            .filter { $0.error != nil }
            .map { $0.error! }
            .subscribe(onNext: { [weak self] (error) in
                self?.alert(error: error)
            })
            .disposed(by: disposeBag)

        mainScreenViewModel.didReceiveAnError
            .map { $0.errorText }
            .bind(to: answerLabel.rx.text)
            .disposed(by: disposeBag)

        mainScreenViewModel.didUpdateCounter
            .bind(to: counterLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // Detecting shake action
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        answerLabel.text?.removeAll()
        mainScreenViewModel.shakeAction.onNext(())
    }

    // Ask for caunter data
    private func askForCounterData() {
        mainScreenViewModel.requestCounter.onNext(())
    }

}

extension MainScreenViewController {

    // Internet connection Alert
    private func alert(error: Error) {
        let alert = UIAlertController(title: L10n.ConnectionError.title,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - animations

    private func ballAnimation() {
        let shoudAnimate = shouldAnimate
        if !shoudAnimate { return }
        answerLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        answerLabel.alpha = 0
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.animationBall.isHidden = false
                self.animationBall.transform = CGAffineTransform(scaleX: 100, y: 100)
                self.animationBall.alpha = 0
        }, completion: { [weak self] _ in
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self?.animationBall.transform = .identity
                    self?.animationBall.alpha = 1
                    self?.animationBall.isHidden = true

            }, completion: { [weak self] _ in
                self?.ballAnimation()
            })
        })
    }

    private func ballAnimation1() {
        let shoudAnimate = shouldAnimate
        if !shoudAnimate { return }
        UIView.animate(
            withDuration: 1.2,
            delay: 0.6,
            options: .curveEaseOut,
            animations: {
                self.animationBall1.isHidden = false
                self.animationBall1.transform = CGAffineTransform(scaleX: 1500, y: 1500)
                self.animationBall1.alpha = 0
                self.answerLabel.alpha = 1
                self.answerLabel.transform = .identity
        }, completion: { [weak self] _ in
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self?.animationBall1.transform = .identity
                    self?.animationBall1.alpha = 1
                    self?.animationBall1.isHidden = true

            }, completion: { [weak self] _ in
                self?.ballAnimation1()
            })
        })
    }

    // MARK: - Setup UI and Layout

    private func setupAnimationViews() {
        safeAreaView.backgroundColor = .none
        safeAreaView.clipsToBounds = true
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        animationBall.isHidden = true
        animationBall.backgroundColor = ColorName.darkPurple.color
        animationBall.layer.cornerRadius = 12.5
        animationBall.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(animationBall)
        animationBall1.isHidden = true
        animationBall1.backgroundColor = ColorName.darkPurple.color
        animationBall1.layer.cornerRadius = 0.5
        animationBall1.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(animationBall1)
        self.view.addSubview(safeAreaView)
        self.view.sendSubviewToBack(safeAreaView)
    }

    private func setupAnimationViewsLayouts() {
        NSLayoutConstraint.activate([
            //safe area view setup
            safeAreaView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            safeAreaView.topAnchor.constraint(equalTo: self.view.topAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            // View for animation
            animationBall.centerXAnchor.constraint(equalTo: self.answerLabel.centerXAnchor),
            animationBall.centerYAnchor.constraint(equalTo: self.answerLabel.centerYAnchor),
            animationBall.widthAnchor.constraint(equalToConstant: 25),
            animationBall.heightAnchor.constraint(equalToConstant: 25),
            // second ball
            animationBall1.centerXAnchor.constraint(equalTo: self.answerLabel.centerXAnchor),
            animationBall1.centerYAnchor.constraint(equalTo: self.answerLabel.centerYAnchor),
            animationBall1.widthAnchor.constraint(equalToConstant: 1),
            animationBall1.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

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
        logoLabel.numberOfLines = 0
        logoLabel.textAlignment = .center
        logoLabel.text = L10n.logo
        logoLabel.textColor = .white
        logoLabel.font = UIFont(name: L10n.fontName, size: 57)
        logoLabel.shadowColor = ColorName.darkPurple.color
        logoLabel.shadowOffset = .init(width: 4, height: 4)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoLabel)
        // viewForAnswer setup
        viewForAnswer.contentMode = .scaleToFill
        viewForAnswer.backgroundColor = .none
        viewForAnswer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewForAnswer)
        // backgroundImage setup
        ballImageView.image = Asset._8ballcut.image
        ballImageView.contentMode = .scaleAspectFill
        ballImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ballImageView)
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

    }

    private func setupLabelsLayout() {
        NSLayoutConstraint.activate([
            // counterLabel constraints
            counterLabel.topAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            counterLabel.centerXAnchor.constraint(equalTo:
                self.view.centerXAnchor),
            counterLabel.heightAnchor.constraint(equalTo:
                counterLabel.widthAnchor, multiplier: 1/2),
            // logoLabel constraints
            logoLabel.topAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoLabel.leadingAnchor.constraint(equalTo:
                self.view.leadingAnchor, constant: 112),
            logoLabel.trailingAnchor.constraint(equalTo:
                self.view.trailingAnchor, constant: -112),
            logoLabel.heightAnchor.constraint(equalTo:
                logoLabel.widthAnchor, multiplier: 79/150),
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
            // ballImageView constraints
            ballImageView.bottomAnchor.constraint(equalTo:
                self.viewForAnswer.bottomAnchor, constant: 0),
            ballImageView.leadingAnchor.constraint(equalTo:
                self.viewForAnswer.leadingAnchor, constant: 0),
            ballImageView.trailingAnchor.constraint(equalTo:
                self.viewForAnswer.trailingAnchor, constant: 0),
            ballImageView.heightAnchor.constraint(equalTo:
                self.ballImageView.widthAnchor, multiplier: 473/375)
        ])
    }

}
