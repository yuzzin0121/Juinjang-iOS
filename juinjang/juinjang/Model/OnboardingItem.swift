//
//  OnboardingItem.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import Foundation

struct OnboardingItem {
    let title: String
    let keyword: String
    let videoURL: URL?
    
    init(title: String, keyword: String, videoURL: URL?) {
        self.title = title
        self.keyword = keyword
        self.videoURL = videoURL
    }
}
