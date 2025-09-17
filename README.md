📖 Reader App 

An iOS news reader application that fetches, displays, and caches articles using the [NewsAPI](https://newsapi.org/).
The app supports **offline viewing**, **search**, **bookmarks**, and a clean **MVVM architecture**.

---

## ✨ Features

- **Fetch Articles**
  - Articles fetched from NewsAPI (`URLSession` / `Alamofire`).
  - Displays article **title, author, and thumbnail**.

- **Offline Caching**
  - Stores articles in **Core Data**.
  - Automatically loads cached data when offline.

- **Pull-to-Refresh**
  - Quickly refresh articles with `UIRefreshControl`.

- **Search**
  - Search bar to filter articles by title in real-time.

- **Bookmarks (Bonus)**
  - Bookmark articles via a button in the article cell.
  - Dedicated **Bookmarks Tab** to view saved articles.

---

## 🏛 Architecture

- **MVVM (Model-View-ViewModel)** pattern
  - `ArticlesViewController` → Displays list of articles.
  - `ArticlesViewModel` → Handles fetching, caching, searching, and bookmarking.
  - `ArticleService` → Networking layer using **Alamofire**.
  - `CoreDataStack` → Persistent caching for offline support.

---
