# CredyNox

Modern fintech dashboard built with Flutter using a scalable architecture focused on:

- clean UI,
- responsive layouts,
- modular architecture,
- realtime-ready infrastructure,
- premium fintech experience.

Inspired by products like:

- Stripe
- Linear
- Raycast
- Vercel

---

# Tech Stack

- Flutter
- Riverpod
- GoRouter
- Material 3
- flutter_animate
- Google Fonts

---

# Current Status

Current implementation focuses on the frontend foundation and scalable architecture.

## Implemented

- responsive dashboard
- premium dark theme
- navigation system
- reusable UI system
- animated transitions
- adaptive desktop/mobile layouts
- modular dashboard widgets
- risk monitoring UI
- analytics placeholders
- timeline activity feed

## Not Implemented Yet

- backend integration
- financial logic
- authentication
- realtime services
- API connections
- AI/risk engines

---

# Project Structure

```txt
lib/
├── core/
│   ├── config/
│   ├── helpers/
│   ├── router/
│   └── theme/
│
├── frontend/
│   ├── layouts/
│   ├── screens/
│   │   └── dashboard/
│   │       ├── presentation/
│   │       └── widgets/
│   └── widgets/
│
├── providers/
├── services/
├── models/
└── main.dart
```

---

# Architecture

The project follows a modular and scalable approach.

Each feature is separated into:

```txt
feature/
├── presentation/
├── widgets/
├── controllers/
├── providers/
└── services/
```

This allows:

- clean separation of concerns
- easier scaling
- reusable components
- future backend integration
- realtime-ready architecture

---

# UI System

CredyNox uses a custom design system based on:

- dark premium surfaces
- cyan/violet gradients
- adaptive cards
- hover effects
- glow effects
- Material 3

## Core Reusable Widgets

- `NxCard`
- `NxCardHeader`
- `NxDivider`

---

# Routing

Navigation is powered by GoRouter.

## Current Routes

| Route | Description |
|---|---|
| `/` | Splash screen |
| `/connect-bank` | Bank connection flow |
| `/dashboard` | Main dashboard |

---

# Responsive Design

The dashboard adapts automatically for:

- mobile
- tablet
- desktop
- web

Responsive behavior includes:

- adaptive spacing
- dynamic layouts
- wrap-based metrics
- desktop navigation shell
- scalable cards

---

# Dashboard Modules

## Financial Overview

Displays:

- available balance
- liquidity status
- automation state

---

## Timeline

Mock realtime activity feed.

Prepared for future:

- transaction streams
- notifications
- automation logs

---

## Analytics

Placeholder analytics section.

Prepared for future:

- charts
- financial predictions
- spending analytics
- AI insights

---

## Risk Monitoring

Mock risk engine interface.

Prepared for future integrations:

- risk scoring
- anomaly detection
- liquidity exposure
- predictive analytics

---

# Running the Project

## 1. Install dependencies

```bash
flutter pub get
```

---

## 2. Run the application

### Mobile

```bash
flutter run
```

### Web

```bash
flutter run -d chrome
```

### Desktop

```bash
flutter run -d windows
```

or

```bash
flutter run -d macos
```

---

# Development Notes

Currently all dashboard data is mocked.

Widgets already contain comments indicating where:

- controllers,
- providers,
- services

will connect in future stages.

Example:

```dart
// TODO(controller):
// Replace mock data with realtime provider data.
```

---

# Next Steps

Planned roadmap:

- Firebase integration
- authentication
- bank APIs
- realtime sync
- AI financial analysis
- transaction engine
- predictive risk models
- advanced analytics
- notifications
- automation workflows

---

# Design Philosophy

CredyNox focuses on:

- clarity
- speed
- modern fintech aesthetics
- scalability
- minimal but powerful interfaces

The UI is intentionally built to feel:

- futuristic,
- intelligent,
- premium,
- realtime-ready.