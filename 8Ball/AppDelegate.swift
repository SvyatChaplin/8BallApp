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

        let mainScreenViewController = MainScreenViewController()
        let settingScreenViewController = SettingScreenViewController()
        let tabBarController = UITabBarController()
        let answerProvider = AnswerProviderService()
        let networkingManager = NetworkingManagerService()
        let settingScreenModel = SettingScreenModel(answerProvider: answerProvider)
        let mainScreenModel = MainScreenModel(answerProvider: answerProvider, networkingManager: networkingManager)
        settingScreenViewController.settingScreenViewModel =
            SettingScreenViewModel(settingScreenModel: settingScreenModel)
        mainScreenViewController.mainScreenViewModel =
            MainScreenViewModel(mainScreenModel: mainScreenModel)
        // Настроим таб бар
        tabBarController.viewControllers = [mainScreenViewController, settingScreenViewController]
        mainScreenViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        settingScreenViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.06855161488, green: 0.1916376352, blue: 0.5435847044, alpha: 1)

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()

        return true
    }
}
