//
//  TabBarControlller.swift
//  PhotosGallery
//
//  Created by Влад  on 1.02.24.
//

import UIKit

class TabBarControlller: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let photos = self.createNavController(title: "Photos",
                                              image: UIImage(named: "photosIcon"),
                                              vc: PhotosVC())
        let favorites = self.createNavController(title: "Favorites",
                                                  image: UIImage(named: "favoritesIcon"),
                                                  vc: FavoritesVC())
        
        self.setViewControllers([photos, favorites], animated: true)
        
        tabBar.tintColor = UIColor(red: 0.941, green: 0.667, blue: 0.055, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 0.208, green: 0.208, blue: 0.208, alpha: 1)
    }
    
    private func createNavController(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        let navBarAppearance = UITabBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 15)!]
        
        tabBar.standardAppearance = navBarAppearance
        
        return navController
    }
}
