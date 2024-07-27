# Ecommerce Analysis

## Introduction
This project involves performing various levels of SQL queries (basic, intermediate, and advanced) on a retail dataset to extract meaningful insights. The project covers a range of tasks from listing unique cities where customers are located to calculating the year-over-year growth rate of total sales. The goal is to practice and demonstrate proficiency in SQL for data analysis.
![image](https://github.com/user-attachments/assets/1d1198a2-51cf-40d1-a2b5-22e2d8771cef)

## Datasets Used
The project utilizes the following datasets:

1. customers.csv: Contains customer details including ID, unique ID, zip code, city, and state.
2. geolocations.csv: Includes geolocation information with zip code prefixes, latitude, longitude, city, and state.
3. order_items.csv: Records order and item details including order ID, item ID, product ID, seller ID, shipping deadline, price, and freight value.
4. orders.csv: Provides order information such as order ID, customer ID, status, purchase timestamp, and delivery dates.
5. payments.csv: Details payment information including order ID, payment sequence, type, installments, and total amount.
6. products.csv: Contains product details including ID, category, name length, description length, photo count, weight, dimensions (length, height, width).
7. sellers.csv: Lists seller information including ID, zip code, city, and state.

## Tools Used
1. Pandas: For reading and processing CSV files.
2. MySQL: For database management and querying.
3. MySQL Connector: To connect Python with MySQL and execute SQL commands.
4. Python: For scripting and automating data handling and querying.

## Process
1. Data Loading:
- Load datasets into pandas DataFrames.
- Clean column names and handle missing values.
- Create and populate MySQL tables based on DataFrame structures.
  
2. SQL Queries:
- Execute basic queries to gather insights such as unique cities and total sales.
- Perform intermediate queries to analyze monthly orders and product metrics.
- Run advanced queries to calculate moving averages, cumulative sales, growth rates, customer retention, and top-spending customers.

## Conclusion
The project provides a comprehensive analysis of retail data using SQL queries. By integrating Python with MySQL, the project automates data processing and querying, showcasing a detailed examination of the retail dataset.
