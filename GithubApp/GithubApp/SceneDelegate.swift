//
//  SceneDelegate.swift
//  GithubApp
//
//  Created by VenD-Omeir on 08/10/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navController = UINavigationController()
        let viewController = ViewController.instantiate()
        
        viewController.title = "Repositories"
        
        viewController.itemsService = GithubRepositoriesAPIAdapter(api: MainQueueGithubRepositoriesAPI(repositoriesAPI: GithubRepositoriesAPI.shared), select: { (repository) in
            print(repository)
        })
        viewController.skeletonCellProvider = { tableView, indexPath in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellIdentifier) as? RepoTableViewCell else { return UITableViewCell() }
            cell.showSkeletonView()
            return cell
        }
        
        viewController.cellProvider = { tableView, indexPath in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellIdentifier) as? RepoTableViewCell else { return UITableViewCell() }
            let item = viewController.getItem(at: indexPath)
            cell.configureCell(repositoryViewModel: item)
            cell.hideSkeletonView()
            return cell
        }
        
        viewController.onRefresh = { [weak viewController] in
            viewController?.showSkeletonItems()
            viewController?.loadItems()
        }
        
        viewController.loadItems()
        
        viewController.refreshControl.addTarget(viewController, action: #selector(viewController.handleRefresh), for: .valueChanged)
        
        navController.pushViewController(viewController, animated: false)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

