//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by VenD-Omeir on 10/10/2021.
//

import XCTest
@testable import GithubApp

class GithubAppTests: XCTestCase {
    
    func makeSUT() -> ViewController {
        let viewController = ViewController.instantiate()
        viewController.title = "Repositories"
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
        
        return viewController
    }
    
    func makePassingSUT() -> ViewController {
        let viewController = makeSUT()
        viewController.itemsService = GithubRepositoriesAPIAdapter(api: LocalRepositoriesAPI.shared, select: { (repository) in
           
        })
        viewController.refreshControl.addTarget(viewController, action: #selector(viewController.handleRefresh), for: .valueChanged)
        
        viewController.onRefresh = { [weak viewController] in
            viewController?.showSkeletonItems()
            viewController?.loadItems()
        }
        
        return viewController
    }
    
    func makeFailingSUT() -> ViewController {
        let viewController = makeSUT()
        viewController.itemsService = GithubRepositoriesAPIAdapter(api: FailingLocalRepositoriesAPI(), select: { (repository) in
           
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

        return viewController
    }
    
    func testViewControllerTitle() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.title == "Repositories", "Checking View Controller Title to be Repositories")
    }
    
    func testIfDelegatesAreSetup() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.tableView.delegate, "Check if tableView delegate is not nil")
        XCTAssertNotNil(sut.tableView.dataSource, "Check if tableView datasource is not nil")
    }
    
    func testNumberOfItemsAfterViewLoads() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView.numberOfRows(inSection: 0) == 8, "Checking 8 dummy skeleton cells")
    }
    
    func testNumberOfRowsAfterSystemLoadsData() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        sut.loadItems()
        XCTAssertTrue(sut.repositoryViewModels.count == 10, "Checking for items to be 10")
    }
    
    func testNumberOfRowsAfterSystemIsRefreshed() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.onRefresh, "Checking if onRefresh Method is provided or not")
        sut.onRefresh!()
        XCTAssertTrue(sut.repositoryViewModels.count == 10, "Checking for items to be 10")
    }
    
    func testRepositoryViewModel() {
        let repo = getRepositoryStub()
        let repoViewModel = RepositoryViewModel(respository: repo, darkModeStarImage: "star_white", lightModeStarImage: "star") {
            
        }
        XCTAssertTrue(repoViewModel.title == repo.fullName)
        XCTAssertTrue(repoViewModel.subtitle == repo.name)
        XCTAssertTrue(repoViewModel.description == repo.repositoryDescription)
        XCTAssertTrue(repoViewModel.language == (repo.language ?? ""))
        XCTAssertTrue(repoViewModel.stars == "\(repo.stargazersCount)")
        XCTAssertTrue(repoViewModel.imageURL == repo.owner.avatarURL)
        XCTAssertTrue(repoViewModel.darkModeStarImage == "star_white")
        XCTAssertTrue(repoViewModel.lightModeStarImage == "star")
    }
    
    func testLocalStubData() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        sut.loadItems()
        XCTAssertTrue(sut.repositoryViewModels[0].title == "golang/go", "Testing first object title")
    }
    
    func testIfAnimationViewIsHiddenAfterDataIsLoaded() {
        let sut = makePassingSUT()
        sut.loadViewIfNeeded()
        sut.loadItems()
        XCTAssertTrue(sut.animatedButtonView.isHidden == true, "Check if animation view is hidden after tableView is loaded with data")
    }
    
    func testIfAnimationViewIsVisibleAfterDataIsNotAbleToLoad() {
        let sut = makeFailingSUT()
        sut.loadViewIfNeeded()
        sut.loadItems()
        XCTAssertTrue(sut.animatedButtonView.isHidden == false, "Check if animation view is visible after tableView is not loaded with data")
    }

}


final class LocalRepositoriesAPI: RepositoriesAPI {
    
    static let shared = LocalRepositoriesAPI()
    
    func fetchItems(completion: @escaping (Result<RepositoryListModel, Error>) -> Void) {
        let repository = getLocalRepository()
        let repositories = Array(repeating: repository, count: 10)
        let repositoryListModel = RepositoryListModel(totalCount: 10, incompleteResults: false, items: repositories)
        completion(.success(repositoryListModel))
    }
    
    
    func getLocalRepository() -> Repository {
       return getRepositoryStub()
    }
    
}

final class FailingLocalRepositoriesAPI: RepositoriesAPI {
    
    func fetchItems(completion: @escaping (Result<RepositoryListModel, Error>) -> Void) {
        completion(.failure(NetworkError.dataNotDecodable))
    }
    
}

