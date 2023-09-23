# SnapList
SnapList is a native iOS application developed using UIKit, following the MVVM+C architecture, SOLID principles, and initializer-based Dependency Injection. The application fetches a list of items from a server, allows users to take snapshots, and enables interaction with the server through GET and POST requests.

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Technologies and Libraries](#technologies-and-libraries)
- [Prerequisites](#prerequisites)

## Features
- Fetch and display a list of items from a server.
- Infinite scrolling to load more items.
- Take snapshots and send them to the server with additional information.
- Developed using best practices and principles for maintainability and scalability.

## Architecture
SnapList is developed following the MVVM+C (Model-View-ViewModel + Coordinator) architecture pattern, allowing for clean separation of concerns and easier testing. SOLID principles and initializer-based Dependency Injection are applied throughout the project to ensure high cohesion, low coupling, and increased flexibility.

### Technologies and Libraries
- **UIKit**: For constructing the user interface.
- **Initializer-Based Dependency Injection**: For injecting dependencies without the use of frameworks, enhancing the maintainability and testability of the application.
- **Screen Factories**: For creating instances of each screen, promoting a clean and modular architecture.
- **URLSession**: For handling API requests.

## Prerequisites
- Xcode 14.2
- iOS 13+
