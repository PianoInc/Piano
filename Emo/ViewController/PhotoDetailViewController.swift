//
//  PhotoDetailViewController.swift
//  Emo
//
//  Created by JangDoRi on 2018. 8. 23..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var headerView: PhotoDetailHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var image: UIImage?
    
    private var data: [String] {
        return (1...100).map {String($0)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imageView.image = image
        headerView.scrollToFit = {self.tableView.setContentOffset(.zero, animated: true)}
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.tableView.performBatchUpdates(nil)
        })
    }
    
}

extension PhotoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoDetailTableViewCell") as! PhotoDetailTableViewCell
        cell.label.text = data[indexPath.row] + "번째 댓글입니다."
        return cell
    }
    
}
