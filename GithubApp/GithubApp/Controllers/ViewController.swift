//
//  ViewController.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import UIKit

class ViewController: UIViewController, StoryBoarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemsService: ItemsService!
    
    var repositoryViewModels = [RepositoryViewModel]()
    
    var onRefresh: (() -> ())?
    
    let refreshControl = UIRefreshControl()
    
    var skeletonCellProvider: CellProvider!
    
    var cellProvider: CellProvider!
    
    lazy var animatedButtonView = AnimatedButtonView(animationFileName: "4506-retry-and-user-busy-version-2", buttonTitle: "RETRY", title: "Something went wrong...", subtitle: "An alien is probably blocking your signal") { [weak self] in
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
        return isLoading ? skeletonCellProvider(tableView, indexPath) : cellProvider(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        let repositoryViewModel = repositoryViewModels[indexPath.row]
        repositoryViewModel.select()
    }
    
}

extension ViewController {
    
    func getItem(at indexPath: IndexPath) -> RepositoryViewModel {
        return repositoryViewModels[indexPath.row]
    }
    
}

