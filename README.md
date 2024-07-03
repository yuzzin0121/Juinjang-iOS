# 주인장 (🏆5th University MakeUs Challenge DemoDay 3등)

> 주인장은 부동산 임장에 대한 체크리스트, 녹음 및 메모가 가능한 **부동산 임장 기록 앱**입니다.
<img src=https://github.com/yuzzin0121/iOS/assets/77273340/d5ae930b-1b66-44c6-b4de-3f1222c3b94c width=650 height=350>
<br>




## 프로젝트 개발 및 환경
- iOS 3인 개발
- 개발 기간: 6개월 (2024.01.02 ~ 2024.06.28)
- 환경: 최소 버전 17.0 / 세로 모드 / 아이폰용
<br>


## 핵심 기능 
- **임장 |** 생성 / `조회` / `수정` / `검색` / `삭제` / `스크랩`
- **임장 이미지 |** `조회` / `추가` / `삭제`
- **임장 체크리스트 |** 작성 / 편집 / 저장
- **임장 리포트 |** 조회 / 임장 비교
- **임장 녹음 파일 |** `생성` / `조회` / `수정` / `삭제`
- **프로필 |** 사진 변경 / 닉네임 변경
- **인증 |** 카카오 로그인 / 애플 로그인 / 로그아웃 / 탈퇴
<br><br>
※ `표시` 는 제가 담당한 기능입니다.

## 스크린샷

<br>


## 주요 기술
**Framework** - UIKit <br>
**Pattern** - Router / MVC / Delegate / Singleton <br>
**Network** - Alamofire / Codable  <br>
**Database** - Realm <br>
**OpenSource** - SnapKit, Then, ToastSwift, TapMan, FSCalendar, Kingfisher, Lottie, IQKeyboardManagerSwift, DGCharts, KakaoOpenSDK <br>
**Etc** - AVFoundation <br>
<br><br>

## 핵심 구현 및 담당역할
### **Alamofire**
- Alamofire에 Router 패턴과 Generic을 통해 네트워크 통신의 구조화 및 확장성 있는 네트워킹 구현
- Alamofire RequestInterceptor를 활용한 JWT 인증 구현
- multipart-form을 활용해 이미지 파일을 서버에 전송

### **Etc**
- 공통적인 디자인의 뷰를 재사용하기 위해 커스텀 뷰로 구성
- 이미지 및 컬러 등 반복적으로 사용되는 에셋을 enum을 통해 네임스페이스화하여 관리
- NotificationCenter를 활용해 다른 계층에 있는 뷰에 데이터 갱신
- NetworkMonitor를 통해 네트워크 단절 상황 대응
- weak 키워드를 통해 객체를 약한 참조를 해줌으로써 메모리 누수 해결

<br><br>

## 트러블 슈팅

### 1. accessToken 만료 시 수동으로 갱신 후 네트워크 재요청을 해줘야 하는 이슈
**해결 방안** 
- Alamofire의 RequestInterceptor를 사용하여 네트워크 요청 전처리와 에러 후처리 구현
- 네트워크 요청 후 에러가 발생했을 때, response의 상태코드 값이 accessToken 만료에 해당하는 상태코드 값과 일치할 경우 refreshToken을 통해 accessToken 갱신하는 API를 요청 후 네트워크 재요청
- 네트워크 요청 전에 urlRequest 헤더의 Authorization Key에 대한 값으로 accessToken을 적용

<img src=https://github.com/yuzzin0121/iOS/assets/77273340/76adabd4-6502-4375-b866-fb037755ba34 width=1130 height=600>

