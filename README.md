# Project Overview

This repository contains the solution and environment setup for tasks related to Q1 and Q2.

## Branch Structure

- **`main`**: Contains documentation for the project, including purpose and setup instructions.
- **`solution-sql`**: Contains the SQL solutions for:
  - **Q1**: Find the average session time (in minutes) a user spends on each web page. 
  - **Q2**: The trigger implementation and testing logic to calculate latency between source and target updates.
- **`docker-setup`**: Contains the Docker setup used to simulate and test the SQL solution for Q2 in a controlled environment.

This section describes how the solution for Q2 was tested using the Docker environment.

### **Environment Setup**
1. Install **Docker Desktop** from [here](https://www.docker.com/products/docker-desktop/).
2. Clone this repository:
   ```bash
   git clone [<repository-url>](https://github.com/timm30/Maybank-Application-Interview.git)
   cd Maybank-Application-Interview

3. Switch to the docker-setup branch
   ```bash
   git checkout docker-setup

4. Start the Docker environment by running:
   ```bash
   docker-compose -f docker-compose.yml up

5. Once the containers are running:
   - Access the database using **Adminer** at [http://localhost:8080](http://localhost:8080).
   - Log in with:
     - **System**: MSSQL
     - **Server**: mssql_test
     - **Username**: sa
     - **Password**: YourStrong!Passw0rd
