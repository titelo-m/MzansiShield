# MzansiShield
A cybersecurity web and mobile application that analyzes URLs and messages to identify suspicious links and potential phishing attacks before users access them.

Built with Flutter and Spring Boot, MzansiShield is designed specifically for South Africa, with full support for all 11 official languages to make digital safety accessible to everyone.

## About The Project
MzansiShield is a community-powered cybersecurity platform that empowers everyday South Africans to identify phishing attacks, verify suspicious links, check password strength, and report scams in their own language.

The project supports all 11 official South African languages, ensuring that digital safety tools are available to every South African regardless of their home language.

## Features

### Link and Message Checker
Paste any suspicious link, email, or WhatsApp message and get an instant risk analysis with a detailed explanation of why it may be dangerous and what action to take.

### Password Strength Checker
Test your password in real-time with a live strength meter, a checklist of security criteria, a strong password generator, and a one-click copy button.

### Cyber Safety Tips
A curated library of practical, South African-specific safety advice covering:
- SARS phishing scams
- Banking fraud (FNB, Standard Bank, ABSA, Nedbank)
- WhatsApp job scams
- Lottery and prize scams
- Emergency contact numbers (SAPS, SABRIC, National Anti-Fraud Hotline)

### Community Scam Reporting
A community-driven scam reporting system where users can:
- Report a suspicious URL, phone number, or email
- View reports submitted by others
- Verify or flag reports to help increase the confidence score of genuine threats

### Multilingual Support
The entire application is fully translated into all 11 official South African languages:

| Language | Native Name |
|----------|-------------|
| English | English |
| Afrikaans | Afrikaans |
| Zulu | isiZulu |
| Xhosa | isiXhosa |
| Northern Sotho | Sepedi |
| Southern Sotho | Sesotho |
| Tswana | Setswana |
| Swati | siSwati |
| Venda | Tshivenda |
| Tsonga | Xitsonga |
| Southern Ndebele | isiNdebele |

---

## Tech Stack

### Frontend
| Technology | Purpose |
|------------|---------|
| Flutter 3.x | Cross-platform UI framework |
| BLoC (flutter_bloc) | State management |
| GoRouter | Declarative routing |
| Google Fonts | Typography (Inter, Montserrat) |
| Flutter Localizations | Multi-language support |

### Backend (Planned)
| Technology | Purpose |
|------------|---------|
| Java 17 | Backend language |
| Spring Boot 3.x | REST API framework |
| Spring Data JPA | Database access |
| MySQL | Relational database |
| Google Safe Browsing API | Real-time threat intelligence |
| Hugging Face Transformers | NLP-based message analysis |

---

## Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK
- Linux, macOS, Windows, or Chrome (for web)

### Installation
git clone https://github.com/titelo-m/MzansiShield.git
cd MzansiShield
flutter pub get
flutter run -d linux

## You can also run on other platforms:
flutter run -d chrome # Web browser
flutter run -d android # Android device
flutter run -d windows # Windows desktop

## Contributing
This project is currently in active development. Contributions, suggestions and bug reports are welcome. Feel free to open an issue or submit a pull request.

## Author
**Titelo Maleka**
- GitHub: [@titelo-m](https://github.com/titelo-m)

Made in South Africa, for South Africa.

Stay Safe Online.
