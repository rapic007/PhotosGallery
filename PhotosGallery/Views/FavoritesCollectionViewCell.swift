import UIKit
import SnapKit
import SDWebImage

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static let identifier = "FavoritesCollectionViewCell"
    
    private(set) var unsplashPhoto: UnsplashPhoto?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    

    public func configure(with unsplashPhoto: UnsplashPhoto) {
        let photoUrl = unsplashPhoto.urls["small"]
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        
        photoImageView.sd_setImage(with: url)
    }
        
    func setupUI() {
        self.backgroundColor = .systemBackground
        
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
}
