# Design System WordPress Theme Child Theme: HPOROO

![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)

## Development Setup

```zsh
git clone https://github.com/bcgov/design-system-wordpress-child-theme-hporoo.git
cd design-system-wordpress-child-theme-hporoo.git
composer install
npm i
npm run start
```

## Build

```bash
npm run build:production
composer checklist
```

## Visual Regression Testing

This project uses Playwright to perform visual regression testing of patterns to help catch unintended changes.

```bash
npm run wp-env start # Unless already running
npm run test:screenshot
```

**Note**: When creating a new block it must be added to `tests/screenshot/style-book.spec.js` in order to be included in regression tests.

### Updating Screenshots

- Screenshots should be updated when intentional changes are made to patterns so the above tests can run against the latest versions of the Blocks in the Style Book.
- The `visual-regression` workflow runs the `update` script and commits changes automatically on pull requests, so it's not necessary to commit any updates made locally to the screenshots, but it can still be useful for local development to see what effects your changes will have.

```bash
npm run wp-env start # Unless already running
npm run test:screenshot:update
```

#### Preserving the dev / test database for purposes of collaboration

1. Run `npm build production && npm run test:screenshot:update` to build the production files and run the tests and update the screenshots.
2. To preserve your test instance pages, menus, and customizer settings:

```shell
  npm run --silent wp-env -- run tests-cli  wp db export - > ./database-backup-tests-$(date +%Y%m%d).sql
  # can also use `npm run test:export-db`
  # preserve this file by: right-click the file in your file tree > reveal in finder > drag it to your Documents folder

# To restore your database from an exported file:
  npm run wp-env -- run tests-cli bash
  wp db import wp-content/themes/bcgov-climatefunding/database-backup-tests-{YYMMDD}.sql
  exit
```

### DEV version

```shell
  npm run --silent wp-env -- run dev-cli  wp db export - > ./database-backup-dev-$(date +%Y%m%d).sql
  # preserve this file by: right-click the file in your file tree > reveal in finder > drag it to your Documents folder
  # can also use `npm run dev:export-db`

# To restore your database from an exported file:
  npm run wp-env -- run cli bash
  wp db import wp-content/themes/design-system-wordpress-child-theme-hporoo/database-backup-dev-{YYMMDD}.sql
  exit
```
