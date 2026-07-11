# FocalGrid UIKit Rewrite Guide

> This guide walks you through rewriting the FocalGrid SwiftUI app in UIKit.
> Use this as a learning reference — read the SwiftUI source first, then translate.

---

## Why UIKit?

- Full control over view lifecycle, gesture recognizers, and scroll behavior
- Essential for understanding how SwiftUI works under the hood
- Required for some platform features (e.g., `UIScrollView` paging, custom gestures)

---

## Architecture: MVVM in UIKit

### SwiftUI → UIKit ViewModel Mapping

| SwiftUI | UIKit |
|---------|-------|
| `@Observable` class | `ObservableObject` class with `@Published` properties |
| `@State private var` | Local variable initialized in `viewDidLoad` |
| `@StateObject` | Store the view model as a property, initialize in `init` |
| `@ObservedObject` | Pass view model via initializer or property |
| `@EnvironmentObject` | Inject via a custom `Container` or `Coordinator` pattern |

```swift
// SwiftUI
@Observable
class DetailCardViewModel {
    var selectedMechanicRoute: MechanicRoute?
}

// UIKit
class DetailCardViewModel: ObservableObject {
    @Published var selectedMechanicRoute: MechanicRoute?
}
```

---

## Navigation Architecture

### SwiftUI NavigationStack → UIKit UINavigationController

| SwiftUI | UIKit |
|---------|-------|
| `NavigationStack(path:)` | `UINavigationController` + store `path` array |
| `.navigationDestination(for:)` | `navigationController(_:didShow:)` + manual push |
| `.navigationDestination(item:)` | Handle in `ViewModel` setter, push in view controller |

**Pattern for type-based navigation (SwiftUI `for:`):**

```swift
// UIKit — match by type
func navigateToComposition(_ type: CompositionType) {
    let detailVC = DetailCardViewController(compositionType: type)
    navigationController?.pushViewController(detailVC, animated: true)
}
```

**Pattern for item-based navigation (SwiftUI `item:`):**

```swift
// UIKit — observe view model, push when item changes
viewModel.$selectedMechanicRoute
    .compactMap { $0 }
    .receive(on: DispatchQueue.main)
    .sink { [weak self] route in
        let mechanicVC = MechanicDetailViewController(route: route)
        self?.navigationController?.pushViewController(mechanicVC, animated: true)
    }
    .store(in: &cancellables)
```

### SwiftUI TabView → UIKit UITabBarController

```swift
// UIKit AppDelegate / SceneDelegate
let tabBarController = UITabBarController()
let homeVC = HomeViewController() // your NavigationStack root
let homeNav = UINavigationController(rootViewController: homeVC)
let galleryVC = GalleryViewController()
let galleryNav = UINavigationController(rootViewController: galleryVC)

homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
galleryNav.tabBarItem = UITabBarItem(title: "Gallery", image: UIImage(systemName: "photo.on.rectangle"), tag: 1)

tabBarController.viewControllers = [homeNav, galleryNav]
window?.rootViewController = tabBarController
```

---

## View Component Mapping

| SwiftUI | UIKit |
|---------|-------|
| `Text("Hello")` | `UILabel()` with `.text = "Hello"` |
| `Image("asset")` | `UIImageView(image: UIImage(named: "asset"))` |
| `VStack { }` | `UIStackView(arrangedSubviews: [...])` with `.axis = .vertical` |
| `HStack { }` | `UIStackView(arrangedSubviews: [...])` with `.axis = .horizontal` |
| `ZStack { }` | `UIStackView(arrangedSubviews: [...])` with `.axis = .vertical` + `.isUserInteractionEnabled = false` on children, or use plain `addSubview` with frame |
| `Spacer()` | `UIView()` with `setContentHuggingPriority(.defaultLow, ...)` |
| `Divider()` | `UIView()` with fixed height 1, background color |
| `Button("Tap") { }` | `UIButton(type: .system)` with `.addTarget(self, action:, for:)` |
| `Color.themePrimary` | `UIColor(named: "themePrimary")` or define extension |

### SwiftUI View Modifiers → UIKit

