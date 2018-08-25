//
//  PhotoDetailHeaderView.swift
//  Emo
//
//  Created by JangDoRi on 2018. 8. 23..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class PhotoDetailHeaderView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var scrollToFit: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = 1
        }
    }
    
}

extension PhotoDetailHeaderView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollToFit?()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageToFit(with: scrollView.zoomScale)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageToFit()
    }
    
    private func imageToFit(with zoom: CGFloat = 1) {
        let width = scrollView.bounds.width * zoom
        let height = scrollView.bounds.height * zoom
        let x = scrollView.bounds.width / 2 - width / 2
        let y = scrollView.bounds.height / 2 - height / 2
        imageView.frame = CGRect(x: (x <= 0) ? 0 : x, y: (y <= 0) ? 0 : y, width: width, height: height)
    }
    
}
