//
//  PhotosViewController.swift
//  FlickrImageSearchDemo
//
//  Created by Parth on 05/07/21.
//

import UIKit

//TODO: Revisit caching approach and memory consumption (for more performance optimisation)
//TODO: Presentation layer test cases
//TODO: Label truncation does not look ideal and beter UX approach should be thought of
//TODO: Pull to refresh functionality possibility
//TODO: Better solutuon in case of internet connection lost while load more
class PhotosViewController: UIViewController {
    
    let viewModel = PhotosViewModel()

    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 180.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.center = self.view.center
        spinner.backgroundColor = .lightText
        setupViews()
        setupLayouts()
        loadMore()
        view.addSubview(spinner)
        title = viewModel.screenTitle
    }
            
    private func loadMore() {
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.reloadMoreData {
                self.reloadCollectionView()
            }
        }
    }

    private func reloadCollectionView() {
        DispatchQueue.main.async { [self] in
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }

    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell {
            let photo = viewModel.photos[indexPath.row]
            cell.setup(with: photo)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1, viewModel.currentPage <= viewModel.totalPages  {
            loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)

        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 3

        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow

        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}
