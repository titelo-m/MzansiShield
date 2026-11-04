# MzansiShield

A cybersecurity web application that analyzes URLs, messages, and emails to identify suspicious links and potential phishing attacks. Built for South Africa and available in all 11 official languages.

**Live App:** https://mzansishield.vercel.app/

---

## Features

- **Link and Message Checker** – Detects phishing URLs via Google Safe Browsing, plus scam keywords, family impersonation, job scams, PII requests, and urgency tactics in messages.
- **Password Strength Checker** – Live strength meter, security checklist, strong password generator, and copy button.
- **Cyber Safety Tips** – Practical South African scam awareness with emergency contacts.
- **Community Scam Reporting** – Report, view, verify, and flag scams with real-time confidence scoring.
- **Multilingual** – Full support for all 11 official South African languages.
- **Persistent Recent Checks** – Every check is saved to the database and visible across all devices.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter, BLoC, GoRouter |
| Backend | Java 17, Spring Boot 3, Spring Data JPA |
| Database | MySQL (Aiven) |
| Threat Intel | Google Safe Browsing API |
| Hosting | Vercel (frontend), Render (backend), Aiven (database) |

---

## Getting Started

```bash
git clone https://github.com/titelo-m/MzansiShield.git
cd MzansiShield
flutter pub get
flutter run -d linux
