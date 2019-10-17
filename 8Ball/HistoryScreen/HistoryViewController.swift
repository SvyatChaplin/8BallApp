//
//  HistoryViewController.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.backgroundColor = .black
        tableView.separatorColor = ColorName.darkPurple.color

    }

    override func viewWillAppear(_ animated: Bool) {
        super.tableView.reloadData()
    }

    private func setupObserver() {
        historyViewModel.observeAnswerList { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
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
