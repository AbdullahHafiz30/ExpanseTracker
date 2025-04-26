# 🚀 ExpensesMonthlyProjrct: Your Comprehensive Finance Manager

## 🎬 App Video

See the app in action! [https://drive.google.com/file/d/1PVhnK_MpfuIiNwcOo_PoWg4w91tFbXqF/view?usp=sharing](https://drive.google.com/file/d/1PVhnK_MpfuIiNwcOo_PoWg4w91tFbXqF/view?usp=sharing)

## ✨ Overview

ExpensesMonthlyProjrct is a meticulously crafted iOS application, built with the modern declarative power of SwiftUI, designed to empower you in taking control of your financial life. Seamlessly manage your monthly expenses by setting intelligent budgets and effortlessly tracking every penny spent. Our application goes beyond simple tracking, offering a rich suite of features including the ability to establish recurring budgets, categorize your spending for insightful analysis, and personalize your experience with customizable themes and language options. Security and data integrity are paramount, with robust user authentication handled by Firebase and efficient local data persistence managed by Core Data.

## 🌟 Key Features: Finance at Your Fingertips

* **💰 Smart Budgeting:** Set clear monthly financial boundaries to stay on track.
* **📊 Real-time Spending Tracking:** Visualize your current expenditures against your allocated budget at a glance.
* **🔄 Recurring Budgets:** Automate your monthly budgeting for consistent financial planning.
* **🏷️ Intelligent Category Management:** Create, view, and edit expense categories to gain deeper insights into your spending habits.
    * **🎨 Customizable Categories:** Personalize categories with unique icons and colors.
    * **🎯 Budget Limits per Category:** Set specific spending limits for individual categories.
* **👤 Secure Account Management:** View and modify your profile information, securely log out, and even delete your account with ease.
* **🎨 Personalized Theme Customization:** Choose between elegant light and immersive dark mode to match your preference.
* **🌐 Seamless Language Support:** Experience the app in your preferred language, with full localization for both English and Arabic.
* **🔔 Timely Notifications:** Opt-in for monthly budget reminders to stay informed and proactive.
* **💾 Robust Data Persistence:** Rely on Core Data for fast and reliable local data storage, complemented by Firebase for secure user authentication.
* **🧾 Comprehensive Transaction Management:** A dedicated module for managing all your financial transactions effectively.
    * **✍️ Effortless Add/Edit:** Quickly input new transactions or modify existing ones.
    * **🔍 Powerful Filtering:** Analyze your spending by type (income/expense) and time period.
    * **🌍 Localized Interface:** Enjoy a fully localized user experience.
    * **🌗 Adaptive Theming:** Experience a consistent look and feel in both light and dark modes.
    * **📸 Receipt Image Support:** Attach images of your receipts using Base64 encoding for detailed records.
    * **📂 Organized Categories:** Assign categories to transactions for accurate tracking.
    * **♿ Accessibility Focused:** Designed with accessibility in mind for all users.
* **📈 Insightful Expense Tracking (ExpanseTracker Module):** A versatile module for comprehensive expense management.
    * **📝 Detailed Transaction Logs:** Add, edit, and review all your financial transactions.
    * **🔒 Secure User Authentication:** Benefit from secure sign-up, login, and logout functionalities.
    * **🖼️ Image Attachment Capability:** Add visual context to your transactions by attaching images.
    * **📅 Intuitive Date Handling:** Select transaction dates with a user-friendly custom date picker.
    * **📸 Flexible Image Source:** Choose images from your device's camera or photo gallery.
* **📊 Visual Expense Statistics (ExpanseTracker Charts Module):** Transform your financial data into insightful visualizations.
    * **🍩 Informative Pie Charts:** Understand your expense breakdown at a glance.
    * **📊 Clear Bar Charts:** Compare expenses across different categories or time periods.
    * **📈 Dynamic Line Charts:** Track your daily running balance over time.
    * **⚙️ Dynamic Filtering:** Analyze specific data sets by date range and category.
    * **🌍 Localized Charts:** Experience charts with labels and legends in your chosen language.

## 📂 Project Structure: Organized for Clarity

This project is thoughtfully structured to ensure maintainability and scalability. Key files include:

1.  **BudgetViewModel.swift:** The brain behind budget management, handling creation, saving, recurring logic, updates, fetching, and deletion of budget data. It also calculates monthly spending and validates budget inputs.

2.  **SetBudget.swift:** A user-friendly SwiftUI view that allows setting or modifying the monthly budget, interacting with `BudgetViewModel` and prompting for recurring budget options with input validation.

3.  **Profile.swift:** Your personal hub for app settings, displaying user information, current budget, spending, theme options, notification controls, language selection, and account management features (edit, logout, delete).

4.  **ViwAndEditAccountInformation.swift:** A dedicated SwiftUI view for viewing and modifying user account details, including name, email, and profile picture, powered by `ViwAndEditAccountInformationViewModel`.

5.  **ViwAndEditAccountInformationViewModel.swift:** The engine for the `ViwAndEditAccountInformation.swift` view, responsible for loading and managing user data from Core Data.

6.  **CategoryFunctionallity.swift:** A versatile SwiftUI view for managing expense categories, allowing users to add, edit, and view categories with customizable properties, driven by `CategoryFunctionallityViewModel`.

7.  **CategoryFunctionallityViewModel.swift:** The view model for `CategoryFunctionallity.swift`, handling the saving, updating, and retrieval of category data within Core Data.

8.  **AddOrEditTransactionView.swift:** A dynamic form-based view for adding new transactions or editing existing ones, featuring fields for all transaction details and utilizing various custom UI components.

9.  **AddOrEditTransactionViewModel.swift:** The ViewModel driving `AddOrEditTransactionView`, managing form state, validation, data loading, and Core Data operations for transactions and categories.

10. **TransactionViewModel.swift:** Manages the state and filtering logic for displaying transaction lists, including search, type, and time-based filters, as well as calculations for total income/expense.

11. **TransactionCardView.swift:** A compact SwiftUI view displaying key transaction details with a themed visual style and an edit option.

12. **DetailsHomeView.swift:** A read-only SwiftUI view showcasing comprehensive transaction details, including receipt image display.

13. **SwipeAction.swift:** A reusable SwiftUI container enabling contextual swipe actions (like delete or edit) with customizable styling and animation.

14. **CustomText.swift:** A styled SwiftUI component for displaying read-only text with a label, used throughout forms and summaries.

15. **PriceSection.swift:** A SwiftUI view for displaying and editing amounts with currency icons and validation handling.

16. **SelectedTransactionType.swift:** A styled SwiftUI capsule displaying the selected transaction type.

17. **TransactionTypeSelector.swift:** A fully localized and themed segmented control for selecting transaction types.

18. **ImageSourcePickerView.swift:** A SwiftUI view presenting options to choose an image source (camera or gallery).

19. **AuthViewModel.swift:** The core of user authentication, handling sign-up, login, logout, and session management using Firebase.

20. **WelcomePage.swift:** The initial SwiftUI welcome screen with the app logo and navigation to login/signup.

21. **LogInPage.swift:** The SwiftUI login interface, allowing users to securely log in using `AuthViewModel`.

22. **SignUpPage.swift:** The SwiftUI sign-up interface, enabling new users to create accounts via `AuthViewModel`.

23.  **CategoryView.swift:** A SwiftUI view displaying a scrollable list of user-defined categories with dynamic theming, search, type filtering, and localization support.

24.  **CategoryRow.swift:** A SwiftUI view representing an individual category within the `CategoryView` list.

25.  **ListOfSpecificCategoryView.swift:** A SwiftUI view designed to display transactions associated with a selected category.

26.  **Category.swift:** A model struct defining the properties of an expense category.

27.  **CategoryEntity.xcdatamodeld:** The Core Data model defining the structure for category data.

28.  **ThemeManager.swift:** A crucial component managing the app's visual theme (light/dark mode) and providing color palettes.

29. **DatePickerField.swift:** A custom SwiftUI view providing a styled text field interface to a graphical calendar picker for date selection.

30. **ImagePickerField.swift:** A custom SwiftUI view facilitating image selection from the gallery or camera, utilizing `ImageSourcePickerView` and `CustomCameraView`.

31. **CustomCameraView.swift:** A SwiftUI view integrating the device's camera functionality using `UIViewControllerRepresentable` for capturing images.

32. **GraphsView.swift:** The main SwiftUI container for displaying different types of expense charts (Pie, Bar, Line) via a segmented control.

33. **PieView.swift:** A SwiftUI view rendering expense data as a visually informative donut chart with a custom legend.

34. **BarView.swift:** A SwiftUI view displaying expense data as a horizontal bar chart with interactive axes and a color-coded legend.

35. **LineView.swift:** A SwiftUI view visualizing the daily running balance over time using a line chart with income/expense differentiation.

36. **GraphsViewHeader.swift:** A SwiftUI header providing filtering options for the charts, including date and category selection.

37. **PieViewModel.swift:** The ViewModel responsible for fetching, filtering, aggregating transaction data, and creating data models for `PieView`.

38. **BarViewModel.swift:** The ViewModel that fetches, filters, and transforms transaction data into the `Bar` data model for `BarView`.

39. **LineViewModel.swift:** The ViewModel that fetches, filters, and calculates the running daily balance to generate data for `LineView`.

40. **Transaction:** A plain Swift model representing a transaction, used across all chart view models.

41. **Test:** The data model specifically for the `PieView`, containing information for each slice.

42. **Bar:** The data model for the `BarView`, representing each bar in the chart.

43. **DailyBalance:** The data model for the `LineView`, containing date and balance information for each point on the line.

## 🛠️ Technologies Used: The Power Under the Hood

* **SwiftUI:** The modern and declarative UI framework for building native iOS applications.
* **Core Data:** Apple's robust framework for managing application data persistently.
* **Firebase:** Google's comprehensive platform for mobile and web development, used here for secure user authentication.
* **Combine:** Apple's reactive programming framework, implicitly used through SwiftUI's state management.
* **Localization:** Apple's framework for adapting the app to different languages and regions.
* **AVFoundation:** Apple's framework for working with audio and video data, used for camera integration.
* **PhotosUI:** Apple's framework for providing a modern interface for selecting photos and videos from the user's library.
* **`@AppStorage`:** SwiftUI property wrapper to easily persist simple data in UserDefaults, used for language preferences.
* **Namespace & `MatchedGeometryEffect`:** SwiftUI tools for creating smooth and visually connected animations, used for filter transitions.
* **`EnvironmentObject`:** SwiftUI mechanism for sharing data across the view hierarchy, used for `ThemeManager` and potentially `PersistanceController`.
* **Swift Charts:** Apple's powerful framework for creating a wide variety of data visualizations.

## 🌍 Localization: Speaking Your Language

Our app embraces a global audience with seamless support for:

* **English (`en`)**
* **Arabic (`ar`)**

The app automatically adapts the layout direction (LTR or RTL) based on the selected language. We utilize the `.localized(using: currentLanguage)` extension for all user-facing strings, ensuring a truly native experience.

## 🧪 How to Test: Get Hands-On

1.  **Run the App:** Build and run the `ExpensesMonthlyProjrct` in Xcode on a simulator or a physical iOS device.
2.  **Explore Budgeting:** Navigate to the budget setting screen and set a monthly budget. Observe the prompts for recurring budgets.
3.  **Track Spending:** Use the transaction management features to add expenses and see how they reflect against your set budget on the profile screen.
4.  **Manage Categories:** Go to the category management section to add, edit, and delete expense categories. Experiment with different icons, colors, and budget limits.
5.  **Customize Profile:** Adjust the theme between light and dark mode, toggle notifications, and switch between English and Arabic to see the localization in action.
6.  **Manage Account:** Explore the account management options to view your information, log out, and (with caution) delete your account.
7.  **Test Transactions:** Add and edit transactions, paying attention to the various input fields and the image attachment feature. Try filtering transactions by type and date.
8.  **View Charts:** Navigate to the statistics or charts section to see your expense data visualized in pie, bar, and line charts. Interact with the date and category filters to see dynamic updates.
9.  **Swipe Actions:** In lists (like categories or transactions), try swiping left or right to reveal contextual actions like delete or edit.

## 📌 Important Notes

* Ensure that `ThemeManager` and `PersistanceController` are correctly injected into the environment for the app to function as expected.
* The app leverages SwiftUI's `NavigationStack` for modern and efficient navigation between views.
* View models are typically initialized using `@StateObject` to manage their lifecycle and ensure data persistence across view updates.
* For the Charts module, verify that your Core Data setup (`PersistanceController` and the `UserEntity`/`TransacionsEntity` relationships) matches the outlined requirements.

## 👨‍💻 Authors: The Team Behind the Project

**Naif Ghannam Saleh Almutairi**
iOS Developer | Data Scientist | SwiftUI Enthusiast
📧 [https://github.com/NaifGhannam]

**Abdullah Mohammed Hafiz**
iOS Developer | Data Scientist | AI 
📧 [https://github.com/AbdullahHafiz30]

**Rawan Majed Alraddadi**
iOS Developer | SwiftUI Enthusiast
📧 [https://github.com/Rawann0m]

**Rayaheen Taofig Mseri**
IOS Developer | SwiftUI Enthusiast
📧 [https://github.com/RayaheenMseri]

**Tahani Ayman**
IOS Developer | SwiftUI Enthusiast
📧 [https://github.com/Tahani50]


## 📜 License

This project is intended for educational and training purposes. Please refer to the specific license file within the repository for more details.
