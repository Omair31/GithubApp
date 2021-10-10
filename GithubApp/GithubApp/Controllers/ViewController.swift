//
//  ViewController.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import UIKit
import Lottie

class ViewController: UIViewController, StoryBoarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemsService: ItemsService!
    
    var repositoryViewModels = [RepositoryViewModel]()
    
    var onRefresh: (() -> ())?
    
    let refreshControl = UIRefreshControl()
    
    lazy var animatedButtonView = AnimatedButtonView(animationFileName: "4506-retry-and-user-busy-version-2", buttonTitle: "RETRY") { [weak self] in
        self?.showSkeletonItems()
        self?.loadItems()
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellFromNib(cellName: RepoTableViewCell.cellIdentifier)
        setupDelegates()
        addRefreshControl()
        setupAnimationView()
        showSkeletonItems()
    }
    
    func addRefreshControl() {
        tableView.refreshControl = refreshControl
    }
    
    func registerCellFromNib(cellName: String) {
        tableView.registerCellFromNib(cellName: cellName)
    }
    
    fileprivate func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupAnimationView() {
        animatedButtonView.frame = view.bounds
        hideAnimationView()
        view.addSubview(animatedButtonView)
    }
    
    func hideAnimationView() {
        animatedButtonView.isHidden = true
    }
    
    @objc func handleRefresh() {
        onRefresh?()
    }
    
    func showSkeletonItems() {
        isLoading = true
        tableView.reloadData()
    }
    
    func showAnimationView() {
        animatedButtonView.isHidden = false
    }
    
    func loadItems() {
        hideAnimationView()
        itemsService.fetchItems { result in
            switch result {
            case .success(let repositoryViewModels):
                self.isLoading = false
                self.repositoryViewModels = repositoryViewModels
                self.refreshControl.endRefreshing()
                self.hideAnimationView()
                self.tableView.isHidden = false
                self.tableView.reloadData()
            case .failure(_):
                self.tableView.isHidden = true
                self.showAnimationView()
            }
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 8 : repositoryViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellIdentifier) as? RepoTableViewCell else { return UITableViewCell() }
        if isLoading {
            cell.showSkeletonView()
        } else {
            cell.hideSkeletonView()
            let repositoryViewModel = repositoryViewModels[indexPath.row]
            cell.configureCell(repositoryViewModel: repositoryViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        let repositoryViewModel = repositoryViewModels[indexPath.row]
        repositoryViewModel.select()
    }
    
}

