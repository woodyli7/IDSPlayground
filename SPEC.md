# IDSPlayground — Specification

> Design system reference, architecture, and conventions for the IDSPlayground starter pack.

---

## 1. Overview

IDSPlayground is a SwiftUI iOS starter pack for prototyping Instacart user flows. It comes pre-configured with the Instacart Design System (IDS) tokens — colors, typography, and spacing — so designers can focus on building flows rather than setup.

---

## 2. Terminology

Figma-friendly terms used throughout this project. Code equivalents shown in parentheses.

| Term | Definition | Code Equivalent |
|------|-----------|----------------|
| **Flow** | A multi-screen user journey | Folder under `Features/` with `NavigationStack` |
| **Screen / Frame** | A full-screen UI. "Screen" for the app, "frame" in Figma. Interchangeable. | SwiftUI `View` struct, maps to a Step enum case |
| **Page** | A tab in a Figma file containing multiple frames. Not an app concept. | N/A — Figma-only |
| **Component** | A reusable UI piece | Struct in `DesignSystem/Components/` with IDS naming |
| **Overlay** | UI on top of a screen: modal, sheet, dialog | `.sheet()`, `.fullScreenCover()`, `.overlay()` |
| **Token** | A named design value: color, font, or spacing | `IDSColors`, `IDSTypography`, `IDSSpacing` |
| **Asset** | An icon, image, or illustration | File in `Assets.xcassets/` |

**Hierarchy:** Flow > Screen (+ Overlays), built with Components, styled with Tokens, using Assets.

---

## 3. Architecture

### Pattern: MVVM + Flow Coordinators

```
┌─────────────────────────────────────────────┐
│ ContentView                                 │
│   @State var activeFlow: AppFlow?           │
│   ├── nil → placeholder view                │
│   ├── .orderCard → OrderCardFlow            │
│   └── .locationSharing → LocationSharingFlow│
└─────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│ {FlowName}Flow (Flow Coordinator)           │
│   @State var viewModel                      │
│   NavigationStack(path: $viewModel.path)    │
│     .navigationDestination(for: Step.self)  │
│     .environment(viewModel)                 │
└─────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│ {FlowName}ViewModel (@Observable)           │
│   var path: [Step]                          │
│   // flow state, computed properties        │
│   // navigation actions                     │
└─────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│ Screen Views                                │
│   @Environment(ViewModel.self) var viewModel│
│   Uses IDS tokens and components            │
└─────────────────────────────────────────────┘
```

- **Navigation:** `NavigationStack` with enum-based type-safe routing (iOS 16+)
- **State:** `@Observable` classes (iOS 17+), injected via `.environment(viewModel)`
- **Root routing:** `ContentView` uses `@State private var activeFlow: AppFlow?` — no nested NavigationStacks
- Each flow owns its own `NavigationStack`
- Flows receive `onDismiss: () -> Void` to return to root

---

## 4. Project Structure

```
IDSPlayground/
├── IDSPlayground.xcodeproj/
├── IDSPlayground/
│   ├── IDSPlaygroundApp.swift          # @main entry point
│   ├── ContentView.swift               # Root routing
│   ├── Info.plist                      # Font registration, display name
│   │
│   ├── Fonts/                          # 16 Instacart Sans TTF files
│   │
│   ├── DesignSystem/
│   │   ├── Tokens/
│   │   │   ├── IDSColors.swift         # Color tokens
│   │   │   ├── IDSTypography.swift     # Typography tokens
│   │   │   └── IDSSpacing.swift        # Spacing tokens
│   │   └── Components/                 # IDS-prefixed reusable components
│   │
│   ├── Assets.xcassets/                # Icons, images, illustrations
│   │
│   └── Features/
│       └── {FlowName}/
│           ├── {FlowName}Flow.swift
│           ├── {FlowName}ViewModel.swift
│           └── Views/
│               ├── FirstScreenView.swift
│               └── ...
│
├── CLAUDE.md                            # AI project rules (Claude Code and Cursor)
├── FLOW_TEMPLATE.md                    # How to add a new flow
├── SPEC.md                             # This file
└── README.md                           # Getting started guide
```

---

## 5. Design System Tokens

### 5.1 Colors (IDSColors)

