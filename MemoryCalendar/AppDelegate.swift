//
//  AppDelegate.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/23.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
//        let uiRealm = try! Realm()
//        migration()
//          let realm = try! Realm(configuration: )
          return true
        }

////         Realmマイグレーション処理
//        func migration() {
//          // 次のバージョン（現バージョンが０なので、１をセット）
//            let nextSchemaVersion: UInt64 = 1
//
//          // マイグレーション設定
//          var config = Realm.Configuration(
//            schemaVersion: nextSchemaVersion,
//            migrationBlock: { migration, oldSchemaVersion in
//              if (oldSchemaVersion < nextSchemaVersion) {
//              }
//            })
//            Realm.Configuration.defaultConfiguration = config
//            config.deleteRealmIfMigrationNeeded = true
////            let realm = try! Realm(configuration: config)
//
////        return true
//
//    }

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

