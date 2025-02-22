//
//  AppDelegate.swift
//  ShihErCoffee
//
//  Created by Lin Hill on 2025/2/22.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //在back4app AppSetting > Security & Keys
        
        let back4appServerUrl = "https://parseapi.back4app.com"
        
// CAFE_DEBUG
//        let back4appAppId = "goSJOT0KjJ8MRROMLWTeUYiBLjjeuMYfGOwDne9Q"
//        let clientKey = "eZNQth0fpi7hYNyGAgpWAj5XIOtiVrNmlNa7f1CZ"
// release
        let back4appAppId = "zlmUu7lK63vKs0moYJedNzfvqlYo7zdLYzArs2Ss"
        let clientKey = "rKk9z91dzIdzmYW32NzlJ8yVoLd4Cgkg5U2rg0BX"
        
        let config = ParseClientConfiguration {
            $0.applicationId = back4appAppId
            $0.clientKey = clientKey
            $0.server = back4appServerUrl
            $0.networkRetryAttempts = 0
        }
        
        Parse.initialize(with: config)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