| Token | Value | Usage |
|-------|-------|-------|
| `brandTertiaryLight` | #f7f5f0 | Warm off-white background |
| `grayscale00` | white | White background |
| `grayscale20` | #e8e9eb | Selector borders, subtle dividers |
| `grayscale70` | #343538 | Header title text, selected ring |
| `grayscale80` | #242529 | Title text, primary content |
| `contentSecondary` | #56595e | Body text, descriptions |
| `buttonPrimaryBg` | #108910 | Primary button background (green) |
| `buttonPrimaryContent` | white | Primary button text |
| `buttonPrimaryBgLoading` | #0d720d | Primary button loading background |
| `buttonSecondaryBg` | #e8e9eb | Secondary button background |
| `buttonSecondaryContent` | #242529 | Secondary button text |
| `buttonSecondaryBgLoading` | #c7c8cd | Secondary button loading background |
| `buttonTertiaryBg` | #f6f7f8 | Tertiary button background |
| `buttonTertiaryBorder` | #e8e9eb | Tertiary button border (1px) |
| `buttonTertiaryContent` | #242529 | Tertiary button text |
| `buttonDetrimentalBg` | #de3534 | Detrimental button background (red) |
| `buttonDetrimentalContent` | white | Detrimental button text |
| `buttonDetrimentalBgLoading` | #bb1c1b | Detrimental button loading background |
| `buttonInstacartPlusBg` | #530038 | Instacart+ button background (plum) |
| `buttonInstacartPlusContent` | white | Instacart+ button text |
| `buttonInstacartPlusBgLoading` | #750046 | Instacart+ button loading background |
| `buttonDisabledBg` | #f6f7f8 | Disabled button background (all types) |
| `buttonDisabledContent` | #c7c8cd | Disabled button text (all types) |
| `inputBorder` | #8f939b | Input field border (1px) |
| `inputBackground` | white | Input field background |
| `inputTextLabel` | #242529 | Input label text |
| `inputTextInput` | #242529 | Input field text |
| `inputBorderActive` | #242529 | Active input border (2px) |
| `inputBorderInvalid` | #de3534 | Invalid input border (2px) |
| `inputBackgroundInvalid` | #fef0f0 | Invalid input background |
| `inputErrorContent` | #de3534 | Error text |
| `badgeBackground` | #242529 | Standard badge background |
| `badgeBackgroundCritical` | #de3534 | Critical badge background |
| `badgeContent` | white | Badge text and dot color |
| `badgeBorder` | white | Outlined badge border |
| `vehicleBlack` | #343538 | Vehicle color option |
| `vehicleCashew` | #e8dcc8 | Vehicle color option |
| `vehicleLemon` | #f5d547 | Vehicle color option |
| `vehicleKale` | #1b6631 | Vehicle color option |
| `vehiclePlum` | #6b1d5e | Vehicle color option |
| `vehicleBlue` | #7b8dc8 | Vehicle color option |
| `vehicleRed` | #8b1a1a | Vehicle color option |

### 5.2 Typography (IDSTypography)

| Token | Font | Size | Line Height | Usage |
|-------|------|------|-------------|-------|
| `headline` | Subhead SemiBold | 24px | 28px | Screen titles |
| `title` | Subhead SemiBold | 18px | 22px | Section titles |
| `subtitle` | Text SemiBold | 14px | 20px | Section subtitles |
| `button` | Subhead SemiBold | 18px | 18px | Button labels (standard) |
| `buttonSmall` | Subhead SemiBold | 14px | 18px | Button labels (small) |
| `bodyRegular` | Text Regular | 12px | 18px | Input fields, placeholder text |
| `bodyEmphasized` | Text SemiBold | 12px | 18px | Content rows, descriptions |
| `accentRegular` | Text Regular | 10px | 14px | Error text, small labels |
| `accentEmphasized` | Text SemiBold | 10px | 14px | Badge counter, badge "New" label |

### 5.3 Spacing (IDSSpacing)

| Token | Value | Usage |
|-------|-------|-------|
| `none` | 0px | No spacing |
| `xxs` | 2px | Minimal gap |
| `xs` | 4px | Input vertical gap |
| `sm` | 8px | Nav horizontal padding |
| `md` | 12px | Row vertical padding |
| `lg` | 16px | Row horizontal padding, title padding |
| `xl` | 24px | Section gaps |
| `xxl` | 32px | Large section gaps |
| `xxxl` | 48px | Extra large gaps |

---

## 6. Conventions

### Figma Conventions

#### Page Structure

Organize each Figma file into **3 pages**, ordered bottom-up from primitives to composition:

