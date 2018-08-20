//
//  TestViewController.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        var text = ""
        for a in 0x1F600...0x1F64F {
            if let b = Unicode.Scalar(a) {
                let c = String(b)
                text.append(c)
            }
            
        }
        label.text = text
    }

}
