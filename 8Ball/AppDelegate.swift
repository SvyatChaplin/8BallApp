//
//  AppDelegate.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarController = UITabBarController()
        let storageManager = StorageManagerService()
        let networkingManager = NetworkingManagerService()
        let secureStorage = SecureStorageService()
        let mainScreenModel = MainScreenModel(storageManager: storageManager,
                                              networkingManager: networkingManager, secureStorage: secureStorage)
        let mainScreenViewModel = MainScreenViewModel(mainScreenModel: mainScreenModel)
        let mainScreenViewController = MainScreenViewController(mainScreenViewModel: mainScreenViewModel)
        let historyModel = HistoryModel(storageManager: storageManager)
        let historyViewModel = HistoryViewModel(historyModel: historyModel)
        let historyViewController = HistoryViewController(historyViewModel: historyViewModel)

        tabBarController.viewControllers = [mainScreenViewController,
                                            historyViewController]
        mainScreenViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        historyViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.tintColor = ColorName.darkPurple.color

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()

        return true
    }
}
