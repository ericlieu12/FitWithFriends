//
//  AppDelegate.swift
//  FitWithFriends
//
//  Created by user on 8/13/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import CoreMotion
import Hero
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   lazy var persistentContainer: NSPersistentContainer = {

       let container = NSPersistentContainer(name: "friendsimages")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error {

               fatalError("Unresolved error, \((error as NSError).userInfo)")
           }
       })
       return container
   }()
    var window: UIWindow?
    let pedometer = CMPedometer()
private var authListener: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     Hero.shared.containerColor = .white
        FirebaseApp.configure()
        registerForPushNotifications()
        
        return true
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       

      
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in

                              if let user = user {
                             
                                      if CMPedometer.isStepCountingAvailable() {
                                                 let calendar = Calendar.current
                                        self.pedometer.queryPedometerData(from: calendar.startOfDay(for: Date()), to: Date()) { (data, error) in
                                                    let x = Int(data!.numberOfSteps)
                                                     let db = Firestore.firestore()
                                                     db.collection("users").document(user.uid).setData(["asshat" : x])
                                                     completionHandler(.newData)
print("SDS")
                                                 }
                                             }
                                  completionHandler(.newData)
                                
                              } else {
                               
                                 completionHandler(.newData)
                                
                }
                          }
        
        // Inform the system after the background operation is completed.
        
    }
   func registerForPushNotifications() {
    UNUserNotificationCenter.current()
       .requestAuthorization(options: [.alert, .sound, .badge]) {
         [weak self] granted, error in
           
         print("Permission granted: \(granted)")
         guard granted else { return }
         self?.getNotificationSettings()
     }
     }
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  // Replace this implementation with code to handle the error appropriately.
                  // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }

   }
    


