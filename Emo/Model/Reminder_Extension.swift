//
//  Reminder_Extension.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

extension Reminder {
    internal func detectEmojies() {
        
        if let content = self.content {
            Set(content.emojis).forEach {
                add(emoji: $0)
            }
        }
    }
    
    private func add(emoji: String) {
        guard let managedContext = managedObjectContext else { return }
        let request:NSFetchRequest<Emoji> = Emoji.fetchRequest()
        
        do {
            request.predicate = NSPredicate(format: "%K == %lld", #keyPath(Emoji.emojiHash), emoji.hashValue)
            let results = try managedContext.fetch(request)
            // 새로운 이모지일 경우
            if results.count == 0 {
                let emoji = Emoji(context: managedContext)
                emoji.emojiHash = Int64(emoji.hashValue)
                self.addToEmojiCollection(emoji)
            } else {
                // 이미 있는 이모지일 경우
                results.forEach {
                    self.addToEmojiCollection($0)
                }
            }
        } catch {
            // TODO: 에러처리 하기
            fatalError()
        }
    }
}
