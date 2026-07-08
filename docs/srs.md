# Software Requirements Specification (SRS)

# Football League Management System

## 1. Introduction

### 1.1 Purpose
The purpose of this system is to manage a football league by allowing users to register teams, schedule matches, record match results, and view league standings.

### 1.2 Scope
The Football League Management System will help league organizers manage tournaments efficiently. Users will be able to register teams, manage matches, update results, and check the current standings.

### 1.3 Intended Audience
- League Organizer
- Referee
- Football Fans
- System Administrator

---

# 2. Overall Description

## 2.1 Product Perspective
The system is a web application that stores league information in a database.

## 2.2 Product Functions
- Register teams.
- Edit and delete teams.
- Schedule matches.
- Register match results.
- Display league standings.
- Manage users.

## 2.3 User Classes
- **Administrator:** Full access to the system.
- **Organizer:** Manages teams and matches.
- **Referee:** Records match results.
- **Fan:** Views standings and match information.

---

# 3. Functional Requirements

### FR-1 Team Registration
The system shall allow the organizer to register football teams.

### FR-2 Team Management
The system shall allow editing and deleting team information.

### FR-3 Match Scheduling
The system shall allow organizers to create match schedules.

### FR-4 Match Results
The system shall allow referees to register match results.

### FR-5 League Standings
The system shall automatically calculate and display league standings.

### FR-6 Authentication
The system shall require users to log in before accessing protected features.

---

# 4. Non-Functional Requirements

- The system shall be available 24/7.
- The system shall respond within 3 seconds.
- The interface shall be easy to use.
- User information shall be stored securely.
- The system shall support modern web browsers.

---

# 5. System Requirements

## Software
- Java
- Spring Boot
- MySQL
- HTML/CSS
- JavaScript

## Hardware
- Computer or laptop
- Internet connection

---

# 6. Assumptions

- Users have internet access.
- Users have valid accounts.
- The database server is available.

---

# 7. Constraints

- Only administrators can delete data.
- Match results cannot be modified once approved.
- Teams must be registered before scheduling matches.

---

# 8. Glossary

- **League:** A football competition.
- **Team:** A group of players.
- **Match:** A football game between two teams.
- **Standing:** The ranking of teams based on points.
- **Organizer:** Person responsible for managing the league.
