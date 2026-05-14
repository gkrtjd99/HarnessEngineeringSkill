# Frontend

Record frontend architecture and coding rules.

## Stack

| Concern | Choice |
| --- | --- |
| Framework | ... |
| Language | ... |
| Styling | ... |
| State | ... |

## Rendering Model

Describe server, client, static, and streaming rendering boundaries.

## Data Fetching Conventions

Describe how server and client data fetching are handled.

## Component Organization

Describe route, feature, shared UI, hook, state, test, and asset layout.

## Styling Ownership

Global CSS MUST be limited to design tokens, reset styles, base typography, and app-wide layout primitives.
Feature-specific styles MUST live with the feature or component that owns them.
Agents MUST NOT add unrelated component styles to a central stylesheet.

## Reuse Rules

Describe shared UI primitives, feature components, hooks, state modules, and route-level ownership.

## File Size Rules

Describe when components, pages, hooks, and stylesheets must be split.

## Performance Budget

Record Lighthouse targets and Core Web Vitals targets.
