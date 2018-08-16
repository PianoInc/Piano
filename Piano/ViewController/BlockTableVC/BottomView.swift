//
//  BottomView.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 14..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class BottomView: UIView {
    //TODO: 히든을 풀 때 감각적인 애니메이션 주기
    
    /** 테마(일기, 가계부 등)의 옵션을 키보드 인풋뷰에서 보여주어 테마를 변경할 수 있음,일반 메모, 일기, 가계부 */
    @IBOutlet weak var changeThemeButton: UIButton!
    
    /** 텍스트를 입력받는 뷰, 텍스트가 변화할 때마다 모델이 업데이트된다(역반응) */
    @IBOutlet weak var textView: GrowingTextView!
    
    /** 텍스트뷰에서 검출된 것 중에, 캘린더, 연락처, 미리알림으로 등록할 만한 요소가 있다면 표시 */
    @IBOutlet weak var tableView: UITableView!
    
    /** 키보드에 따른 위치 변화를 위한 컨스트레인트 */
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    /** 유저 인터렉션에 따라 자연스럽게 바텀뷰가 내려가게 하기 위한 옵저빙 토큰 */
    internal var keyboardToken: NSKeyValueObservation?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerKeyboardNotification()
    }
    
    deinit {
        unRegisterKeyboardNotification()
    }

}

extension BottomView {
    @IBAction func tapChangeTheme(_ sender: Any) {
        print("tapp")
    }
    
    @IBAction func tapSharp(_ sender: Any) {
        
    }
    
    @IBAction func tapWrite(_ sender: Any) {
        
    }
}

extension BottomView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    

    
}

extension BottomView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension BottomView: UITableViewDelegate {
    
}

extension BottomView {
    internal func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    internal func unRegisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardToken?.invalidate()
        keyboardToken = nil
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let kbHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            else { return }
        
        bottomConstraint.constant = kbHeight
        superview?.layoutIfNeeded()
        
        keyboardToken = UIApplication.shared.windows[1].subviews.first?.subviews.first?.layer.observe(\.position, changeHandler: { [weak self](layer, change) in
            guard let `self` = self,
                let superView = self.superview else { return }
            
            self.bottomConstraint.constant = max(superView.bounds.height - layer.frame.origin.y, 0)
            superView.layoutIfNeeded()
        })
        
    }
}
