//
//  SceneDelegate.swift
//  RepoDiscovery
//
//  Created by Doğukan Sakin on 17.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        // MARK: View Models

        let discoveryViewModel = DiscoveryViewModel()
        let bookmarkViewModel = BookmarkViewModel()
        discoveryViewModel.bookmarkViewModel = bookmarkViewModel

        // MARK: Discovery

        let discoveryViewController = DiscoveryViewController(discoveryViewModel: discoveryViewModel)
        let discoveryNavigation = UINavigationController(rootViewController: discoveryViewController)
        discoveryNavigation.tabBarItem = UITabBarItem(title: NSLocalizedString("discovery", comment: ""), image: UIImage(systemName: "magnifyingglass"), tag: 0)

        // MARK: Bookmarks

        let bookmarksViewController = BookmarksViewController(bookmarksViewModel: bookmarkViewModel)
        let bookmarksNavigation = UINavigationController(rootViewController: bookmarksViewController)
        bookmarksNavigation.tabBarItem = UITabBarItem(title: NSLocalizedString("bookmarks", comment: ""), image: UIImage(systemName: "bookmark"), tag: 1)

        // MARK: Tab Bar

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [discoveryNavigation, bookmarksNavigation]

        // Root
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
