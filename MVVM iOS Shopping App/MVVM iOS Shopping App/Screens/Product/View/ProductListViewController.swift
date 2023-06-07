//
//  ProductListViewController.swift
//  MVVM iOS Shopping App
//
//  Created by Cumulations on 07/06/23.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var productTabelView : UITableView!
    
    private var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
    }
}

extension ProductListViewController {
    func configuration(){
        productTabelView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initViewModel()
        observeEvent()
    }
    
    func initViewModel(){
        viewModel.fetchProducts()
    }
    
    // Data Binding event observe
    func observeEvent(){
        viewModel.eventHandler = { [weak self] event in
            guard let self else {return}
            
            switch event {
                
            case .loading:
                // we can show indicator here
                break
            case .stopLoading:
                // we can stop indicator here
                break
            case .dataLoading:
                DispatchQueue.main.async {
                    // as api fetching is going in BG also for UI works well in main queue
                    self.productTabelView.reloadData()
                }
            case .error(let error):
                print(error!)
            }
            
        }
    }
}


extension ProductListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell
        else{
            return UITableViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.product = product
        return cell
    }
}
