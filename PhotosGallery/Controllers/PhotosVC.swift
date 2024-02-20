//
//  ViewController.swift
//  PhotosGallery
//
//  Created by Влад  on 1.02.24.
//

import UIKit
import SnapKit

class PhotosVC: UIViewController {
    
    private var photos: [UnsplashPhoto] = []
    private var savedPhoto: [UnsplashPhoto] = []
    
    var page = 1
    
    var networkDataFetcher = NetworkDataFetcher(networkService: NetworkService())
    var searchTherm = ""
    
    private let refreshControl = UIRefreshControl()
    
    private var timer: Timer?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
        setupSavedPhoto()
    }
    
    private func setupSavedPhoto() {
        savedPhoto = UserDefaults.standard.get(key: "selectedPhotos", type: [UnsplashPhoto].self) ?? []
    }
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        let tittleLabel = UILabel()
        tittleLabel.text = "Photos"
        tittleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tittleLabel.textColor = UIColor(red: 0.208, green: 0.208, blue: 0.208, alpha: 1)
        
        lazy var addBarButtomItem: UIBarButtonItem = {
            return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
        }()
        

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: tittleLabel)
        navigationItem.rightBarButtonItem = addBarButtomItem
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.208, green: 0.208, blue: 0.208, alpha: 1)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationItem.standardAppearance = appearance
    }
    
    private func setupSearchController() {
        let seacrhController = UISearchController(searchResultsController: nil)
        
        seacrhController.searchResultsUpdater = self
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = seacrhController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
        
    }
    
    private func clearSecelectedItems() {
        self.collectionView.selectItem(at: nil, animated: false, scrollPosition: .top )
    }
    
    @objc
    private func addBarButtonTapped() {
       guard let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosss, indexPath) -> [UnsplashPhoto] in
            var mutablePhotos = photosss
            let photo = photos[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
       }) else { return }
        let alertController = UIAlertController(title: "", message: "\(selectedPhotos.count) Photos will be add to favorites ", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            for photo in selectedPhotos {
                self.savedPhoto.insert(photo, at: 0)
            }
            UserDefaults.standard.set(value: self.savedPhoto, key: "selectedPhotos")
            self.clearSecelectedItems()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc
    private func refresh() {
        self.page += 1
        self.networkDataFetcher.fetchImages(searchTerm: self.searchTherm, page: self.page) { [weak self](searchResults) in
            guard let fetchedPhotos = searchResults else { return }
            self?.photos = fetchedPhotos.results
        }
        
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension PhotosVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        self.searchTherm = searchTerm
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchTerm, page: self.page) { [weak self](searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
        if searchTerm.isEmpty {
            self.page = 1
        }
    }
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("failed to dequeue CollectionViewCell")
        }
        
        let unsplashPhoto = self.photos[indexPath.row]
        cell.configure(with: unsplashPhoto)
        return cell
    }
}

extension PhotosVC: UICollectionViewDelegateFlowLayout {
    
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

extension UserDefaults {
    
    
    func set <T: Encodable>(value: T, key: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func get <T:Decodable>(key: String, type: T.Type ) -> T? {
     let decoder = JSONDecoder()
        
        guard let data = data(forKey: key),
              let object = try? decoder.decode(type, from: data)
        else { return nil }
        return object
    }
}
