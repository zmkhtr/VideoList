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
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: VideoURLStore = {
        try! UserDefaultsVideoURLStore(userDefaults: UserDefaults(suiteName: "videoAppSuite"))
    }()
    convenience init(httpClient: HTTPClient, store: VideoURLStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
     
    func configureWindow() {
        let remoteURL = URL(string: "https://api-main.kipaskipas.com/api/v1/public/feeds/channels?code=tiktok&page=0&size=20")!

        let remoteVideoLoader = RemoteVideoLoader(url: remoteURL, client: httpClient)
        let avVideoLoader = HLSVideoLoader(identifier: "cacheHLSVideoIdentifier", store: store)
        
        
        window?.rootViewController = UINavigationController(rootViewController:     VideoUIComposer.videoComposedWith(
            videoloader: remoteVideoLoader,
            avVideoLoader: avVideoLoader))
        
        window?.makeKeyAndVisible()
    }
}

