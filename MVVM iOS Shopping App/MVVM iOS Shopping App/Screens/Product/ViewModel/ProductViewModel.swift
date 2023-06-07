//
//  ProductViewModel.swift
//  MVVM iOS Shopping App
//
//  Created by Cumulations on 07/06/23.
//

import Foundation

final class ProductViewModel {
    
    var products : [Product] = []
    
    var eventHandler : ((_ event : Event) -> Void)?
    
    func fetchProducts(){
        APIManager.shared.fetchProducts { response in
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products) :
                self.products = products
                self.eventHandler?(.dataLoading)
            case .failure(let error) :
                self.eventHandler?(.error(error))
            }
        }
    }
}

extension ProductViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoading
        case error(Error?)
    }
}