| SwiftUI | UIKit |
|---------|-------|
| `.padding()` | Set `layoutMargins` or use `NSLayoutConstraint` / SnapKit |
| `.padding(12)` | Set constant insets on `UIStackView.arrangedSubviews` or constraint constants |
| `.frame(width:height:)` | Set `frame` property or width/height constraints |
| `.frame(maxWidth: .infinity)` | Set hugging/compression priorities + superview constraints |
| `.background(Color.red)` | `view.backgroundColor = .red` or `view.layer.insertSublayer(...)` |
| `.cornerRadius(12)` | `view.layer.cornerRadius = 12; view.clipsToBounds = true` |
| `.shadow(radius: 6, y: 6)` | `view.layer.shadowOffset = CGSize(width: 0, height: 6); view.layer.shadowRadius = 6` |
| `.opacity(0.5)` | `view.alpha = 0.5` |
| `.zIndex(1)` | `view.layer.zPosition = 1` |
| `.hidden()` | `view.isHidden = true` |
| `.disabled(true)` | `view.isUserInteractionEnabled = false` |
| `.font(.title)` | `label.font = .preferredFont(forTextStyle: .title1)` |
| `.foregroundColor(.red)` | `label.textColor = .red` |

---

## The Paged Reader (Hardest Part)

This is the Deepstash-style snap-paging mechanic. In SwiftUI it's:

```swift
ScrollView(.vertical) {
    VStack(spacing: 0) {
        ForEach(mechanics) { mechanic in
            MechanicPageView(mechanic)
                .containerRelativeFrame(.vertical) { height, _ in height - 80 }
        }
    }
    .scrollTargetLayout()
}
.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
```

### UIKit: UICollectionView with Compositional Layout + Paging

```swift
class MechanicDetailViewController: UIViewController {

    private var dataSource: UICollectionViewDiffableDataSource<Section, GridMechanic>!
    private var collectionView: UICollectionView!

    enum Section { case main }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        applySnapshot()
    }

    private func setupCollectionView() {
        let layout = createPagingLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false // we'll use contentOffset for paging
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createPagingLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0) // full height, paging handled by delegate
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// Snap to page on scroll
extension MechanicDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let pageHeight = scrollView.bounds.height
        let currentPage = scrollView.contentOffset.y / pageHeight
        let targetPage: Int

        if velocity.y > 0.3 {
            targetPage = Int(ceil(currentPage))
        } else if velocity.y < -0.3 {
            targetPage = Int(floor(currentPage))
        } else {
            targetPage = Int(round(currentPage))
        }

        targetContentOffset.pointee = CGPoint(x: 0, y: CGFloat(targetPage) * pageHeight)
    }
}
```

### For the "peek" effect (80pt next card visible)

```swift
// In createPagingLayout, use .fractionalHeight with overlap
let itemSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(1.0),
    heightDimension: .fractionalHeight(0.92) // 92% height = 8% peek (~80pt on typical screen)
)
```

### Inner scroll on last card only

```swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MechanicCell", for: indexPath) as! MechanicCell
    let mechanic = mechanics[indexPath.item]
    let isLast = indexPath.item == mechanics.count - 1
    cell.configure(with: mechanic, innerScrollEnabled: isLast)
    return cell
}
```

---

## Step-by-Step Rewrite Plan

### Phase 1: App Entry & Navigation Shell

1. **Create `AppDelegate` + `SceneDelegate`** — set up `UITabBarController` with Home/Gallery tabs
2. **Create base `UIViewController` subclasses** — stub out all screens
3. **Wire navigation** — Home tab → `UINavigationController` → placeholder DetailVC

**Files to create:**
- `AppDelegate.swift`
- `SceneDelegate.swift` (or put in AppDelegate for older targets)
- `TabBarController.swift`
- `HomeViewController.swift`
- `GalleryViewController.swift` (keep stub)
- `DetailCardViewController.swift`
- `MechanicDetailViewController.swift`

### Phase 2: Model & ViewModel Ports

1. **Copy `Models/`** — Composition.swift, Enums/, MechanicRoute.swift — these are plain Swift, no SwiftUI dependency
2. **Port ViewModels to `ObservableObject`**
   - `DetailCardViewModel` — add `cancellables` property for Combine
   - `MainTabViewModel` (if needed) — plain `@Published` props

**Files to create/update:**
- `ViewModels/DetailCardViewModel.swift`
- `ViewModels/CompositionMock.swift` (can copy directly)

### Phase 3: Home Tab (Dashboard)

1. **Grid of `ThumbnailCardView`** → `UICollectionView` with 2-column grid layout
2. **Neo-brutalist styling** — hard edges, offset shadows via `layer.shadowOffset`
3. **Navigation** — tap → push `DetailCardViewController`

