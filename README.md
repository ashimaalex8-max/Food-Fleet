# FoodFleet Hybrid Database Project

Synthetic educational dataset: 690 rows across six normalized MySQL tables. No real customer data. Schema includes PK/FK, checks, workflow trigger and analytics view. MongoDB stores nested menus and reviews with indexes and two aggregation pipelines.

## Setup (Windows)
Install MySQL 8+, MongoDB Community, Node.js and Python. Start both database services.
1. In MySQL Workbench open and execute backend/scripts/schema.sql (WARNING: drops existing FoodFleet tables).
2. Execute backend/scripts/data.sql once on the fresh schema. Verify SELECT COUNT(*) FROM orders; returns 300.
3. Execute backend/scripts/analytics.sql for business queries.
4. In terminal: cd backend ; npm install. Copy .env.example to .env and set your MySQL password, database foodfleet_hybrid and MongoDB URL. Never publish .env.
5. node scripts/mongodb-setup.js
6. npm start ; open http://localhost:3000
7. In another terminal: cd analysis ; pip install -r requirements.txt ; jupyter notebook analysis.ipynb. Run the notebook, enter MySQL password. It produces two charts.
Do not run the old seed.js after data.sql. It is an alternative small demo only.

## Demonstration
Place an order through API, update status READY_FOR_PICKUP, DISPATCHED, COMPLETED; inspect delivery_events and analytics. MongoDB setup prints average ratings and menu price ranges. API supports menus, reviews, ratings, orders and analytics.

## Data and comparison
Data is synthetic, generated deterministically in data.sql: 50 customers, 10 restaurants, 30 menu items, 300 orders, 300 order items. delivery_events starts empty and is populated by the status trigger. MySQL uses normalized relations and transactions for orders; MongoDB uses flexible nested menus and review documents. Cross-database IDs are application-managed, not foreign keys. This is a local demo without authentication; do not deploy publicly as-is.

## Files
schema.sql, data.sql, analytics.sql, mongodb-setup.js, analysis.ipynb, analysis.py, backend API and frontend.
