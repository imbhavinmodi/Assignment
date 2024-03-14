//
//  ProductListViewController.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ProductListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productTableView: ContentSizedTableView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var carouselView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var stackView: UIStackView!

    // MARK: - Variables
    private let viewModel = ProductViewModel()
    private var isSearchText = false
    private var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
        }
    }
    
    private var arrSlider = ["ic_onboarding_1","ic_onboarding_2","ic_onboarding_3","ic_onboarding_4","ic_onboarding_5"]


    fileprivate var pageSize: CGSize {
        guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout else {
            return CGSize.zero
        }

        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        setupSearchController()
        tableviewViewSetup()

        view.bringSubviewToFront(searchView)
        configuration()
    }

    // MARK: - UI Setup
    private func tableviewViewSetup() {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.bounds.size.height = CGFloat(200 * viewModel.allProducts.count)
    }
    
    private func setupSearchController() {
        searchText.endEditing(true)
        searchText.delegate = self
    }

    private func collectionViewSetup() {
        pageControl.numberOfPages = arrSlider.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true

        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 100.0, height: collectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 0.8
        floawLayout.sideItemAlpha = 0.8
        floawLayout.spacingMode = .fixed(spacing: 5.0)
        collectionView.collectionViewLayout = floawLayout
    }
}

extension ProductListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl(for: scrollView)
        handleSearchViewSticking(for: scrollView)
    }

    private func updatePageControl(for scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

    private func handleSearchViewSticking(for scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let searchViewHeight = searchView.bounds.height
        let threshold = carouselView.frame.maxY - searchViewHeight

        if offsetY >= threshold {
            let diff = offsetY - threshold
            var frame = searchView.frame
            frame.origin.y = carouselView.frame.maxY - searchViewHeight + diff
            searchView.frame = frame

            view.bringSubviewToFront(searchView)
            view.sendSubviewToBack(productTableView)
            productTableView.layer.zPosition = -500
        } else {
            var frame = searchView.frame
            frame.origin.y = carouselView.frame.maxY
            searchView.frame = frame

            view.bringSubviewToFront(productTableView)
        }
    }
}

extension ProductListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        isSearchText = true
        viewModel.updateSearchController(searchBarText: newText)
        DispatchQueue.main.async {
            self.productTableView.reloadData()
        }
        return true
    }
}

extension ProductListViewController {
    func configuration() {
        isSearchText = false
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        viewModel.fetchProducts()
    }

    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                print("Product loading....")
            case .stopLoading:
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSlider.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.image.image = UIImage(named: arrSlider[indexPath.row])
        return cell
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchText ? viewModel.filteredProducts.count : viewModel.allProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
            return UITableViewCell()
        }
        let product = isSearchText ? viewModel.filteredProducts[indexPath.row] : viewModel.allProducts[indexPath.row]
        cell.product = product
        return cell
    }
}
