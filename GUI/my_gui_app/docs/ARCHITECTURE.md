# Clean Architecture 구조

이 프로젝트는 Clean Architecture 원칙에 따라 4개의 레이어로 구성되어 있습니다.

## 레이어 구조

```
lib/
├── domain/           # 도메인 레이어 (비즈니스 엔티티)
│   ├── types.ml      # 애플리케이션 상태 타입
│   └── events.ml     # 도메인 이벤트
│
├── application/      # 애플리케이션 레이어 (유스케이스)
│   └── use_cases.ml  # 비즈니스 로직 처리
│
├── infrastructure/   # 인프라 레이어 (외부 의존성)
│   └── gtk_adapter.ml # GTK 라이브러리 어댑터
│
└── presentation/     # 프레젠테이션 레이어 (UI)
    ├── window_builder.ml    # UI 컴포넌트 생성
    └── app_controller.ml    # 애플리케이션 컨트롤러
```

## 의존성 방향

```
presentation → application → domain
     ↓
infrastructure
```

- **Domain**: 다른 레이어에 의존하지 않음 (순수 비즈니스 로직)
- **Application**: Domain에만 의존
- **Infrastructure**: 외부 라이브러리 (lablgtk3)에만 의존
- **Presentation**: 모든 레이어를 조율

## 각 레이어 설명

### 1. Domain (도메인)
비즈니스 로직의 핵심. 외부 의존성이 없는 순수한 OCaml 코드.

- `types.ml`: 애플리케이션 상태 정의
- `events.ml`: 도메인 이벤트 정의

### 2. Application (애플리케이션)
유스케이스 구현. 도메인 엔티티를 사용하여 비즈니스 로직 처리.

- `use_cases.ml`: 입력 처리, 제출 처리 등의 유스케이스

### 3. Infrastructure (인프라)
외부 라이브러리와의 통신을 담당. GTK 라이브러리를 추상화.

- `gtk_adapter.ml`: GTK 위젯 조작을 위한 어댑터 함수

### 4. Presentation (프레젠테이션)
UI 구성 및 사용자 상호작용 처리.

- `window_builder.ml`: UI 컴포넌트 생성
- `app_controller.ml`: 이벤트 핸들링 및 상태 관리

## 장점

1. **테스트 용이성**: 각 레이어를 독립적으로 테스트 가능
2. **유지보수성**: 관심사의 분리로 코드 변경이 용이
3. **확장성**: 새로운 기능 추가 시 해당 레이어만 수정
4. **독립성**: UI 프레임워크 변경 시 Domain/Application 레이어는 영향 없음
