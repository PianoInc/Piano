//
//  MainCollectionVC_BottomViewDelegate.swift
//  Emo
//
//  Created by hoemoon on 21/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import Foundation
import CoreData

extension MainCollectionViewController: BottomViewDelegate {
    func didTapWriteButton(text: String) {
        guard text.count > 0 else { return }
        let note = Note(context: managedContext)
        note.content = text
        note.createdDate = Date()
        note.modifiedDate = Date()
        detectEmojies(in: note)
        saveContext()
    }

    private func detectEmojies(in note: Note) {
        guard let text = note.content else { return }
        let request:NSFetchRequest<Emoji> = Emoji.fetchRequest()
        Set(text.emojis).forEach {
            request.predicate = NSPredicate(format: "%K == %lld", #keyPath(Emoji.emojiHash), $0.hashValue)
            do {
                let results = try managedContext.fetch(request)
                // 새로운 이모지일 경우
                if results.count == 0 {
                    let emoji = Emoji(context: managedContext)
                    emoji.emojiHash = Int64($0.hashValue)
                    note.addToEmojies(emoji)
                } else {
                    // 이미 있는 이모지일 경우
                    results.forEach {
                        note.addToEmojies($0)
                    }
                }
            } catch {
                // TODO: 에러처리 하기
                fatalError()
            }
        }
    }
}
