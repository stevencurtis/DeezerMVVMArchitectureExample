//
//  SceneDelegate.swift
//  DeezerProject
//
//  Created by Steven Curtis on 26/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var browseFlow: BrowseFlow?
    var searchFlow: SearchFlow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let tabBar = MusicTabBar()
        let browseNavigationController = UINavigationController()
        browseNavigationController.navigationBar.prefersLargeTitles = true

        let searchNavigationController = UINavigationController()
        searchNavigationController.navigationBar.prefersLargeTitles = true

        browseNavigationController.tabBarItem.image = UIImage(systemName: "square.grid.2x2.fill")
        browseNavigationController.tabBarItem.title = "Favorites"

        browseFlow = BrowseFlow(
            router: FlowRoutingService(
                navigationController: browseNavigationController,
                tabController: tabBar
            )
        )
        tabBar.addChild(browseNavigationController)

        searchNavigationController.navigationController?.navigationBar.prefersLargeTitles = true
        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchNavigationController.tabBarItem.title = "Search"

        searchFlow = SearchFlow(
            router: FlowRoutingService(navigationController: searchNavigationController, tabController: tabBar)
        )

        tabBar.addChild(searchNavigationController)

        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()

        browseFlow?.runFlow()
        searchFlow?.runFlow()
    }
    // swiftlint:disable:all
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later,
        // as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
