//
//  CreateView.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 14..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class BottomView: UIView {
    
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet var contextInputView: ContextInputView!
    @IBOutlet var emojiInputView: UICollectionView!
    /** 텍스트를 입력받는 뷰, 텍스트가 변화할 때마다 모델이 업데이트된다(역반응) */
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var emojiSearchButton: UIButton!
    
    /** 텍스트뷰에서 검출된 것 중에, 캘린더, 연락처, 미리알림으로 등록할 만한 요소가 있다면 표시 */
    @IBOutlet weak var tableView: UITableView!
    
    /** 키보드에 따른 위치 변화를 위한 컨스트레인트 */
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    /** 유저 인터렉션에 따라 자연스럽게 바텀뷰가 내려가게 하기 위한 옵저빙 토큰 */
    internal var keyboardToken: NSKeyValueObservation?
    internal var keyboardHeight: CGFloat?
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerKeyboardNotification()
    }
    
    deinit {
        unRegisterKeyboardNotification()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }

}

extension BottomView {
    private func setup() {
        let isEmpty = textView.text.count == 0
        writeButton.isEnabled = !isEmpty
        
        DispatchQueue.main.async { [weak self] in
            self?.textView.becomeFirstResponder()
        }
    }

}

extension BottomView {
}
