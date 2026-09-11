# TutorConnect (Flutter)

A Flutter port of the TutorConnect high-fidelity prototype (originally built as a
Figma Make React/TypeScript app) — a mobile app for university students to find a
tutor, book a session, and manage their bookings.

## Getting started

```bash
flutter pub get
flutter run
```

Open the project in Android Studio and run it on an Android emulator (or any
connected device) via **Run ▸ Run 'main.dart'**, or from the command line with
`flutter run` while an emulator is booted.

> **Note on fonts/icons:** this project uses the `google_fonts` package (Outfit +
> Inter, matching the original design) and the `lucide_icons` package (matching
> the original's Lucide/Feather icon set). Both fetch their assets automatically
> on first build — make sure the emulator/device has internet access the first
> time you run the app so fonts can download and cache.

## Architecture

- **State management:** [Riverpod](https://riverpod.dev) (`flutter_riverpod`)
- **Routing:** [go_router](https://pub.dev/packages/go_router), with one route per
  original screen (see `lib/routing/route_paths.dart`)
- **Structure:** feature-first —
  - `lib/core/` — design system (colors, typography, spacing) and shared widgets
    (`PrimaryButton`, `SecondaryButton`, `Avatar`, `TutorCard`, `TopNavBar`,
    `BottomNavBar`, etc.)
  - `lib/models/` — `Tutor`, `Booking`
  - `lib/data/` — mock dataset + repositories (`TutorRepository`,
    `BookingRepository`) — the only place that would need to change to plug in a
    real backend later
  - `lib/features/<screen>/` — one folder per screen area
- **Responsiveness:** `MaxWidthContainer` centers and caps content width on
  tablets/large screens while staying fluid edge-to-edge on phones, mirroring the
  original design's 430px mobile-frame convention without hardcoding it.

## What's implemented vs. not (per the Assessment 4 brief)

**Fully implemented (Tier 1):**
1. **Tutor Discovery** — Find Tutor's subject chips and search field carry real
   state; Search Results genuinely filters the tutor list against them (see
   `TutorRepository.search`).
2. **End-to-end Booking flow** — Tutor Profile → Select Date/Time → Booking
   Summary → Booking Success → the booking is actually created in shared app
   state (`BookingsNotifier`) and appears in My Bookings → Booking Details →
   Cancel actually removes it.

**Built as navigable UI only, not functionally implemented (documented per the
brief's requirement to state what's remaining):**
- **Sign In** — no real authentication/validation; "Sign In" proceeds directly
  to Home.
- **Profile** menu items (Edit Profile, My Subjects, Notifications, Help &
  Support) — decorative rows with no destination screens, matching the original
  source. "Sign Out" is wired and returns to Welcome.
- **Message Tutor** (on Booking Details) — no handler, matching the original
  source; messaging is out of scope for a front-end-only assessment.

## Known limitations of this sandbox-produced build

This project was generated without access to a Flutter SDK/Android toolchain, so
it has **not** been run through `flutter analyze`, `flutter pub get`, or an actual
emulator build in the environment that produced it. Everything was written
carefully against Flutter/Dart 3 syntax and cross-checked by hand, but please run
`flutter analyze` after `flutter pub get` as your first step, and treat any
remaining warnings (e.g. an icon name in `lucide_icons` that shifted between
package versions) as quick fixes rather than a sign of a deeper problem.
