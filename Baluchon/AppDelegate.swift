//
//  AppDelegate.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 17/01/2022.
//

import UIKit

func delay(_ seconds: TimeInterval, completion: @escaping () -> Void ){
  DispatchQueue.main.asyncAfter(deadline: .now()+seconds,
                                execute: completion)
}

func subscribeToMainThread(_ handler: @escaping () -> Void){
  DispatchQueue.main.async {
    handler()
  }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  let locationManger = UserLocationManager()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    locationManger.startUpdatingLocation()
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