| Page | Contents | Why |
|------|----------|-----|
| **IDS Components** | Reusable design system components (`IDS.Button`, `IDS.Input/IDS.TextField`, etc.) with all states/variants | Built first — maps to `DesignSystem/Components/` |
| **Custom Components - {FlowName}** | Flow-specific components not in the global design system | Built second — reusable within the flow |
| **Flow - {FlowName}** | All screens in navigation order, showing the complete user journey | Built last — assembles components into screens |

#### Component Naming

Figma IDS components use **dot-slash hierarchy** for grouping:

| Figma Name | Code File | Mapping Rule |
|------------|-----------|--------------|
| `IDS.Button / Standard` | `IDSButton.swift` | Category becomes filename; variant (`Standard`) becomes a parameter or enum case |
| `IDS.Input/IDS.TextField` | `IDSTextField.swift` | Deepest component name becomes the filename |

- The `IDS.` prefix and slashes are for Figma organization — the code filename is always `IDS{LeafName}.swift`
- Variants after ` / ` (e.g., `Standard`, `Destructive`) map to component parameters, not separate files

#### Layer Naming

Name layers that represent meaningful UI concepts. Skip generic layout wrappers.

| Layer Type | Name It? | Example |
|------------|----------|---------|
| Component instances | Yes | `IDS.Button / Standard` |
| Screen frames (top-level) | Yes | `FirstScreenView - Default` |
| Images, icons, illustrations | Yes | `OrderCard-confirmation` (see Asset Naming below) |
| Semantic sections | Yes | `HeaderSection`, `CTASection` |
| Generic layout wrappers | No | `Frame 12`, `Group 3` — leave default |
| Decorative shapes | No | Rectangles, divider lines — leave default |
| Text layers | No | The visible text content is what matters |

#### Asset Naming

Name image/icon layers in Figma to match the **final asset name** before exporting:

```
Figma layer: "OrderCard-confirmation"
       ↓ export as PDF
Finder file: OrderCard-confirmation.pdf
       ↓ drag into Xcode
Assets.xcassets: OrderCard-confirmation
       ↓ reference in code
SwiftUI: Image("OrderCard-confirmation")
```

Convention: `{FlowName}-{description}` (e.g., `OrderCard-confirmation`, `LocationSharing-map-pin`)

#### State Variants

Append a state suffix to screen frames and component variants:

- ` - Default` — resting/initial state
- ` - Active` — focused or in-progress state
- ` - Disabled` — non-interactive state
- ` - Error` — validation error state
- ` - Filled` — completed/populated state

Example: `FirstScreenView - Default`, `FirstScreenView - Filled`, `IDS.Button / Standard - Disabled`

### File Naming

- Views: `{ScreenName}View.swift`
- ViewModels: `{FlowName}ViewModel.swift`
- Flow coordinators: `{FlowName}Flow.swift`
- Design components: `IDS{ComponentName}.swift`
- Design tokens: `IDS{Category}.swift`

### Code Style

- Every file starts with a header comment (purpose, flow context)
- Use `// MARK: -` to organize sections
- Include `#Preview` at the bottom of every view file
- Step enums live in the ViewModel file

### Navigation

- Each flow owns its own `NavigationStack(path:)` bound to `viewModel.path`
- Use `.navigationDestination(for: {Step}.self)` for routing
- Always hide system nav bar (`.navigationBarHidden(true)`)
- Pass `onDismiss: () -> Void` closures for flow exit

### State Management

- ViewModels are `@Observable` classes
- Views access ViewModel via `@Environment(ViewModel.self) private var viewModel`
- Views should be as stateless as possible
- Use computed properties for derived state

### SwiftUI Patterns

- Use `VStack(spacing: IDSSpacing.none)` as root layout — control spacing explicitly
- Background colors on the outermost container
- Use `Spacer()` for flexible layout, not arbitrary padding
- **ALWAYS** use `IDSColors` for colors — never hardcode hex values
- **ALWAYS** use `IDSTypography` for fonts — never use `.font(.title)` or `.font(.system(...))`
- **ALWAYS** use `IDSSpacing` for padding/spacing — never hardcode numeric values

---

## 7. Components

### 7.1 IDSButton (`DesignSystem/Components/IDSButton.swift`)

Pill-shaped button in three sizes. Maps to Figma `IDS.Button / Standard`, `IDS.Button / Small`, and `IDS.Button / Compact`.

**API:**

