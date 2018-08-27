//
//  NoteDetailViewController.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var highlightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var detailBottomView: DetailBottomView!
    override func viewDidLoad() {
        super.viewDidLoad()

        detailBottomView.noteDetailViewController = self
    }


}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        print("hello")
    }
}
