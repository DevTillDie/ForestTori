//
//  Chapter.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import Foundation

/// 챕터 정보
///
/// - chapterId: 챕터 번호
/// - chapterTitle: 챕터 제목
/// - chapterDescription: 챕터 소개
/// - lastChapterEnding: 지난 챕터 결말
/// - chatperBackgroundImage: 챕터 백그라운드 이미지
/// - chapterPlants: 챕터에 속한 식물 목록
struct Chapter: Codable {
    var chapterId: Int
    var chapterTitle: String
    var chatperDescription: String
    var lastChapterEnding: String
    var chatperBackgroundImage: String
    var chapterPlants: [Plant]
}
