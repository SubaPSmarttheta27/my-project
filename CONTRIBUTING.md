# Contributing & Development Workflow Guide

Welcome to the project! This document outlines our professional GitHub development workflow, work item hierarchy, branching conventions, pull request standards, and release processes.

---

## 1. Work Item Hierarchy

All work must be tracked using GitHub Issues adhering to the following hierarchy:

```
EPIC (High-level strategic initiative)
├── Feature A (Discrete capability delivering user value)
│   ├── Story / Task (Actionable implementation unit)
│   └── Test Task (QA test plan & verification matrix)
└── Feature B (Discrete capability delivering user value)
    ├── Story / Task (Actionable implementation unit)
    └── Bug (Defect or regression discovered)
```

### Hierarchy Breakdown:
* **EPIC**: Strategic objective grouping multiple related Features. Created using the **Epic** issue template.
* **Feature**: A discrete functional requirement under an Epic. Must link back to its parent Epic (`parent_epic`). Created using the **Feature** issue template.
* **Story / Task**: The smallest deliverable implementation task assigned to a developer. Cut into a dedicated feature branch. Must link back to its parent Feature (`parent_feature`).
* **Test Task**: QA verification task defining test cases, automation coverage, and sign-off criteria for a Feature.
* **Bug**: Defect report documenting an unexpected behavior, regression, or failure with clear steps to reproduce and severity levels.

---

## 2. End-to-End Development Workflow

Our end-to-end delivery lifecycle follows these discrete stages:

```
Todo
  ↓
In Progress
  ↓
Feature Branch
  ↓
Pull Request
  ↓
CI: lint and tests
  ↓
Code Review
  ↓
Merge to develop
  ↓
Deploy to staging
  ↓
QA testing
  ↓
Release to main
  ↓
Production
```

### Detailed Lifecycle Steps:
1. **Todo**: Work items (Story, Task, Bug) are prioritized in the backlog.
2. **In Progress**: Developer assigns themselves to the item and moves it to "In Progress".
3. **Feature Branch**: A dedicated Git branch is branched off `develop` following the branch naming standard.
4. **Pull Request (PR)**: Once local implementation and tests pass, a PR is opened targeting the `develop` branch.
5. **CI: Lint and Tests**: Automated GitHub Actions run linter, static analysis, and automated test suites on every commit.
6. **Code Review**: At least one peer review approval is required. All reviewer comments must be resolved.
7. **Merge to develop**: Once CI passes and approvals are obtained, the PR is merged into `develop`.
8. **Deploy to Staging**: Merging into `develop` automatically triggers deployment to the Staging environment.
9. **QA Testing**: QA engineers verify the deployed build against the Test Task acceptance criteria and perform regression/exploratory testing.
10. **Release to main**: When staging is verified and approved, a release PR is prepared from `develop` to `main`.
11. **Production**: Merging into `main` (and tagging the release) triggers production deployment.

---

## 3. Branch Naming Rules

Always branch off `develop` for features and bug fixes. Only production hotfixes branch off `main`.

| Type | Format | Example |
| :--- | :--- | :--- |
| **Feature** | `feature/<issue-id>-<short-description>` | `feature/12-user-auth` |
| **Bugfix** | `bugfix/<issue-id>-<short-description>` | `bugfix/45-session-timeout` |
| **Hotfix** | `hotfix/<issue-id>-<short-description>` | `hotfix/88-security-patch` |
| **Release** | `release/v<semantic-version>` | `release/v1.0.0` |
| **Documentation / Chore** | `chore/<issue-id>-<short-description>` | `chore/05-update-readme` |

### Rules:
* Use lowercase kebab-case for the description portion.
* Always include the issue number for traceability.
* Delete the remote branch after the Pull Request is merged.

---

## 4. Pull Request (PR) Rules

1. **Target Branch**:
   * All feature and bugfix PRs **must target `develop`**.
   * Never target `main` directly for feature branches.
   * Only release PRs (`release/vX.Y.Z`) and critical hotfixes (`hotfix/...`) target `main`.
2. **PR Title Format**:
   * Follow conventional commits / structured tags:
     * `feat: <brief summary>` or `[FEATURE]: <brief summary>`
     * `fix: <brief summary>` or `[BUG]: <brief summary>`
     * `test: <brief summary>` or `[TEST]: <brief summary>`
     * `chore: <brief summary>` or `[CHORE]: <brief summary>`
3. **Link Issues**:
   * Always link the corresponding issue in the description using GitHub keywords (e.g., `Closes #123` or `Fixes #456`).
4. **Scope & Size**:
   * Keep PRs concise and focused on a single Story/Task. PRs over 400 lines of functional diff should be split when feasible.
5. **Pre-requisites Before Requesting Review**:
   * PR template checklist is fully filled out.
   * Code builds cleanly with no compiler/linter warnings.
   * Automated tests pass.
   * Developer has conducted a thorough self-review.

---

## 5. Code Review Rules

Code reviews uphold software quality, security, and team alignment.

1. **Required Approvals**:
   * Minimum of **1 approving review** from a peer engineer before merge.
2. **Reviewer Responsibilities**:
   * Check logic correctness, edge case handling, and potential race conditions.
   * Ensure test coverage adequately validates acceptance criteria.
   * Confirm adherence to project coding style and architectural patterns.
   * Provide constructive, polite, and actionable feedback.
3. **Author Responsibilities**:
   * Respond to all review comments.
   * Make required updates in the same branch (CI re-runs automatically).
   * Resolve discussion threads only after mutual agreement or requested change is addressed.
4. **Merge Method**:
   * Use **Squash and Merge** (or **Rebase and Merge**) to maintain a clean, linear history on `develop` and `main`.
   * Ensure the squashed commit message contains the PR title and issue reference.

---

## 6. QA Verification & Release Process

1. **Staging Verification**:
   * Once code is merged into `develop`, the Staging deployment pipeline runs.
   * QA verifies the functionality in the Staging environment against the linked **Test Task**.
   * Any defect found is logged as a **Bug** issue linked to the Feature.
2. **Release Preparation**:
   * After all Features in the milestone pass QA testing on Staging, create a `release/vX.Y.Z` branch from `develop`.
   * Perform final smoke tests and release sanity checks.
   * Open a PR from `release/vX.Y.Z` into `main`.
3. **Production Deployment**:
   * Merging into `main` promotes the approved build to Production.
   * Tag the commit with the semantic release tag (e.g., `git tag -a v1.0.0 -m "Release v1.0.0"`).
   * Merge `main` back into `develop` if any hotfixes or release adjustments were applied.
