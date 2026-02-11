# IDSPlayground

A ready-to-use iOS prototyping starter pack built on the **Instacart Design System (IDS)**. Open it, run it, and start building flows.

---

## What's Included

- **Fonts**: All 16 Instacart Sans font files (Subhead + Text families), pre-registered and ready to use
- **Color tokens**: Every IDS color — brand, grayscale, button, input, vehicle colors
- **Typography tokens**: Headline, title, subtitle, body, accent, and button styles
- **Spacing tokens**: A consistent spacing scale from 0px to 48px
- **Architecture**: MVVM + Flow Coordinators pattern, ready for multi-screen flows
- **Cursor rules**: AI co-pilot instructions that enforce IDS design system usage

---

## Prerequisites

- **Xcode 16+** (free from the Mac App Store)
- **Cursor IDE** (for AI-assisted code generation)

---

## Getting Started

### 1. Open the project

Unzip the folder (if zipped), then double-click **`IDSPlayground.xcodeproj`** to open it in Xcode.

### 2. Run it

Click the **Play button** (triangle icon, top-left of Xcode) or press **Cmd + R**. You should see a screen that says "IDSPlayground — Design system ready."

If the text renders in the correct Instacart Sans font, everything is working.

### 3. Open in Cursor

Open the `IDSPlayground` folder in Cursor. This is where you'll do most of your work — describing what to build, and letting Cursor generate the code.

---

## Adding Your First Flow

1. Open the project folder in **Cursor**
2. Tell Cursor: *"Create a new flow called [YourFlowName] following FLOW_TEMPLATE.md"*
3. Cursor will create the folder structure, ViewModel, Flow coordinator, and screen views
4. Run in Xcode to preview

See **FLOW_TEMPLATE.md** for the full step-by-step guide.

---

## Adding Image

Same process as icons:

1. Export from **Figma** as **PDF** (vector) or **PNG** (raster)
2. Drag into **Assets.xcassets** in Xcode
3. Use a clear naming convention: `{FlowName}-{description}` (e.g., `OrderCard-confirmation`)
4. Tell Cursor the asset name

---

## Customizing the App

### Change the app display name

1. In Xcode, open **IDSPlayground/Info.plist** in the left sidebar
2. Find `CFBundleDisplayName`
3. Change `IDSPlayground` to your preferred name

### Change the bundle identifier

1. In Xcode, click the **IDSPlayground** project (blue icon) in the left sidebar
2. Select the **IDSPlayground** target
3. In the **General** tab, find **Bundle Identifier**
4. Change `com.instacart.IDSPlayground` to your own

---

## Troubleshooting

**Fonts look wrong (system font instead of Instacart Sans)**
- In Xcode: **Product > Clean Build Folder** (Cmd + Shift + K), then run again

**"File not found" errors**
- Make sure the file is inside the `IDSPlayground/` source folder (not at the project root)
- Xcode's file system sync automatically picks up files in this folder

**Preview not updating**
- In Xcode: **Editor > Canvas > Refresh All Previews** (Cmd + Option + P)

---

## Project References

- **SPEC.md** — Design system reference (tokens, architecture, terminology)
- **FLOW_TEMPLATE.md** — Step-by-step guide for adding new flows
- **.cursor/rules/idsplayground.mdc** — Cursor AI rules (design enforcement, conventions)
