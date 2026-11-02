# Spec Delta

## Purpose

Lets any member of staff hold units of a variant in any of the four shops for a named
customer, for 48 hours, without ever reserving a unit a shop does not have.

## ADDED Requirements

### Requirement: Any staff member can reserve for a customer
Any member of staff SHALL be able to reserve, in any of the four shops, a number of units of
one variant for a customer, giving the customer's name. No manager code or role is asked.

#### Scenario: 4.1 Reserve in another shop
- **WHEN** staff in one shop reserve 1 unit of jacket black M in another shop that has 2 free, for "Claire Martin"
- **THEN** the reservation is made for Claire Martin, and that shop shows 1 free

#### Scenario: 4.2 No manager needed
- **WHEN** a member of staff who is not a manager reserves
- **THEN** the reservation is made, and nothing asks for a manager

#### Scenario: 4.3 A customer name is needed
- **WHEN** staff try to reserve with no customer name
- **THEN** the app refuses it, says the name is missing, and nothing is reserved

### Requirement: A reservation never takes stock below zero
The app SHALL refuse a reservation for more units than the shop has free of that variant, and
a reservation of zero or fewer units. A refused reservation SHALL change nothing.

#### Scenario: 5.1 More than free is refused
- **WHEN** staff try to reserve 3 units of a variant in a shop that has 2 free
- **THEN** the app refuses it, says only 2 are free, and the shop still shows 2 free

#### Scenario: 5.2 Exactly what is free is accepted
- **WHEN** staff reserve 2 units of a variant in a shop that has 2 free
- **THEN** the reservation is made, and the shop shows 0 free

#### Scenario: 5.3 Zero units is refused
- **WHEN** staff try to reserve 0 units
- **THEN** the app refuses it, and nothing is reserved

### Requirement: A reservation lasts 48 hours
A reservation SHALL hold its units for 48 hours from the moment it is made. When 48 hours
have passed and it has not been collected, it SHALL end on its own and its units SHALL be
free again.

#### Scenario: 6.1 Still held before 48 hours
- **WHEN** a reservation was made 47 hours and 59 minutes ago
- **THEN** it is still active and its units are not free

#### Scenario: 6.2 Ends at 48 hours
- **WHEN** a reservation was made 48 hours ago and was not collected
- **THEN** it is no longer active and its units are free again in that shop

#### Scenario: 6.3 The page shows when it ends
- **WHEN** staff look at an active reservation
- **THEN** the page shows the customer's name, the variant, the shop, the units and when it ends

### Requirement: A reservation can be collected or cancelled
Staff SHALL be able to mark an active reservation as collected, which takes its units out of
the shop's stock, or as cancelled, which makes them free again.

#### Scenario: 7.1 Collected
- **WHEN** staff mark as collected a reservation of 1 unit in a shop that has 2 in stock
- **THEN** the reservation ends, the shop has 1 in stock, and its free units do not change

#### Scenario: 7.2 Cancelled
- **WHEN** staff cancel a reservation of 1 unit in a shop that shows 1 free
- **THEN** the reservation ends, and the shop shows 2 free

#### Scenario: 7.3 An ended reservation cannot be collected
- **WHEN** staff try to collect a reservation that has expired or was cancelled
- **THEN** the app refuses it, and the stock does not change
