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
        setupCollectionView()
        setupNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPhotos()
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
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationItem.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(red: 0.208, green: 0.208, blue: 0.208, alpha: 1)
        lazy var addBarButtomItem: UIBarButtonItem = {
            return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped))
        }()
        

        navigationItem.rightBarButtonItem = addBarButtomItem
    }
    
    private func showPhotos() {
        photos = UserDefaults.standard.get(key: .save, type: [UnsplashPhoto].self) ?? []
        collectionView.reloadData()
    }
    
    @objc func trashBarButtonTapped() {
        let alertController = UIAlertController(title: "", message: "Clear saved Photos?", preferredStyle: .alert)
        let add = UIAlertAction(title: "Yes", style: .default) { (action) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.photos = []
            UserDefaults.standard.set(value: self.photos, key: .save)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "clear"), object: nil)
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
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
