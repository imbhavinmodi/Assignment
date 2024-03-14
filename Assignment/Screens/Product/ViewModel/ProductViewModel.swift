//
//  ProductViewModel.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import Foundation

final class ProductViewModel {

    // MARK: - Variables
    var allProducts: [Product] = []
    
    var filteredProducts: [Product] = []

    var eventHandler: ((_ event: Event) -> Void)?

    func fetchProducts() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: [Product].self,
            type: ProductEndPoint.products) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let allProducts):
                    self.allProducts = allProducts
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }

    public func updateSearchController(searchBarText: String?) {
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else {  return }

            self.filteredProducts = self.allProducts.filter({ $0.title.lowercased().contains(searchText) })
        }
    }
}

extension ProductViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
