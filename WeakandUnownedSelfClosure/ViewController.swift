//
//  ViewController.swift
//  WeakandUnownedSelfClosure
//
//  Created by Bhushan  Borse on 04/01/20.
//  Copyright © 2020 Bhushan  Borse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Red View", style: .plain, target: self, action: #selector(showRedView))
    }

   @objc func showRedView()  {
        self.navigationController?.pushViewController(RedViewController(), animated: true)
    }

}

class RedViewController: UITableViewController {
    
    deinit {
        print("Realse all object from memory - No retain cycle of memory leake")
    }
    
    var refreshTableView :((Data?, Error?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .red
        
        /// Example No 1 : Notification center retain cycle with closure
       /* NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "notificationName"), object: nil, queue: .main) { [unowned self] (notification) in
            self.showAlertView()
        }*/
        
        /// Example No 2 : Retain cycle with simple closure
        /*  refreshTableView = { [weak self] (data, error) in
            self?.showAlertView()
         }*/
        
        /// Example No 3 : Retain cycle with class
        Service.shared.fetchData { [weak self] (error) in
            if let err = error {
                print(err)
                return
            }
            
            self?.showAlertView()
        }
            
        
    }
    
    func showAlertView() {
        let alert = UIAlertController(title: "Alert", message: "Realse all object memory if back to main view", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


class Service {
    static let shared = Service()
    func fetchData(complition : @escaping (Error?) -> ()) {
        
        guard let url = URL(string: "https://www.google.com") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (_, _, _) in
            complition(nil)
        }
    }
}
