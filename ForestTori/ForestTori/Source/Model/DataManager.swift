//
//  DataManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import Foundation

/// 게임 데이터를 관리하는 클래스
///
/// - chapters: 챕터 정보
class DataManager: ObservableObject {
    @Published var chapters: [Chapter] = []
    
    /// DataManager의 chapters에 데이터 추가
    init() {
        // 식물 데이터 초기화
        let dandelion = Plant(characterName: "민들레씨",
                              characterDescription: "겁이 많은 민들레씨들이 하늘로 날아가지 못하고 있어요. 용기를 낼 수 있게 매일 창문을 열어 민들레씨들을 도와줄래요?",
                              mainQuest: "창문 열고 30분 환기하기",
                              missions: [
                                Mission(day: 1, content: "창문 열고 30분 환기하기 1"),
                                Mission(day: 2, content: "창문 열고 30분 환기하기 2"),
                                Mission(day: 3, content: "창문 열고 30분 환기하기 3"),
                                Mission(day: 4, content: "창문 열고 30분 환기하기 4"),
                                Mission(day: 5, content: "창문 열고 30분 환기하기 5"),
                                Mission(day: 6, content: "창문 열고 30분 환기하기 6"),
                                Mission(day: 1, content: "창문 열고 30분 환기하기 7"),
                              ],
                              totalDay: 7)
        let cactus = Plant(characterName: "선인장",
                           characterDescription: "꿈을 찾으려 먼 사막에서 온 작은 선인장 친구는 자신이 무엇을 좋아하는지 몰라 난처해하고 있어요. 함께 찾아볼까요?",
                           mainQuest: "\"내가 좋아하는 것이 뭘까?\" 기록해보기",
                           missions: [
                            Mission(day: 1, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 1"),
                            Mission(day: 2, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 2"),
                            Mission(day: 3, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 3"),
                            Mission(day: 4, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 4"),
                            Mission(day: 5, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 5"),
                            Mission(day: 6, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 6"),
                            Mission(day: 7, content: "\"내가 좋아하는 것이 뭘까?\" 기록해보기 7"),
                           ],
                           totalDay: 7)
        let mapleTree = Plant(characterName: "단풍나무",
                              characterDescription: "부끄럼이 많아 집에만 머무르던 단풍나무가 새로운 곳으로 여행을 떠나보려 해요. 단풍나무와 함께 여행을 준비해볼까요?",
                              mainQuest: "여행계획 세워보기",
                              missions: [
                                Mission(day: 1, content: "가보고 싶은 여행지 정하기"),
                                Mission(day: 2, content: "여행지에서 무엇을 하고싶은지 정하기"),
                                Mission(day: 3, content: "여행지까지 교통편 알아보기"),
                              ],
                              totalDay: 3)
        let cottonTree = Plant(characterName: "목화나무",
                               characterDescription: "이웃들의 도움 덕에 가을 불꽃으로부터 소중한 솜을 지킨 목화나무는, 자신도 도움이 필요한 사람들에게 힘이 되고자 해요. 함께 해볼까요?",
                               mainQuest: "봉사활동 해보기",
                               missions: [
                                Mission(day: 1, content: "1365 포털에서 봉사활동 신청하기"),
                                Mission(day: 2, content: "봉사활동 하기"),
                                Mission(day: 3, content: "봉사활동 인증서 확인하기"),
                               ],
                               totalDay: 3)
        
        // 챕터 데이터 초기화
        let spring = Chapter(chapterId: 1, chapterTitle: "봄, 숲을 만나다",
                             chatperDescription: "토리의 숲 속 반짝이는 무언가",
                             lastChapterEnding: "",
                             chapterPlants: [dandelion])
        let summer = Chapter(chapterId: 2,
                             chapterTitle: "여름, 안녕? 토리야",
                             chatperDescription: "여름이 찾아오고 장마가 시작되었어요. 오두막에서 홀로 반짝이는 빗방울을 구경하던 토리에게 \"나는 누구일까?\" 하는 궁금증이 생겼어요.",
                             lastChapterEnding: "민들레씨들이 용기를 얻었어요",
                             chapterPlants: [cactus])
        let autumn = Chapter(chapterId: 3,
                             chapterTitle: "가을, 꿈의 형태",
                             chatperDescription: "가을이 찾아온 토리의 숲이 알록달록해졌어요. 토리의 마음에도 변화가 시작된 것 같아요! 가을엔 어떤 반짝이는 도전들이 기다리고 있을까요?",
                             lastChapterEnding: "선인장은 좋아하는 것을 찾았어요",
                             chapterPlants: [mapleTree])
        let winter = Chapter(chapterId: 4,
                             chapterTitle: "겨울, 새로운 봄을 기다리며",
                             chatperDescription: "작은 눈송이들이 반짝이는 겨울이 찾아왔어요. 온통 새하얗게 바뀐 풍경을 바라보던 토리는 깨끗한 눈밭에 발자국을 남겨보고 싶어졌어요.",
                             lastChapterEnding: "단풍나무는 여행을 떠났어요",
                             chapterPlants: [cottonTree])
        
        // chapter에 챕터 데이터 추가
        self.chapters = [spring, summer, autumn, winter]
    }
}
