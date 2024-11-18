# Task Manager iOS App

This project is a case study implementation of a **Swift-based iOS app** for managing tasks and to-dos efficiently. It includes core features such as task management, offline support, and optional user authentication. The app ensures smooth functionality, even with large datasets, and adheres to best practices for code quality and maintainability.

---

## Features

### 1. **Task Management**
- Add, edit, and delete tasks.
- Mark tasks as complete or incomplete.
- Display detailed task information, including:
  - Title
  - Description
  - Due date
  - Priority level (Low, Medium, High)
 
  - ## Preview



## Screenshots


### 2. **Offline Support**
- Local data persistence is implemented using **Core Data**.
- Offline tasks are stored locally and synchronized with **Firebase** when an internet connection is available.

### 3. **User Authentication (Optional)**
- Secure user login and signup features using **Firebase Authentication**.
- Enables access to tasks across multiple devices.

### 4. **User Interface**
- Responsive and visually simple design.
- Smooth transitions and animations for better user experience.
- Optimized for performance when managing large datasets.

---

## Technical Details

### **Architecture**
- Follows the **MVVM** (Model-View-ViewModel) pattern for better maintainability and scalability.
- Clear separation of concerns for modular code.

### **Tech Stack**
- **Swift**: Core language for app development.
- **Core Data**: For offline storage and data persistence.
- **Firebase**: For real-time database sync and user authentication.
  - **Firebase Realtime Database**: Syncs tasks across devices.
  - **Firebase Authentication**: Secure login and signup.

### **Key Functionalities**
1. **Offline and Online Data Sync**
   - Tasks are stored locally using Core Data.
   - Changes are synced to Firebase when connectivity is restored.

2. **Task Details Screen**
   - Allows viewing and editing of task details.
   - Supports inline animations for better interactivity.

3. **Error Handling**
   - Robust error handling for API calls, data sync, and offline mode.

4. **Performance Optimization**
   - Efficient Core Data queries and batch updates.
   - Asynchronous Firebase calls to avoid blocking the main thread.

---

## How to Run the App

### **Prerequisites**
1. Xcode 13 or above installed on your Mac.
2. Swift 5.x environment.
3. A Firebase project set up with:
   - Realtime Database.
   - Authentication.

### **Setup Instructions**
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the project in Xcode:
   ```bash
   open TaskManager.xcodeproj
   ```
3. Add your **GoogleService-Info.plist** file to the project. (Download this from your Firebase console.)
4. Build and run the project on a simulator or a physical device.

---

## Key Highlights for Review

- **Code Readability and Comments**: The codebase is well-commented for easier understanding.
- **Scalability**: Designed with future scalability in mind (e.g., integration with third-party APIs).
- **Animations**: Subtle animations enhance the overall user experience.
- **Best Practices**: Adheres to Swift and iOS development best practices for readability and maintainability.

## Future Improvements
- **Push Notifications**: Notify users of upcoming tasks or due dates.
- **Search and Filter**: Add advanced filtering and search options.
- **Dark Mode**: Enhance UI with support for dark mode.

---

## Conclusion

This project demonstrates the ability to design and implement a robust task management app with a clean, scalable architecture. It highlights the use of **Core Data** for offline persistence and **Firebase** for real-time updates and authentication.

---
