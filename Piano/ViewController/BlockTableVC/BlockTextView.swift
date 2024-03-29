//
//  BlockTextView.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 5..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

//class BlockTextView: UITextView {
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        layoutManager.delegate = self
//        textContainerInset = UIEdgeInsets.zero
//        textContainer.lineFragmentPadding = 0
//        inputAssistantItem.leadingBarButtonGroups = []
//        inputAssistantItem.trailingBarButtonGroups = []
//    }
//
//    
//    //TODO: 여기서 해당 지점의 attrText의 attr에 링크가 있는 지 판단하는게 옳은것인가?
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        guard let point = touches.first?.location(in: self) else { return }
//        let index = layoutManager.glyphIndex(for: point, in: textContainer)
//        
//        if index < 0 {
//            print("에러!!! textView에서 touchesEnd에 음수이면 안되는 index가 입력되었다!")
//        }
//        
//        if attributedText.length != 0 && attributedText.attribute(.link, at: index, effectiveRange: nil) != nil {
//            return
//        } else {
//            selectedRange.location = index + 1
//            isEditable = true
//            becomeFirstResponder()
//        }
//    }
//    
//    override func paste(_ sender: Any?) {
//        guard let cell = superview?.superview as? TextBlockTableViewCell,
//            let block = cell.data as? Block,
//            let controller = cell.controller else { return }
//        
//        let pasteboardManager = PasteboardManager()
//        pasteboardManager.pasteParagraphs(currentBlock: block, in: controller)
//    }
//
//}
//
//extension BlockTextView: NSLayoutManagerDelegate {
//    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        return 6
//    }
//}
//
//
////MARK: For Block
//extension BlockTextView {
//    internal var block: Block? {
//        return (superview?.superview as? TextBlockTableViewCell)?.data as? Block
//    }
//    
//    
//
//}
