# Hackathon

## App Name: Tempo

### App Tagline: "Plan it. Live it. Remember it."

## App Description: 

Stay on top of your life with Tempo — the all-in-one productivity hub that blends your calendar, journal, to-do list, and event scheduler into one seamless experience. Whether you're tracking tasks, reflecting on your day, or organizing your week, Tempo keeps everything in "tempo" so you can focus on what matters most.

### Purpose: 

Tempo is designed to help users reclaim control of their time, boost daily productivity, and build a more intentional life. By combining essential planning and reflection tools into one unified platform, Tempo enables users to streamline their routines, reduce mental clutter, and stay connected to their goals, events, and personal growth.


### Features:

📆 Smart Calendar Integration:
Easily manage and monitor your schedule. 

✅ Dynamic To-Do Lists:
Organize tasks.

📅 Event Scheduler with Sharing:
Plan events with reocurring scheduling.

📊 Helpful Categorizations:
Allows categorization of tasks and events to allow easy access and organization.

## Screenshots / Important Features:

Main page:



![Main page](https://github.com/user-attachments/assets/f1b16202-464a-48fc-a426-aa64c58ba64d)

Expanded bottom sheet:



![Expanded bottom sheet](https://github.com/user-attachments/assets/241d6e8f-c3cc-4477-acca-d45c30d31f71)

## Requirements:

### Backend: 

#### At least 4 routes (1 must be GET, 1 must be POST, 1 must be DELETE)

## 📚 API Endpoints

### 📅 Events
| Method | Endpoint                  | Description             |
|--------|---------------------------|-------------------------|
| POST   | `/events`                 | Create a new event      |
| GET    | `/events/date/<date>`    | Get events by date      |
| GET    | `/events/<id>`           | Get event by ID         |
| DELETE | `/events/<id>`           | Delete event by ID      |
| PUT    | `/events/<id>`           | Update event by ID      |

### ✅ Todo (Task)
| Method | Endpoint                  | Description             |
|--------|---------------------------|-------------------------|
| POST   | `/todos`                  | Create a new task       |
| GET    | `/todos/date/<date>`     | Get tasks by date       |
| GET    | `/todos/<id>`            | Get task by ID          |
| DELETE | `/todos/<id>`            | Delete task by ID       |
| PUT    | `/todos/<id>`            | Update task by ID       |

### 📓 Journal
| Method | Endpoint                  | Description             |
|--------|---------------------------|-------------------------|
| POST   | `/journals`              | Create a journal entry  |
| GET    | `/journals/<id>`        | Get journal by ID       |
| DELETE | `/journals/<id>`        | Delete journal by ID    |
| PUT    | `/journals/<id>`        | Update journal by ID    |

### 🏷️ Category
| Method | Endpoint                                  | Description                        |
|--------|-------------------------------------------|------------------------------------|
| GET    | `/categories`                             | List all categories                |
| GET    | `/categories/<id>`                        | Get category information           |
| POST   | `/categories`                             | Create a new category              |
| DELETE | `/categories/<id>`                        | Delete a category                  |
| PUT    | `/categories/<id>`                        | Update a category                  |
| POST   | `/categories/<id>/add_event`              | Add an event to category           |
| POST   | `/categories/<id>/remove_event`           | Remove an event from category      |
| POST   | `/categories/<id>/add_task`               | Add a task to category             |
| POST   | `/categories/<id>/remove_task`            | Remove a task from category        |


#### At least 2 tables in database with a relationship between them

🔗 Data Model Relationships & Related Routes

Events & Timespans

- Type: One-to-Many

- Description: Each Event can have multiple associated Timespan entries.

Events & Categories

- Type: Many-to-Many

- Description: An Event can belong to multiple Categories, and a Category can include multiple Events.


Tasks (Todos) & Categories

- Type: Many-to-Many

- Description: A Task can belong to multiple Categories, and a Category can include multiple Tasks.


![API Design](https://github.com/user-attachments/assets/51f79f76-c59d-4599-8528-583fce35427a)

#### API specification explaining each implemented route

- API Documentation: https://docs.google.com/document/d/1UpwYSRDJb2ZrnyQ238ucVJXKUmzCyKcUq3ka1woTUbA/edit?usp=sharing 


### Frontend: 

#### Multiple screens that you can navigate between.

- Using the bottom sheet, you can switch between different screens by clicking on the "Tasks", "Events", and "Categories" buttons.

#### At least one scrollable view.

- The bottom sheet is a scrollable view. When expanding it fully, and when there are many events, you can scroll through them.

#### Networking integration with a backend API.

- We used a backend API to create a demonstration "CS Class" under "Events". When you add more events it can be displayed on the "Events" screen

