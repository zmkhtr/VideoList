//
//  SceneDelegate.swift
//  VideoList
//
//  Created by PT.Koanba on 04/09/22.
//

import UIKit
import Video
import VideoUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private var videos = [Video]()
    private lazy var store: VideoURLStore = {
        try! UserDefaultsVideoURLStore(userDefaults: UserDefaults(suiteName: "videoAppSuite"))
    }()
    
    convenience init(videos: [Video] = HardcodeDataProvider.getVideos(), store: VideoURLStore) {
        self.init()
        self.videos = videos
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
     
    func configureWindow() {
        let remoteVideoLoader = HardcodeVideoLoader(videos: self.videos)
        let avVideoLoader = HLSVideoLoader(identifier: "cacheHLSVideoIdentifier", store: store)
        
        
        window?.rootViewController = UINavigationController(rootViewController:     VideoUIComposer.videoComposedWith(
            videoloader: remoteVideoLoader,
            avVideoLoader: avVideoLoader))
        
        window?.makeKeyAndVisible()
    }
}

