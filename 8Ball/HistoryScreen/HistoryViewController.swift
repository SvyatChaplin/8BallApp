//
//  HistoryViewController.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    private lazy var addButton = UIButton()

    let historyViewModel: HistoryViewModel

    init(historyViewModel: HistoryViewModel) {
        self.historyViewModel = historyViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupUI()
        setupLayout()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.backgroundColor = .black
        tableView.separatorColor = ColorName.darkPurple.color

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    private func setupObserver() {
        historyViewModel.observeAnswerList { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update( _, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    @objc private func addButtonAction(_ sender: UIButton!) {
        buttonAnimation(sender)
        actionSheet()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.numberOfAnswers()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = historyViewModel.getAnswer(at: indexPath.row).text
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: L10n.fontName, size: 22)

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            historyViewModel.removeAnswer(at: indexPath.row)
        }
    }
}

extension HistoryViewController {

    private func setupUI() {
        addButton.backgroundColor = ColorName.darkPurple.color
        addButton.setTitleColor(.black, for: .normal)
        addButton.setTitle("+", for: .normal)
        addButton.layer.cornerRadius = 30
        addButton.titleLabel?.font = UIFont(name: L10n.fontName, size: 30)
        addButton.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -23),
            addButton.bottomAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.bottomAnchor, constant: -23),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    // animation for addButton
    private func buttonAnimation(_ sender: UIButton!) {
        UIButton.animate(
            withDuration: 0.1,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                sender.alpha = 0.0
        },
            completion: { _ in
                UIButton.animate(
                    withDuration: 0.1,
                    animations: {
                        sender.transform = CGAffineTransform.identity
                        sender.alpha = 1
                })
        })
    }

    // alert with textField
    private func textFieldAlert() {
        let alert = UIAlertController(title: L10n.textFieldText,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .none
            textField.autocorrectionType = .yes
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
            textField.font = UIFont(name: L10n.fontName, size: 15)
        }
        let saveAction = UIAlertAction(
            title: L10n.Buttons.save,
            style: .default) { [weak alert] (_) in
                guard let textField = alert?.textFields?[0] else { return }
                guard let text = textField.text else { return }
                if text.isEmpty {
                    self.emptyAnswerAlert()
                } else {
                    self.historyViewModel.sendNewAnswer(text)
                }
        }
        alert.addAction(saveAction)
        let cancelAction = UIAlertAction(title: L10n.Buttons.cancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    // warning alert for empty answer
    private func emptyAnswerAlert() {
        let alert = UIAlertController(title: L10n.EmptyTFAlert.title,
                                      message: L10n.EmptyTFAlert.message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    // actionSheet for "add", "remove all" and "cancel" buttons
    private func actionSheet() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: L10n.textFieldText,
                                      style: .default,
                                      handler: { [weak self] (_) in
                                        self?.textFieldAlert()
        }))
        alert.addAction(UIAlertAction(title: L10n.Buttons.removeAll,
                                      style: .destructive,
                                      handler: { [weak self] (_) in
                                        self?.historyViewModel.removeAllAnswers()
        }))
        alert.addAction(UIAlertAction(title: L10n.Buttons.cancel, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
