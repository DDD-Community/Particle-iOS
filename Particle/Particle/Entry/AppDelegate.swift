//
//  AppDelegate.swift
//  Particle
//
//  Created by 이원빈 on 2023/06/19.
//

import UIKit
import Photos

var allPhotos: PHFetchResult<PHAsset>? = nil
var photoCount = Int()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false, selector: nil)]
                allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                photoCount = allPhotos?.count ?? 0
                Console.log("PHPhotoLibrary Success Authrization")
            case .denied, .limited:
                Console.error("PHPhotoLibrary not allowed")
            case .notDetermined:
                Console.error("PHPhotoLibrary notDetermined")
            case .restricted:
                Console.error("PHPhotoLibrary restricted")
            @unknown default:
                Console.error("PHPhotoLibrary Error")
                return
            }
        }
        
        UserDefaults.standard.set(false, forKey: "ShowSwipeGuide")
            
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}
