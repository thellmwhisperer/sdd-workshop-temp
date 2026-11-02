# Spec Delta

## Purpose

Lets the staff of Sabot's four shops see, on one page, how many units of each product, in
each size and colour, every shop has free, so nobody has to phone another shop to ask.

## ADDED Requirements

### Requirement: Stock is counted per variant and per shop
The app SHALL keep the stock of each of the four shops per variant: one product in one size
and one colour. Each count SHALL be a whole number, zero or more.

#### Scenario: 1.1 Sizes are counted apart
- **WHEN** a shop has 2 units of a jacket in black, size M, and 1 in black, size L
- **THEN** the app shows 2 for black M and 1 for black L in that shop, not 3 for the jacket

#### Scenario: 1.2 Colours are counted apart
- **WHEN** a shop has 1 unit of a jacket in black, size M, and 0 in navy, size M
- **THEN** the app shows 1 for black M and 0 for navy M in that shop

#### Scenario: 1.3 A count is never below zero
- **WHEN** the stock of a variant in a shop would be set to a negative number
- **THEN** the app refuses it and the count stays as it was

### Requirement: Free units are stock minus what is reserved
For a variant in a shop, the app SHALL show as free the units in stock minus the units held
by that shop's active reservations of that variant.

#### Scenario: 2.1 Reserved units are not free
- **WHEN** a shop has 3 units of a variant and an active reservation holds 1
- **THEN** the app shows 2 free for that variant in that shop

#### Scenario: 2.2 Nothing reserved
- **WHEN** a shop has 3 units of a variant and no active reservation of it
- **THEN** the app shows 3 free for that variant in that shop

### Requirement: One page shows a variant in every shop
When a member of staff picks a product, a size and a colour, the page SHALL show the four
shops, each with its number of free units of that variant, including the shops with none.

#### Scenario: 3.1 Every shop is listed
- **WHEN** staff pick the jacket, black, size M
- **THEN** the page lists the four shops, each with its free units of jacket black M

#### Scenario: 3.2 A shop with none still shows
- **WHEN** a shop has 0 free units of the picked variant
- **THEN** that shop is listed with 0, and it cannot be reserved from

#### Scenario: 3.3 Only sizes and colours that exist can be picked
- **WHEN** staff pick a product
- **THEN** the page offers only the sizes and colours that product comes in