```swift
IDSButton("Continue", type: .primary) { /* action */ }
IDSButton("Details", type: .tertiary, size: .small) { /* action */ }
IDSButton("Action", type: .tertiary, size: .compact) { /* action */ }
IDSButton("Continue", type: .detrimental, isLoading: true) { /* action */ }
IDSButton("Continue", type: .secondary, isEnabled: false) { /* action */ }
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | `String` | — | Button text |
| `type` | `IDSButtonType` | `.primary` | Visual type |
| `size` | `IDSButtonSize` | `.standard` | Size variant |
| `isLoading` | `Bool` | `false` | Show loading dots |
| `isEnabled` | `Bool` | `true` | Enable/disable |
| `action` | `() -> Void` | — | Tap handler |

**Types:** `.primary`, `.secondary`, `.tertiary`, `.detrimental`, `.instacartPlus`

**Sizes:** `.standard`, `.small`, `.compact`

**States:** Default (shows label), Loading (shows animated ellipsis dots), Disabled (gray background + text, all types identical)

**Layout by size:**

| Property | Standard | Small | Compact |
|----------|----------|-------|---------|
| Height | 56px | 40px | 32px |
| Width | Full width | Flexible (min 80, max 192) | Intrinsic (min 60, max 188) |
| Font | `button` (18px) | `buttonSmall` (14px) | `bodyEmphasized` (12px) |
| Loading dots | 12px | 8px | 6px |
| Text truncation | No | Yes (ellipsis) | Yes (ellipsis) |

All sizes: corner radius 999px (pill), horizontal padding 16px. Tertiary type has a 1px border.

### 7.2 IDSContentRow (`DesignSystem/Components/IDSContentRow.swift`)

Content row for displaying static information with text and optional visual elements. Maps to Figma `IDS.Row / Content Row`.

**API:**

```swift
// String only
IDSContentRow(title: "Order #1234", subtitle: "Delivered")

// With icon (24×24 template image)
IDSContentRow(title: "Location", subtitle: "123 Main St") {
    Image("IDS-icon-marker")
        .renderingMode(.template)
        .frame(width: 24, height: 24)
}

// With avatar (48×36 retailer image)
IDSContentRow(title: "Sprouts", subtitle: "Grocery") {
    Image("IDS-avatar-retailer")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 48, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 8))
}

// Card style with trailing content
IDSContentRow(
    title: "Subtotal",
    trailingTitle: "$12.99",
    isCard: true
)
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String?` | `nil` | Primary text (emphasized weight) |
| `subtitle` | `String?` | `nil` | Secondary text (regular weight) |
| `tertiaryText` | `String?` | `nil` | Tertiary text (only if subtitle present) |
| `trailingTitle` | `String?` | `nil` | Right-side primary text |
| `trailingSubtitle` | `String?` | `nil` | Right-side secondary text |
| `inset` | `IDSContentRowInset` | `.standard` | Vertical padding mode |
| `isCard` | `Bool` | `false` | Card container with border + radius |
| `isDisabled` | `Bool` | `false` | Gray out all content |
| `leading` | `@ViewBuilder` | `EmptyView` | Icon, avatar, or any leading view |

**Insets:** `.standard` (12px vertical padding), `.compact` (8px vertical padding)

**States:** Default (normal colors), Disabled (all text becomes `#c7c8cd`)

**Layout:** horizontal padding 16px, gap 8px (with leading) or 0px (string only). Card variant: white background, 1px `#e8e9eb` border, 8px corner radius, 16px outer horizontal padding. Icon leading: 24×24. Avatar leading: 48×36 with 8px corner radius.

**Assets used in previews:** `IDS-icon-marker` (template PDF, map pin), `IDS-avatar-retailer` (full-color PDF, retailer logo).

### 7.3 IDSSectionTitle (`DesignSystem/Components/IDSSectionTitle.swift`)

Section header with hierarchy, optional secondary text, and leading/trailing content slots. Maps to Figma `IDS.SectionTitle`.

**API:**

