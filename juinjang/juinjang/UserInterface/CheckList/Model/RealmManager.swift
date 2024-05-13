//
//  RealmManager.swift
//  juinjang
//
//  Created by 임수진 on 5/12/24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    let realm: Realm

    private init() {
        // Realm 인스턴스 생성
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    // 체크리스트 항목의 답변값 저장
    func saveChecklistItem(imjangId: Int, questionId: Int, answer: String, isSelected: Bool) {
        // 이미 해당 questionId에 대한 값이 존재하는지 확인
        if let existingItem = realm.objects(CheckListAnswer.self).filter("imjangId == %@ AND questionId == %@", imjangId, questionId).first {
            // 이미 값이 존재하면 해당 값을 업데이트
            do {
                try realm.write {
                    existingItem.answer = answer
                    existingItem.isSelected = isSelected
                    print("업데이트")
                }
            } catch {
                print("Failed to update checklist item: \(error.localizedDescription)")
            }
        } else {
            // 값이 존재하지 않으면 새로운 값으로 추가
            let checkListAnswer = CheckListAnswer()
            checkListAnswer.imjangId = imjangId
            checkListAnswer.questionId = questionId
            checkListAnswer.answer = answer
            checkListAnswer.isSelected = isSelected
            
            // Realm에 저장
            do {
                try realm.write {
                    realm.add(checkListAnswer)
                    print("저장")
                }
            } catch {
                print("Failed to save checklist item: \(error.localizedDescription)")
            }
        }
    }


    // 특정 임장 ID와 질문 ID에 대한 체크리스트 항목의 답변값 조회
    func getChecklistItem(imjangId: Int, questionId: Int) -> CheckListAnswer? {
        return realm.objects(CheckListAnswer.self)
                    .filter("imjangId == %@ AND questionId == %d", imjangId, questionId)
                    .first
    }

    // 특정 임장 ID에 대한 모든 체크리스트 항목의 답변값 조회
    func getAllChecklistItems(for imjangId: Int) -> [CheckListAnswer] {
        let results = realm.objects(CheckListAnswer.self)
                    .filter("imjangId == %@", imjangId)
        let array: [CheckListAnswer] = results.map { $0 }
        return array
    }
    
    // 체크리스트 항목의 답변값 삭제
    func deleteChecklistItem(imjangId: Int, questionId: Int) {
        if let itemToDelete = realm.objects(CheckListAnswer.self)
                                  .filter("imjangId == %@ AND questionId == %@", imjangId, questionId)
                                  .first {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                    print("삭제")
                }
            } catch {
                print("Failed to delete checklist item: \(error.localizedDescription)")
            }
        } else {
            print("Checklist item not found for deletion")
        }
    }
}
