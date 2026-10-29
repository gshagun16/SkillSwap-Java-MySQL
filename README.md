
# SkillSwap — Java & MySQL

SkillSwap is a console-based application that helps users exchange skills by offering skills they know and learning skills they want to develop.

## Features
- User registration and login
- View user profile
- Add and remove skills
- Search users by skill
- Send and manage skill requests
- View and complete exchanges
- Add and view reviews

## Technologies Used
- Java
- JDBC
- MySQL
- Eclipse IDE

## Database Setup
1. Open MySQL Workbench.
2. Run `database/schema.sql`.
3. Ensure the `skillswap_db` database is created.
4. Configure the `SKILLSWAP_DB_PASSWORD` environment variable with your MySQL password.

## How to Run
1. Open the project in Eclipse.
2. Ensure the MySQL Connector/J JAR is added to the Java Build Path.
3. Configure the database password environment variable.
4. Run `src/app/Main.java` as a Java Application.

## Project Status
Core console features have been tested. Further end-to-end testing and improvements may be needed.
