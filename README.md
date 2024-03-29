
![Group 10314](https://github.com/Oreo-Mcflurry/SeSAC-Recap2/assets/96654328/36454287-ac71-47f3-8a74-15e8b109c9db)

## [미출시] 가상화폐 시세 정보 앱 | 2024.02.27 ~ 2024.03.04 (7일)

<aside>
⭐ 가상화폐 시세 정보 앱
  
가상화폐의 시세 정보를 손 쉽게 받아올 수 있는 앱 입니다.

</aside>

![스크린샷 2024-03-25 00 39 45](https://github.com/Oreo-Mcflurry/SeSAC-Recap2/assets/96654328/712ea984-61d2-4538-b36d-3b526996d8da)

## 🧑‍🤝‍🧑 팀구성

- 1인 개발

### 🔨 기술 스택 및 사용한 라이브러리

- UIKit / SnapKit
- MVVM
- Observable Pattern
- Input / Output Pattern
- Realm
- Alamofire
- Toast
- DGCharts

### 👏 해당 기술을 사용하며 이룬 성과

- Realm Reopository Pattern과 Generic을 통한 모듈화
- Alamofrie와 Generic을 통한 모듈화
- Toast 라이브러리를 활용하여 사용자 경험을 향상
  - Favorite Coin에 추가 / 삭제 할 때
  - 검색에 실패했을 때
  - API의 제한이 걸려 몇 초 후 다시 정보를 가져올 수 있는지 알려 줄 때

### 📝 성과 및 결과

- SeSAC에서 학습 및 과제를 위해 만든 프로젝트로, 출시를 하지 않았음

### 🌠 Trouble Shooting 및 배운 점

- 코인의 정보를 실시간으로 받아와야 하는데, 만약 Scene 마다 따로 요청을 하게 된다면 정보의 차이가 벌어질 수 있다고 생각
  - 실시간으로 받아오는 코인의 정보를 싱글톤으로 만들어 앱 전역에서 접근 할 수 있도록 만들었음
  - 다만, 앱의 데이터를 전역에서 접근할 수 있다는건 MVVM패턴과 상충하게 되었고, 패턴을 도입한게 무용지물이 되었다는걸 배웠습니다.
  - 코인의 정보를 Relam에 저장하기엔 오랫동안 앱을 켜지 않은 유저의 경우 앱을 켜자마자 잘못 된 시세 정보를 보게 될 확률이 높기 때문에, 앱이 꺼질때 코인의 시세 정보도 같이 지워주는 식으로 대응 할 수 있을 것 같습니다.
- 최초에 ViewModel을 싱글톤으로 구성함, 그 이유는 비슷한 기능을 하는 Function이 많을것이라고 생각했고, Realm의 데이터가 변경되었을때 한번에 realm의 데이터를 사용하는 모든 TableView와 CollectionView가 reload되었으면 좋겠다고 생각했기 때문.
  - 그러나 뷰마다 비슷한 기능을 하지만 따로 관리하기 위해 변수명이 비슷하면서 두번 선언하게 됨 
  - 같은 뷰를 여러 탭에서 push했을 경우에 첫번째로 push된 뷰의 bind가 무시 되는 현상이 발생
  - ViewModel에서 싱글톤을 덜어내어서 구현함

### 📋 Post Mortem

- 아쉬웠던 점
- 몇몇 클래스에서 클로저의 캡쳐 현상으로 deinit이 되지 않는 문제가 발생한점이 아쉬웠음
  - 메모리 누수에 조금 더 신경을 쓰면 좋겠다는점을 학습
