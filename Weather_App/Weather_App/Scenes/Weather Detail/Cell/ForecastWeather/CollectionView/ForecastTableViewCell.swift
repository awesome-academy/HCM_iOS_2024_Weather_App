//
//  ForecastTableViewCell.swift
//  Weather_App
//
//  Created by An Bảo on 31/03/2024.
//

import UIKit
import Reusable

final class ForecastTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
}

extension ForecastTableViewCell {
    private func setupUI() {
        let layout = CustomFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        sectionView.layer.cornerRadius = Constants.cornerRadius
        sectionView.addShadow()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(supplementaryViewType: HeaderCollectionReusableView.self,
                                   ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(cellType: ForecastCollectionViewCell.self)
    }
}

extension ForecastTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forecastCell: ForecastCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return forecastCell
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier,
                                                                                   for: indexPath) as? HeaderCollectionReusableView else {
                fatalError("Could not dequeue HeaderCollectionReusableView")
            }
            headerView.label.text = "Forecast 7 days"
            return headerView
        default:
            fatalError("Unexpected supplementary view kind: \(kind)")
        }
    }
}

extension ForecastTableViewCell: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 10
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height / numberOfItemsPerRow
        return CGSize(width: width, height: height)
    }
}