```swift
// Headline — contained (default)
IDSSectionTitle("Headline section")

// Title with secondary text
IDSSectionTitle("Section title", hierarchy: .title, secondaryText: "Description")

// Subtitle, not contained, with trailing compact button
IDSSectionTitle("Section title", hierarchy: .subtitle, isContained: false) {
    IDSButton("Action", type: .tertiary, size: .compact) {}
}

// With both leading and trailing content
IDSSectionTitle("Section title", hierarchy: .title, leading: {
    Image("IDS-icon-marker")
        .renderingMode(.template)
        .frame(width: 24, height: 24)
}) {
    IDSButton("Action", type: .tertiary, size: .compact) {}
}
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | — | Section title text |
| `hierarchy` | `IDSSectionTitleHierarchy` | `.headline` | Typography level |
| `isContained` | `Bool` | `true` | Adds horizontal/vertical padding |
| `secondaryText` | `String?` | `nil` | Optional body text below title |
| `leading` | `@ViewBuilder` | `EmptyView` | Optional leading content slot |
| `trailing` | `@ViewBuilder` | `EmptyView` | Optional trailing content slot |

**Hierarchies:** `.headline` (24px), `.title` (18px), `.subtitle` (14px)

**Layout:** Contained: px 16px, py 8px. Not contained: 0px padding. Gap between leading/text/trailing: 8px. Gap between title and secondary text: 0px. Title color: `grayscale80`. Secondary text: `bodyRegular`. Min width: 240px.

### 7.4 IDSImage (`DesignSystem/Components/IDSImage.swift`)

Full-width image container with padding and rounded corners. Maps to Figma `IDS.Image / Standard`. Container height is responsive to the image's intrinsic aspect ratio.

**API:**

```swift
IDSImage("ImagePlaceholder")
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `imageName` | `String` | — | Asset name in `Assets.xcassets` |

**Layout:** Full width container. Horizontal padding 16px (`lg`), vertical padding 12px (`md`). Image corner radius 12px. Image fills container width; height scales proportionally based on the image's aspect ratio.

### 7.5 IDSTopNav (`DesignSystem/Components/IDSTopNav.swift`)

Top navigation bar with optional leading icon, title, and up to two trailing icon buttons. Maps to Figma `IDS.TopNav / Standard`. All slots are independently toggleable — pass `nil` to hide any element.

**API:**

```swift
// Full nav: back + title + save + share
IDSTopNav(
    title: "Surface title",
    leadingIcon: "IDS.Icon.ArrowLeft",
    leadingAction: { /* go back */ },
    trailingSecondaryIcon: "IDS.Icon.Save",
    trailingSecondaryAction: { /* save */ },
    trailingPrimaryIcon: "IDS.Icon.ShareiOS",
    trailingPrimaryAction: { /* share */ }
)

// Back button + title only
IDSTopNav(
    title: "Surface title",
    leadingIcon: "IDS.Icon.ArrowLeft",
    leadingAction: { /* go back */ }
)

// Title only
IDSTopNav(title: "Surface title")
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String?` | `nil` | Title text (single line, truncated) |
| `leadingIcon` | `String?` | `nil` | Leading icon asset name |
| `leadingAction` | `(() -> Void)?` | `nil` | Leading icon tap handler |
| `trailingSecondaryIcon` | `String?` | `nil` | Secondary trailing icon (left of primary) |
| `trailingSecondaryAction` | `(() -> Void)?` | `nil` | Secondary trailing tap handler |
| `trailingPrimaryIcon` | `String?` | `nil` | Primary trailing icon (far right) |
| `trailingPrimaryAction` | `(() -> Void)?` | `nil` | Primary trailing tap handler |

**Layout:** Height 48px. Horizontal padding 8px (`sm`). Background white (`grayscale00`). Gap between elements 8px (`sm`). Icon buttons: 40×40 tap target with 24×24 template icon in `grayscale80`. Title: `title` typography (18px Subhead SemiBold), `grayscale80` color, single line with tail truncation.

**Assets used in previews:** `IDS.Icon.ArrowLeft` (back arrow), `IDS.Icon.Save` (bookmark), `IDS.Icon.ShareiOS` (share).

### 7.6 IDSBadge (`DesignSystem/Components/IDSBadge.swift`)

Small pill-shaped status indicator. Maps to Figma `IDS.Badge`. Use Standard (black) for retailer counters and Critical (red) for important messages like new features or promo counts.

**API:**

```swift
// Counter badge (standard, outlined)
IDSBadge(type: .counter(3))

// Dot badge (critical, outlined)
IDSBadge(type: .dot, appearance: .critical)

// New badge (critical, not outlined)
IDSBadge(type: .new, appearance: .critical, isOutlined: false)
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `type` | `IDSBadgeType` | — | Content type: `.counter(Int)`, `.dot`, or `.new` |
| `appearance` | `IDSBadgeAppearance` | `.standard` | Color scheme |
| `isOutlined` | `Bool` | `true` | Show white border |

**Appearances:** `.standard` (black `#242529`), `.critical` (red `#de3534`)

