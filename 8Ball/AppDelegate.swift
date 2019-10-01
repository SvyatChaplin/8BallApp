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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainScreenViewController = storyboard.instantiateViewController(withIdentifier:
            "MainScreenViewController") as? MainScreenViewController,
            let settingScreenViewController = storyboard.instantiateViewController(withIdentifier:
                "SettingScreenViewController") as? SettingScreenViewController,
            let tabBarController = storyboard.instantiateViewController(withIdentifier:
                "InitialController") as? UITabBarController else {
                return true
        }
        let answerProvider = AnswerProvider()
        let networkingManager = NetworkingManager()
        let settingScreenModel = SettingScreenModel(answerProvider: answerProvider)
        let mainScreenModel = MainScreenModel(answerProvider: answerProvider, networkingManager: networkingManager)
        settingScreenViewController.settingScreenViewModel = SettingScreenViewModel(settingScreenModel: settingScreenModel)
        mainScreenViewController.mainScreenViewModel = MainScreenViewModel(mainScreenModel: mainScreenModel)

        tabBarController.viewControllers = [mainScreenViewController, settingScreenViewController]

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()

        return true
    }
}
