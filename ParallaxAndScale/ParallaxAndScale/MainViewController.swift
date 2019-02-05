//
//  MainViewController.swift
//  ParallaxAndScale
//
//  Created by Dhaval Patel on 8/31/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Constants
    struct Constants {
        static fileprivate let headerHeight: CGFloat = 210
    }

    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var headerContainerView: UIView!
    private var headerImageView: UIImageView!
    private var headerTopConstraint: NSLayoutConstraint!
    private var headerHeightConstraint: NSLayoutConstraint!
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        scrollView = createScrollView()
        headerContainerView = createHeaderContainerView()
        headerImageView = createHeaderImageView()
        createCollectionView()

        collectionView.register(UINib.init(nibName: "cell", bundle: nil), forCellWithReuseIdentifier: "cell")

        headerContainerView.addSubview(headerImageView)
        scrollView.addSubview(headerContainerView)
        scrollView.addSubview(collectionView)
        view.addSubview(scrollView)

        arrangeConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let contentSizeHeight = UIScreen.main.bounds.size.height + 210
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: contentSizeHeight)
    }
}

private extension MainViewController {
    func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }

    func createHeaderContainerView() -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func createHeaderImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        if let image = UIImage(named: "Coffee") {
            imageView.image = image
        }
        imageView.clipsToBounds = true
        return imageView
    }

    func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        let titleFont = UIFont.preferredFont(forTextStyle: .title1)
        if let boldDescriptor = titleFont.fontDescriptor.withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: boldDescriptor, size: 0)
        } else {
            label.font = titleFont
        }
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.text = "Your content here"
        return label
    }

    func createCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 210, width: UIScreen.main.bounds.width, height: 1010), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func arrangeConstraints() {
        let scrollViewConstraints: [NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)

        headerTopConstraint = headerContainerView.topAnchor.constraint(equalTo: view.topAnchor)
        headerHeightConstraint = headerContainerView.heightAnchor.constraint(equalToConstant: 210)
        let headerContainerViewConstraints: [NSLayoutConstraint] = [
            headerTopConstraint,
            headerContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            headerHeightConstraint
        ]
        NSLayoutConstraint.activate(headerContainerViewConstraints)

        let headerImageViewConstraints: [NSLayoutConstraint] = [
            headerImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(headerImageViewConstraints)

        let labelConstraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            collectionView.heightAnchor.constraint(equalToConstant: 1010)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
}

extension MainViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            headerHeightConstraint?.constant = Constants.headerHeight - scrollView.contentOffset.y
        } else {
            let parallaxFactor: CGFloat = 0.25
            let offsetY = scrollView.contentOffset.y * parallaxFactor
            let minOffsetY: CGFloat = 8.0
            let availableOffset = min(offsetY, minOffsetY)
            let contentRectOffsetY = availableOffset / Constants.headerHeight
            headerTopConstraint?.constant = view.frame.origin.y
            headerHeightConstraint?.constant = Constants.headerHeight - scrollView.contentOffset.y
            headerImageView.layer.contentsRect = CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cell
        collCell.lblName.text = "\(indexPath.row)"
        return collCell
    }
    
    
}