func getRepositoryStub() -> Repository {
    Repository(id: 23096959, nodeID: "MDEwOlJlcG9zaXRvcnkyMzA5Njk1OQ==", name: "go", fullName: "golang/go", repositoryPrivate: false, owner: Owner(login: "golang", id: 4314092, nodeID: "MDEyOk9yZ2FuaXphdGlvbjQzMTQwOTI=", avatarURL: "https://avatars.githubusercontent.com/u/4314092?v=4", gravatarID: "", url: "https://api.github.com/users/golang", htmlURL: "https://github.com/golang", followersURL: "https://api.github.com/users/golang/followers", followingURL: "https://api.github.com/users/golang/following{/other_user}", gistsURL: "https://api.github.com/users/golang/gists{/gist_id}", starredURL: "https://api.github.com/users/golang/starred{/owner}{/repo}", subscriptionsURL: "https://api.github.com/users/golang/subscriptions", organizationsURL: "https://api.github.com/users/golang/orgs", reposURL: "https://api.github.com/users/golang/repos", eventsURL: "https://api.github.com/users/golang/events{/privacy}", receivedEventsURL: "https://api.github.com/users/golang/received_events", type: "Organization", siteAdmin: false), htmlURL: "https://github.com/golang/go", repositoryDescription: "The Go programming language", fork: false, url: "https://api.github.com/repos/golang/go", forksURL: "https://api.github.com/repos/golang/go/forks", keysURL: "https://api.github.com/repos/golang/go/keys{/key_id}", collaboratorsURL: "https://api.github.com/repos/golang/go/collaborators{/collaborator}", teamsURL: "https://api.github.com/repos/golang/go/teams", hooksURL: "https://api.github.com/repos/golang/go/hooks", issueEventsURL: "https://api.github.com/repos/golang/go/issues/events{/number}", eventsURL: "https://api.github.com/repos/golang/go/events", assigneesURL: "https://api.github.com/repos/golang/go/assignees{/user}", branchesURL: "https://api.github.com/repos/golang/go/branches{/branch}", tagsURL: "https://api.github.com/repos/golang/go/tags", blobsURL: "https://api.github.com/repos/golang/go/git/blobs{/sha}", gitTagsURL: "https://api.github.com/repos/golang/go/git/tags{/sha}", gitRefsURL: "https://api.github.com/repos/golang/go/git/refs{/sha}", treesURL: "https://api.github.com/repos/golang/go/git/trees{/sha}", statusesURL: "https://api.github.com/repos/golang/go/statuses/{sha}", languagesURL: "https://api.github.com/repos/golang/go/languages", stargazersURL: "https://api.github.com/repos/golang/go/stargazers", contributorsURL: "https://api.github.com/repos/golang/go/contributors", subscribersURL: "https://api.github.com/repos/golang/go/subscribers", subscriptionURL: "https://api.github.com/repos/golang/go/subscription", commitsURL: "https://api.github.com/repos/golang/go/commits{/sha}", gitCommitsURL: "https://api.github.com/repos/golang/go/git/commits{/sha}", commentsURL: "https://api.github.com/repos/golang/go/comments{/number}", issueCommentURL: "https://api.github.com/repos/golang/go/issues/comments{/number}", contentsURL: "https://api.github.com/repos/golang/go/contents/{+path}", compareURL: "https://api.github.com/repos/golang/go/compare/{base}...{head}", mergesURL: "https://api.github.com/repos/golang/go/merges", archiveURL: "https://api.github.com/repos/golang/go/{archive_format}{/ref}", downloadsURL: "https://api.github.com/repos/golang/go/downloads", issuesURL: "https://api.github.com/repos/golang/go/issues{/number}", pullsURL: "https://api.github.com/repos/golang/go/pulls{/number}", milestonesURL: "https://api.github.com/repos/golang/go/milestones{/number}", notificationsURL: "https://api.github.com/repos/golang/go/notifications{?since,all,participating}", labelsURL: "https://api.github.com/repos/golang/go/labels{/name}", releasesURL: "https://api.github.com/repos/golang/go/releases{/id}", deploymentsURL: "https://api.github.com/repos/golang/go/deployments", createdAt: "2014-08-19T04:33:40Z", updatedAt: "2021-10-09T19:28:01Z", pushedAt: "2021-10-09T17:34:43Z", gitURL: "git://github.com/golang/go.git", sshURL: "git@github.com:golang/go.git", cloneURL: "https://github.com/golang/go.git", svnURL: "https://github.com/golang/go", homepage: "https://golang.org", size: 276986, stargazersCount: 90690, watchersCount: 90690, language: Optional("Go"), hasIssues: true, hasProjects: true, hasDownloads: true, hasWiki: true, hasPages: false, forksCount: 13377, archived: false, disabled: false, openIssuesCount: 7589, license: License(key: "other", name: "Other", spdxID: "NOASSERTION", nodeID: "MDc6TGljZW5zZTA="), allowForking: true, visibility: "public", forks: 13377, openIssues: 7589, watchers: 90690, defaultBranch: "master", score: 1)
}
