//
//  AppDelegate.swift
//  HittaSearch
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // UIWindow
        
        let searchTableNodeController = SearchNodeController()
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = searchTableNodeController
        window?.makeKeyAndVisible()
        
        return true
    }
}

