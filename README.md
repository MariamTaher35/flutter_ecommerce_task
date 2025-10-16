# 🛍️ Flutter E-Commerce Task  
**Flutter E-Commerce Assignment Project**

A modern, responsive e-commerce application built with **Flutter**, featuring **clean architecture**, **real API integration**, and **real-time state management** using **Riverpod**.  
It showcases category browsing, product display, and a dynamic cart management experience.

---

## 🚀 Setup Instructions

Follow these steps to get the project up and running on your local environment.

### 🧩 Prerequisites
- **Flutter SDK:** Ensure the latest stable version is installed.
- **Dart SDK:** Included with Flutter.
- **Code Editor:** VS Code or Android Studio with Flutter & Dart extensions installed.
- **Android SDK 34** (or later).

---

### ⚙️ Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/MariamTaher35/flutter_ecommerce_task.git
   cd flutter_ecommerce_task
Install Dependencies
Run the following to install required packages:

bash
Copy code
flutter pub get
Run the App
Start an emulator or connect a physical device, then:

bash
Copy code
flutter run
🌐 API Endpoints Used
This app uses the Fake Store API for fetching product and category data.

Feature	Endpoint	Method
Get all products	https://fakestoreapi.com/products	GET
Get all categories	https://fakestoreapi.com/products/categories	GET
Get products by category	https://fakestoreapi.com/products/category/{category_name}	GET

Error handling is implemented for network failures and invalid URLs.

🧭 App Architecture & Folder Structure
This project follows a clean, layered architecture for maintainability and scalability.

perl
Copy code
lib/
├── core/
│   ├── constants/                # App constants, e.g. image paths, colors
│   └── utils/                    # Common utility functions
│
├── data/
│   ├── models/
│   │   └── product.dart          # Data model for Product fetched from the API
│   └── services/
│       └── api_service.dart      # Handles HTTP requests using the http package
│
├── state/
│   ├── products_provider.dart    # Manages fetching, caching & filtering of products
│   ├── categories_provider.dart  # Handles category fetching and selection
│   └── cart_notifier.dart        # Controls cart logic: add/remove/update quantity & total
│
├── ui/
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart  # Displays banners, categories, and product grid
│   │   ├── cart/
│   │   │   └── cart_screen.dart  # Shopping cart UI (add/remove/total)
│   │   ├── favorites/
│   │   │   └── favorites_screen.dart  # Placeholder for favorites feature
│   │   └── profile/
│   │       └── profile_screen.dart    # Placeholder for user profile feature
│   │
│   └── widgets/
│       ├── banner.dart           # Reusable SaleBanner widget
│       ├── categories_strip.dart # Horizontal scrollable category list
│       ├── product_card.dart     # Product tile widget for grid display
│       └── location_bar.dart     # Mock location bar widget
│
└── main.dart                     # App entry point (MaterialApp + ProviderScope)
🧠 State Management: Riverpod
The application uses Flutter Riverpod for predictable and testable state management.

🔹 Why Riverpod?
Type-safe and compile-time checked

No BuildContext dependency

Easier to test and mock

Automatic updates when data changes

Centralized state for API and UI synchronization

🔹 Implementation Details
1️⃣ Product Fetching & Filtering
Implemented via products_provider.dart using FutureProvider.

Fetches data asynchronously from https://fakestoreapi.com/products.

Supports filtering by category through filteredProductsProvider.

Handles loading and error states gracefully using Riverpod’s AsyncValue.

2️⃣ Categories Handling
Defined in categories_provider.dart.

Fetches category list via https://fakestoreapi.com/products/categories.

Provides selected category state to filter displayed products dynamically.

UI uses a horizontally scrollable CategoriesStrip widget.

3️⃣ Cart Management
Managed by CartNotifier (in cart_notifier.dart) via StateNotifierProvider.

State contains a list of CartItem objects (product + quantity + price).

Users can:

Add products from HomeScreen

Remove products from CartScreen

Increment/decrement quantity

Total price automatically recalculates on every state change.

4️⃣ UI Reactivity
All screens listen to providers via ref.watch() for automatic rebuilds.

ref.read() is used for one-time actions (like adding to cart).

Shimmer loaders are shown during async data fetching.

💅 UI & Features Overview
🏠 Home Screen
App bar with logo and icons

Horizontal banner carousel (SaleBanner widgets)

Category strip fetched from API

Responsive product grid using GridView.builder

Add-to-cart buttons integrated with CartNotifier

🛒 Cart Screen
Displays all added products with quantity control

Shows product image, title, price, and subtotal

Updates total price dynamically

Includes “Checkout” simulation button

✨ Additional Features
Responsive layout (2 or 3 columns based on screen width)

Modern Material 3 look and feel

Centralized theme and asset management

Error handling and retry on network failures

🧩 Technologies Used
Category	Package	Purpose
State Management	flutter_riverpod	Reactive global state handling
HTTP Requests	http	API communication
UI Caching	cached_network_image	Smooth image loading
Loading Effects	shimmer	Skeleton UI placeholders
Fonts	google_fonts	Custom typography

📘 State Flow Summary
text
Copy code
UI (HomeScreen) ──► ProductsProvider (API fetch)
              └──► CartNotifier (user actions)
CartNotifier ──► updates CartState
Riverpod rebuilds UI widgets with new state
