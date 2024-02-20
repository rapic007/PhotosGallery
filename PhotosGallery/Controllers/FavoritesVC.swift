//
//  FavouritesViewController.swift
//  PhotosGallery
//
//  Created by Влад  on 1.02.24.
//

import UIKit

class FavoritesVC: UIViewController {
    
    var photos: [UnsplashPhoto] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photos = UserDefaults.standard.get(key: "selectedPhotos", type: [UnsplashPhoto].self) ?? []
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension FavoritesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.identifier,
                                                            for: indexPath) as? FavoritesCollectionViewCell else {
            fatalError("failed to dequeue CollectionViewCell")
        }
        
        let unsplashPhoto = self.photos[indexPath.row]
        cell.configure(with: unsplashPhoto)
        
        return cell
    }
}

extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width/3)-1.34
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
        
    }
}
