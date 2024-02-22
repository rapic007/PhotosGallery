import UIKit
import SnapKit
import SDWebImage

class PhotosCollectionViewCell: UICollectionViewCell {
    
    let defalts = UserDefaults.standard
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static let identifier = "PhotosCollectionViewCell"
    
    private(set) var unsplashPhoto: UnsplashPhoto?
    
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "likeIcon")
        imageView.alpha = 0
        return imageView
    }()
    
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
        addSubview(likeImageView)
        
        photoImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        likeImageView.snp.makeConstraints { make in
            make.trailing.equalTo(photoImageView.snp.trailing).offset(-8)
            make.bottom.equalTo(photoImageView.snp.bottom).offset(-8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            photoImageView.alpha = isSelected ? 0.7 : 1
            likeImageView.alpha = isSelected ? 1 : 0
        }
    }
}
