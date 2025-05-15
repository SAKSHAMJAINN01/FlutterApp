Task Manager Flutter App
A Flutter app for managing tasks with Create, Read, Update, Delete (CRUD) operations, built using the BLoC pattern, SQLite for local storage, and RESTful API integration with jsonplaceholder.typicode.com.
Setup Instructions
Prerequisites

Flutter SDK: Version 3.16 or later
Dart: Version 3.2 or later
Environment: macOS with Xcode (iOS simulator), Android Studio (Android emulator), or Chrome (web)
VS Code: Recommended with Flutter extension

Installation

Clone Repository (if hosted):
git clone <repository-url>
cd task_manager

Or unzip the provided project archive.

Install Dependencies:
flutter pub get


Configure macOS Network Permissions (for macOS/iOS simulator):

Edit macos/Runner/DebugProfile.entitlements and macos/Runner/Release.entitlements:<key>com.apple.security.network.client</key>
<true/>


Ensure macOS firewall allows outgoing connections:sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off

Re-enable after testing:sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on




Run the App:

iOS simulator (e.g., iPhone 16):flutter run -d "iPhone 16"


Web:flutter run -d chrome


macOS desktop:flutter run -d macos


List available devices:flutter devices


Note: If iPhone 16 is unavailable, use another simulator (e.g., iPad Pro) or chrome. The Mac Designed for iPad simulator is not supported.



API Endpoints
The app integrates with a mock RESTful API provided by jsonplaceholder.typicode.com.

Base URL: https://jsonplaceholder.typicode.com
Endpoints:
GET /todos: Fetch all tasks
POST /todos: Create a task (simulated)
PUT /todos/:id: Update a task (simulated)
DELETE /todos/:id: Delete a task (simulated)


Note: The API is mocked; updates and deletions are not persisted server-side.

Usage Instructions

View Tasks: Tasks are displayed in a ListView with details (title, description, status, priority, creation date).
Add Task: Tap the Floating Action Button (+), fill the form (title, description, status, priority), and tap “Add Task”.
Edit Task: Tap the edit icon (pencil) on a task, modify fields, and tap “Update Task”.
Delete Task: Swipe a task left or right to delete, with a snackbar confirmation.
Delete All Tasks: Tap the “Delete All” icon (trash can) in the AppBar, confirm via dialog.
Refresh Tasks: Tap the refresh icon to reload tasks from API (online) or SQLite (offline).
Offline Mode: Tasks are cached in SQLite; the app works offline, falling back to local data if the API is unavailable.

Architecture Overview
The app follows a layered architecture to ensure separation of concerns, maintainability, and adherence to Flutter best practices:

Data Layer:

Models: models/task.dart defines the Task model with fields (id, title, description, status, createdDate, priority). Includes JSON serialization (toMap, fromMap) for API and SQLite compatibility.
Services:
services/databases_service.dart: Manages SQLite database using the sqflite package. Implements CRUD operations (createTask, readAllTasks, updateTask, deleteTask, deleteAllTasks) with a tasks table.
services/api_service.dart: Handles HTTP requests using the http package to interact with jsonplaceholder.typicode.com. Maps API responses to Task objects.


Repositories: repositories/task_repository.dart implements the repository pattern, abstracting data sources (API and SQLite). It prioritizes API data when online, falling back to SQLite when offline or on API failure.


Business Logic Layer:

blocs/task/*: Uses the flutter_bloc package for state management:
task_bloc.dart: Processes events (LoadTasks, AddTask, UpdateTask, DeleteTask, DeleteAllTasks) and emits states (TaskInitial, TaskLoading, TaskLoaded, TaskError).
task_event.dart: Defines event classes for user actions.
task_state.dart: Defines state classes for UI updates.


Ensures reactive, predictable state changes, decoupling logic from presentation.


Presentation Layer:

screens/task_list_screen.dart: Displays tasks in a ListView with Dismissible widgets for swipe-to-delete, AppBar actions (refresh, delete all), and a FloatingActionButton.
screens/add_edit_task_screen.dart: Form for adding/editing tasks with TextFormField and DropdownButtonFormField for validation.
main.dart: Initializes the app, sets up TaskBloc, and configures MaterialApp with Material 3 theme.


Key Features:

State Management: BLoC ensures reactive UI updates.
Offline Support: SQLite caching for offline functionality.
Error Handling: API/database errors emit TaskError states, shown as snackbars.
User Feedback: Snackbars for actions, dialogs for “Delete All”.
Responsive UI: Basic mobile-optimized layout with ListView and forms.


Design Patterns:

Repository pattern for data abstraction.
Singleton pattern in databases_service.dart.
BLoC pattern for state management.



Testing Information
Manual testing ensures functionality, reliability, and user experience:
Manual Testing

CRUD Operations:
Create: Add task via +, verify in ListView and SQLite (SELECT * FROM tasks).
Read: Load tasks from API (online) or SQLite (offline), confirm display.
Update: Edit task, verify UI and database changes.
Delete: Swipe to delete, confirm snackbar and database update.
Delete All: Use “Delete All”, confirm dialog, verify empty list/database.


Offline Mode:
Disable Wi-Fi, verify SQLite task loading.
Re-enable Wi-Fi, confirm API sync.


Error Handling:
Set api_service.dart’s baseUrl to http://invalid, verify error snackbar, revert to https://jsonplaceholder.typicode.com.
Test database errors (e.g., invalid table), confirm fallback behavior.


UI/UX:
Test on iOS simulator (e.g., iPhone 16), Chrome, or macOS desktop.
Verify form validation, navigation, snackbar/dialog visibility.
Check responsiveness on mobile/web.


Edge Cases:
Empty task list shows “No tasks found”.
Rapid task additions/deletions handled by BLoC.
Network toggling maintains data consistency.



Unit Tests

Status: Not implemented due to time constraints.
Recommendations:
Add tests in test/ using flutter_test:
Task serialization (toMap, fromMap).
TaskBloc event-to-state transitions.
TaskRepository API/SQLite switching.


Use mockito for mocking ApiService and DatabaseService.



Testing Tools

SQLite Inspection:find ~/Library/Developer/CoreSimulator -name tasks.db
sqlite3 <path-to-tasks.db>
SELECT * FROM tasks;


API Verification:curl https://jsonplaceholder.typicode.com/todos


Logs:flutter logs > logs.txt



Known Limitations

Mock API does not persist changes.
Basic responsiveness (mobile-optimized, no tablet layouts).
No API retry logic.
No search, sorting, or themes.

Future Improvements

Add search with debounce.
Implement sorting by priority/date.
Enhance tablet/landscape responsiveness.
Add API retry with http_retry.
Support dark/light themes.

Notes

Configure macOS network permissions to avoid SocketException.
SQLite database (tasks.db) persists tasks locally.

