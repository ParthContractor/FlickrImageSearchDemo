//
//  PhotoCell.swift
//  FlickrImageSearchDemo
//
//  Created by Parth on 06/07/21.
//

import UIKit
import FlickrAPIClient

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class PhotoCell: UICollectionViewCell {

    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0

        // MARK: profileImageView layout constants
        static let imageHeight: CGFloat = 120.0

        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 4.0
        static let horizontalPadding: CGFloat = 8.0
        static let profileDescriptionVerticalPadding: CGFloat = 2.0
    }

    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()

    let photoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(photoImageView)
        contentView.addSubview(photoLabel)
    }

    private func setupLayouts() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `photoImageView`
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for `usernameLabel`
        NSLayoutConstraint.activate([
            photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            photoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            photoLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding),
            photoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.profileDescriptionVerticalPadding)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with photo: Photo) {
        if let url = photo.photoUrl {
            self.setImageFromUrl(imageURL: url)
        }
        photoLabel.text = photo.title
    }
    
    func setImageFromUrl(imageURL :URL) {
       URLSession.shared.dataTask( with: imageURL, completionHandler: {
          (data, response, error) -> Void in
          DispatchQueue.main.async {
             if let data = data {
                self.photoImageView.image = UIImage(data: data)
             }
          }
       }).resume()
    }

}


extension PhotoCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

