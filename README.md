# TechnicalTaskLvl2
Technical task Lvl 2

## Overview
This task involves creating an iOS application with three screens: **Login**, **Ships List**, and **Ship Information Page**. The project should prioritize a well-structured codebase and self-documenting code.

---

## Project Description

### **Login Screen**
- **UI Components:**
  - Username field
  - Password field
  - "Login" button
  - "Continue as Guest" button
- **Behavior:**
  - Basic email validation (e.g., `example@domain.com`).
  - Simulated login with a 2-3 second delay to mimic a real authentication process.
  - Successfully logging in or continuing as a guest navigates to the **Ships List** screen.

### **Ships List Screen**
- **UI Components:**
  - List of ships with the following details:
    - Ship Image
    - Ship Name
    - Ship Type
    - Built Year
  - Navigation button:
    - **Logged-in users:** "Logout" button, navigates back to the **Login** screen.
    - **Guests:** "Exit" button, shows an alert ("Thank you for trialing this app") and navigates back to the **Login** screen.
- **Features:**
  - Pull-to-refresh functionality.
  - Sorting by ship name in ascending order (case-insensitive).
  - Ability to delete a ship from the database.
  - Tap on a ship to present the **Ship Information Page** modally.

### **Ship Information Page**
- **UI Components:**
  - Ship Image
  - Ship Name
  - Ship Type
  - Built Year
  - Weight (kg)
  - Home Port Information
  - Roles
- **Behavior:**
  - Page is presented modally.

---

## Business Rules

### **Login Screen**
- No API requests for login verification.
- Store validation success data locally.
- Show a loading indicator during login simulation.

### **Ships List Screen**
- Ships should be fetched from the Core Data storage.
- Fetch and update the ship list from the API when:
  - The screen is opened.
  - The internet connection is restored after being offline.
  - Pull-to-refresh is triggered.
- Insert ships from the API response that don’t exist in the database.
- Offline Mode:
  - If offline, display ships from Core Data and show a banner: "No internet connection. You’re in Offline mode."
  - Close the banner automatically when the connection is restored.
- Animate updates to the list when it changes.

### **Ship Information Page**
- Display offline data if there’s no internet connection and show a banner indicating offline mode.

### **General Requirements**
- On app launch, navigate directly to the **Login** screen.

---

## Technical Requirements
- **Database:** Use the native Core Data framework.
- **Architecture:** Choose any suitable architectural pattern.
- **Reactive Programming:** Use RxSwift or Combine.
- **Target Platform:** iOS 15.0+
- **UI Framework:** UIKit (SwiftUI may be used for simple views).
- **Programming Language:** Swift 5.5+
- **Screen Adaptability:** Support all screen sizes and platforms enabled in the project.
- **Version Control:**
  - Use Gitflow workflow.
  - Create pull requests for changes (even without code review).
  - Use the `main` (master) branch as the target for the final PR.
- **Testing:** Add Unit Tests where appropriate.
- **Dependencies:** Avoid third-party libraries (except RxSwift).

---

## Process
- **Start Date:** Tuesday, 17.12.2024
- **Submission Deadline:** Monday, 23.12.2024, 17:00 (Poland time)
  - Open a PR into the `main` branch and share the link in the designated chat.
- **Feedback Date:** Friday, 27.12.2024, 16:00 (Poland time)

---

## Submission Instructions
1. Fork the repository from the starting point: [Repository Link](https://github.com/ValeryVasilevich/TechnicalTaskLvl2).
2. Work on the task in your forked repository.
3. Submit your code via a PR into the `main` branch of your forked repository.
4. Share the PR link in the designated chat for review.

---

## Additional Notes
Feel free to collaborate with your colleagues, Jedi, or Mx during the task. After receiving feedback, you may continue self-learning or start a new iteration based on the feedback provided.

---

## References
- **UI Design Idea:** [Diagrams Link](https://app.diagrams.net/#G1ON6zCgzQ3uiJcxxLeqOGhNa6CvAMuQF-#%7B%22pageId%22%3A%22K0zysptf5qRpLSRb8WfX%22%7D)
- **API Documentation:** [SpaceX API](https://docs.spacexdata.com) (`v4/ships` endpoint)

