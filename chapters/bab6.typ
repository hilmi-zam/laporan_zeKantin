= Bab 6: Integrasi & Git Branching

Dikerjakan oleh QA Lead[cite: 42].

== 6.1 Strategi Git Branching

Menggunakan _Git Flow_ dengan 5 branch per member:

- `feature/backend-setup` (Backend Architecture - Member 1)
- `feature/ui-widgets` (UI Components - Member 2)
- `feature/auth-nav` (Firebase Auth & Navigation - Member 3)
- `feature/cart-state` (Cart Logic & Provider - Member 4)
- `feature/testing-docs` (QA & Documentation - Member 5)


== 6.3 Integration Flow

```
Member 1 → Backend ✓
Member 2 → UI ✓
Member 3 → Auth (depends M1) ✓
Member 4 → Cart (depends M1,M2) ✓
Member 5 → Tests (depends All) ✓
```

== 6.7 Repository Stats

Repository: https://github.com/Ghofur102/smart_kantin.git

- 55+ commits
- 4 contributors (Ghofur102, MuhAinulHuda24, hilmi-zam, damput-temp)
- Languages: Dart 61.1%, C++ 19.6%, CMake 15.3%
