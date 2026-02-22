//
//  SceneDelegate.swift
//  Shakti
//
//  Created by Hitesh Kumar on 21/02/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Build the entire UI programmatically — no storyboard needed.
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            makeTab(HomeViewController(),  title: "Home",  systemImage: "house"),
            makeTab(ViewController(),      title: "Input", systemImage: "text.cursor"),
            makeTab(WebViewController(),   title: "Web",   systemImage: "globe")
        ]

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        // Handle deep link on cold start
        if let urlContext = connectionOptions.urlContexts.first {
            handleIncomingDeepLink(urlContext.url)
        }
    }

    // Called when the app is already running and receives a shakti:// URL
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            handleIncomingDeepLink(urlContext.url)
        }
    }

    // MARK: - Helpers

    private func makeTab(_ vc: UIViewController, title: String, systemImage: String) -> UIViewController {
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: systemImage), tag: 0)
        return vc
    }

    // MARK: - Deep Link Routing

    /// Routes  shakti://web?url=<encoded-url>  to the Web tab.
    private func handleIncomingDeepLink(_ url: URL) {
        guard url.scheme?.lowercased() == "shakti",
              url.host?.lowercased() == "web",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let urlValue = components.queryItems?.first(where: { $0.name == "url" })?.value,
              let targetURL = URL(string: urlValue)
        else { return }

        guard let tabBarController = window?.rootViewController as? UITabBarController else { return }
        tabBarController.selectedIndex = 2
        if let webVC = tabBarController.viewControllers?[2] as? WebViewController {
            webVC.loadURL(targetURL)
        }
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