**Types:** `.counter(Int)` (number text), `.dot` (small circle indicator), `.new` ("New" label)

**Layout:** Height 16px for all types. Corner radius 999 (pill). Content color white. Font: `accentEmphasized` (10px Text SemiBold, lineHeight 14px). Counter: horizontal padding 2px, min text width 12px. Dot: 16×16 container, 4×4 inner circle. New: horizontal padding 4px. Outlined: 2px solid white border.

### 7.7 IDSTabs (`DesignSystem/Components/IDSTabs.swift`)

Segmented-control-style tab bar with sliding underline indicator. Maps to Figma `IDS.Tabs`. Two layout modes based on tab count: fixed equal-width (2 tabs) or horizontally scrollable (3+ tabs). Optional counter badge support per tab.

**API:**

```swift
// Basic 2-tab usage
IDSTabs(
    tabs: [IDSTabItem(title: "Tab 1"), IDSTabItem(title: "Tab 2")],
    selectedIndex: $selectedIndex
)

// 3+ tabs with badges — scrollable
IDSTabs(
    tabs: [
        IDSTabItem(title: "Orders", badgeCount: 5),
        IDSTabItem(title: "Returns"),
        IDSTabItem(title: "History")
    ],
    selectedIndex: $selectedIndex
)
```

**Data Model — `IDSTabItem`:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | — | Tab label text |
| `badgeCount` | `Int?` | `nil` | Counter badge value; `nil` hides badge |

**Component Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tabs` | `[IDSTabItem]` | — | Array of tab items (minimum 2) |
| `selectedIndex` | `Binding<Int>` | — | Currently selected tab index |

**Layout Modes:**

- **Fixed (2 tabs):** Equal-width tabs fill the container. Text truncates with ellipsis if overflow. Underline spans full tab container width. Not scrollable. Gap between tabs: 8px (`sm`).
- **Scrollable (3+ tabs):** Content-width tabs with 12px (`md`) horizontal padding. Text never truncates. Underline spans tab content width. Horizontal scroll with standard iOS bounce. Gap between tabs: 0px.

**Visual Tokens:** Height 40px. Outer horizontal padding 16px (`lg`). Max tab group width 512px. Background white (`grayscale00`). Font: `bodyEmphasized` (12px Text SemiBold). Selected text/underline: `grayscale80` (`#242529`). Unselected text: `contentSecondary` (`#56595e`). Underline height: 2px.

**Animation:** Selected underline slides between tabs via `matchedGeometryEffect`, easeInOut 0.25s. In scrollable mode, selected tab auto-scrolls into view. Badge count-up: when a tab becomes selected, its badge counter animates from 0 to the target value over 0.5s with easeOut easing. Unselected tabs always show their full badge value (no animation on deselect). No re-trigger if the already-selected tab is tapped.

**Badge:** Uses `IDSBadge` with `.counter(count)`, `.standard` appearance, `isOutlined: false`. Shown only when `badgeCount != nil`. Wrapped in `IDSTabBadge` (state manager) and `IDSCountingBadge` (`Animatable` interpolator) for the count-up effect.

---

## 8. Asset Management

### Adding Icons

1. Export from Figma as **PDF** (vector)
2. Drag into `Assets.xcassets` in Xcode
3. Reference by asset name in code

### Adding Images

1. Export from Figma as **PDF** (vector) or **PNG** (raster)
2. Drag into `Assets.xcassets` in Xcode
3. Naming convention: `{FlowName}-{description}` (e.g., `OrderCard-confirmation`)

### Adding Components

1. Create in `DesignSystem/Components/` with `IDS` prefix
2. Use only token values from `IDSColors`, `IDSTypography`, `IDSSpacing`
3. Include a `#Preview` block at the bottom showing **all states/variants**
4. Add the component to `ComponentCatalogView.swift` using the `catalogSection` helper
5. Add the component to this spec

### Component Testing

Two complementary approaches:

- **`#Preview` blocks** (per-component): Each `IDS{Name}.swift` file has a `#Preview` at the bottom showing all states. Use Xcode's canvas for fast iteration — no app launch needed.
- **Component Catalog** (all-at-once): `DesignSystem/ComponentCatalogView.swift` shows every component in a scrollable view. Run the app in Xcode to see all components together in a real device context. This is the default landing screen.

---

## 9. How to Add a New Flow

See **FLOW_TEMPLATE.md** for the complete step-by-step checklist with code templates.
