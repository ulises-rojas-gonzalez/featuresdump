# Sprint Backlog - Sprint 1

## Sprint Goal

Develop the core features of the football league management system, including team registration, league standings, and match result registration.

---

## User Stories

### US-1: Register Teams
As a league organizer,
I want to register teams with their name and coach,
So that they can participate in the tournament.

### US-2: View League Standings
As a fan,
I want to view the league standings,
So that I can see the current ranking of all teams.

### US-3: Register Match Results
As a referee,
I want to register the result of a match,
So that the league standings are updated automatically.

---

## Tasks

### US-1: Register Teams
- Design the database for teams.
- Create the team registration form.
- Validate duplicate team names.
- Save the information in the database.
- Test the feature.

### US-2: View League Standings
- Create the standings table.
- Calculate points, wins, draws, and losses.
- Display teams ordered by points.
- Test the feature.

### US-3: Register Match Results
- Create the match result form.
- Validate the entered scores.
- Update the standings automatically.
- Test the feature.

---

## Impediments and Dependencies

### Dependencies
- Database must be created.
- Application must be connected to the database.
- Teams must be registered before generating the standings.

### Impediments
- Database connection issues.
- Incomplete team information.
- Changes requested by the Product Owner during the sprint.

---

## Definition of Done (DoD)

- The feature is fully implemented.
- The code has been reviewed.
- No critical bugs remain.
- All tests pass successfully.
- The feature is integrated into the project.
- Documentation has been updated.
