//
//  AllShipsViewController.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 18/12/2024.
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let headerHeight: CGFloat = 40.0
    static let estimatedRowHeight: CGFloat = 112.0
    static let headerTitle = "Full list of ships"
    static let screenTitle = "All ships"
    static let logoutTitleGuest = "Exit"
    static let logoutTitleUser = "Logout"
}

final class AllShipsViewController: UIViewController {
    private let viewModel: AllShipsViewModel
    private let disposeBag = DisposeBag()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ShipInfoTableViewCell.self, forCellReuseIdentifier: ShipInfoTableViewCell.reuseIdentifier)
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderView.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: Life cycle
    init(viewModel: AllShipsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        bindViewModel()

        viewModel.fetchShips()
    }
}

// MARK: UITableViewDelegate
extension AllShipsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderView.reuseIdentifier),
              let tableViewHeader = header as? TableViewHeaderView else {
            return nil
        }
        tableViewHeader.configure(with: Constants.headerTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { Constants.headerHeight }
}

private extension AllShipsViewController {
    func setupUI() {
        title = Constants.screenTitle
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        setupLogoutButton()
        setupLayout()
    }
    
    func setupLogoutButton() {
        let logoutButtonTitle = viewModel.isGuestMode ? Constants.logoutTitleGuest : Constants.logoutTitleUser
        let logoutButton = UIBarButtonItem(title: logoutButtonTitle, style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func handleLogout() {
        navigateToLoginScreen()
    }
    
    func navigateToLoginScreen() {
        guard let navigationController else {
            showError(AppError(message: "NavigationController is not available"))
            return
        }
        
        navigationController.popViewController(animated: true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupTableView() {
        tableView.delegate = self
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                self.confirmDeletion(at: indexPath)
            })
            .disposed(by: disposeBag)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func bindViewModel() {
        let identifier = ShipInfoTableViewCell.reuseIdentifier
        let cellType = ShipInfoTableViewCell.self
        viewModel.ships
            .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { _, ship, cell in
                cell.configure(with: ship)
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                showError(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.isNetworkAvailable
            .subscribe(onNext: { [weak self] isAvailable in
                guard let self else { return }
                if isAvailable {
                    // TODO: - Need to hide alert?
                } else {
                    // TODO: - Hide alert
                    showNoNetworkAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isRefreshing in
                guard let self else { return }
                if isRefreshing {
                    refreshControl.beginRefreshing()
                } else {
                    refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func navigateToShipDetailsScreen() {
        // TODO: Open ShipDetailsViewController
        
        // TODO: Present modally
    }
    
    @objc func handleRefresh() {
        viewModel.fetchShips()
    }
    
    func confirmDeletion(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete ship",
            message: "Are you sure you want to delete this ship?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            deleteShip(at: indexPath)
        }))
        present(alert, animated: true)
    }
    
    func deleteShip(at indexPath: IndexPath) {
        viewModel.deleteShip(at: indexPath)
        
        UIView.transition(with: tableView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
    }
}

