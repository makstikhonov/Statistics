//
//  SceneDelegate.swift
//  Stats
//
//  Created by max on 29.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    let listOfCountriesStorageManager = ListOfCountriesCoreDataManagerImplementation.shared
    let allCountriesStorageManager = AllCountriesCoreDataManagerImplementation.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        listOfCountriesStorageManager.prepare()
        allCountriesStorageManager.prepare()
        
        let statisticViewController = StatisticViewController()
        let onBoardingViewController = OnBoardingModuleAssembly().configureModule()
        
        if userDefaults.bool(forKey: Metrics.userDefaultsKey){
            window?.rootViewController = statisticViewController
        } else {
            window?.rootViewController = onBoardingViewController
        }
        
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
        listOfCountriesStorageManager.saveContext()
        allCountriesStorageManager.saveContext()
    }
}

extension SceneDelegate {
    enum Metrics {
        static let userDefaultsKey: String = "OnboardingComplete"
    }
}