**Layout code (no SnapKit):**
```swift
// In cellForItemAt
let cardView = ThumbnailCardView() // custom UIView subclass
cell.contentView.addSubview(cardView)
cardView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    cardView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
    cardView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
    cardView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
    cardView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
])
```

### Phase 4: Detail Card

1. **Header with theme color** — `UIView` with background `compositionType.themeColor`
2. **Grid overlay image** — `UIImageView` with `grid_<type>` asset
3. **Mechanic list** — `UITableView` or `UICollectionView` list
4. **"Learn" CTA** — `UIButton` with neo-brutalist style (border, shadow)

### Phase 5: Paged Reader (MechanicDetailViewController)

This is the most complex part. See the section above.

1. `UICollectionView` + Compositional Layout
2. Snap-paging delegate
3. Card views with appropriate layouts (imageTop, imageBottom, textCentered)
4. Scrim overlay for current card
5. Progress bar (use `UIProgressView`)

---

## Required Imports

```swift
import UIKit
import Combine
```

---

## File Structure (Target)

```
FocalGridUIKit/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Models/
│   ├── Composition.swift
│   ├── Enums/
│   │   ├── CompositionType.swift
│   │   └── MechanicLayoutStyle.swift
│   ├── MechanicRoute.swift
│   └── Mocks/
│       └── CompositionMock.swift
├── ViewModels/
│   ├── DetailCardViewModel.swift
│   └── MechanicDetailViewModel.swift
├── ViewControllers/
│   ├── MainTabBarController.swift
│   ├── HomeViewController.swift
│   ├── DashboardViewController.swift
│   ├── DetailCardViewController.swift
│   └── MechanicDetailViewController.swift
├── Views/
│   ├── Components/
│   │   ├── ThumbnailCardView.swift
│   │   ├── MechanicRowView.swift
│   │   └── ProgressBarView.swift
│   └── Cells/
│       ├── CompositionCell.swift
│       └── MechanicCell.swift
├── Extensions/
│   ├── UIColor+Theme.swift
│   └── UIView+Layout.swift
├── Resources/
│   └── Assets.xcassets
└── Info.plist
```

---

## Key UIKit Concepts to Learn

1. **Auto Layout** — `NSLayoutConstraint.activate([...])` or SnapKit
2. **UICollectionView** — diffable data sources, compositional layouts, supplementary views
3. **UINavigationController** — push/pop, delegate pattern
4. **UITableView** — for simple lists (mechanic rows)
5. **UIScrollView** — delegate, content inset, paging
6. **Combine** — `@Published` → `.sink` subscriptions
7. **UIViewController Lifecycle** — `viewDidLoad`, `viewWillAppear`, `viewDidAppear`

---

## Recommended Learning Order

1. Start with a single `UIViewController` + `UILabel` + `UIButton` (Hello World)
2. Add Auto Layout constraints manually
3. Replace with `UICollectionView` + Diffable Data Source
4. Add `UINavigationController` navigation
5. Wire up `UITabBarController`
6. Implement Combine bindings for MVVM
7. Build the paged reader last (hardest)

---

## SwiftUI Features Without Direct UIKit Equivalent

| SwiftUI | UIKit Workaround |
|---------|-----------------|
| `.containerRelativeFrame` | Calculate in `UICollectionViewLayout` or cell sizing |
| `.scrollTargetBehavior` | `UIScrollViewDelegate` + manual snap |
| `@Observable` | `ObservableObject` + Combine |
| `@Environment` | Singleton service or dependency injection via initializer |
| `@AppStorage` | `UserDefaults.standard` |
| View modifiers chain | Set properties directly on views |
| `@ViewBuilder` | Separate `UIStackView` / `prepareForInterfaceBuilder` methods |

---

## Debugging Tips

- **Layout issues**: Enable "Debug View Hierarchy" (⌘+I in simulator)
- **Memory leaks**: Use Instruments → Leaks + "Allocations"
- **Combine leaks**: Store `AnyCancellable` in a `Set` (like `cancellables`), cancel in `deinit`
- **Scroll issues**: Check `contentSize`, `bounds`, `contentOffset` in debugger

---

## Minimal Viable Rewrite (First Sprint)

If you want to ship quickly and iterate:

1. App shell with TabBar + Navigation
2. Dashboard with 2-column grid (UICollectionView, no diffable data source yet)
3. Detail card (static content, no mechanics)
4. Paged reader (single card only, no navigation)

Add features incrementally from there.
