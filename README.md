# 프로젝트 개요

---

### 개발 기간

2022/07/22 ~ 2022/07/24

### 프로젝트 내용

Rxswift, MVVM 기반 메모 앱

## 기술

- UIKit
- RxSwift, RxCocoa, Action
- MVVM
- Coordinator Pattern

## 공부한 내용

### MVVM

- 각 ViewController에 맞는 ViewModel 을 만들어서, 각 VC에 VM을 생성해, VM 값을 View에 바인딩 하는 방법을 배웠다.
- VC, VM의 역할을 이해했다. 특히 VM에서 View에 값을 전달해주기 위해 데이터를 처리하는 과정을 이해했다.
- Common VM 클래스를 만들어서 Coordinator와 Storage를 넣은 다음 하위 VM이 이 클래스를 상속 받으니 Storage와 Coordinator 관리하기가 쉬웠다.

### Coordinator

- 스토리보드의 Segue와, PushViewController 없이 화면전환 하는 방법을 이해했다.
- AppDelegate에 Coordinator와 Storage를 생성하고 시작 화면 ViewModel에 두 인스턴스를 저장했다.
    
    따라서 공통된 ViewModel은 하나의 큰 Coordinator(Appcoordinator)로 화면전환을 했다.
    
- Storyboard의 identifier 값으로 구분을 해서 viewModel을 바인드 했다.
- Coordinator Pattern에서 트리형식으로 계속 Coordinator를 추가해 Sub Coordinator 를 사용할 수 있다는 것을 알게 되었다.
    
    각 ViewController에 맞는 SubCoordinator를 생성해 화면전환을 할 수 있다.
    

### RxSwift, RxCocoa, Action

- VC에서 RxCocoa로 view와 viewModel을 바인딩해서 구현했습니다.
- Button Action은 Action을 이용해 ViewModel의 메소드와 연결해 구현했습니다.
- 부가적으로 Observable 연산을 위해 Rxswift 를 사용했습니다.
