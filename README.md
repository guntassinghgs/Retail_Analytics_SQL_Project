# Retail_Analytics_SQL_Project

Understanding the customer behavior and the product performance variability for a Retail company.

## Overview

In the rapidly evolving retail sector, businesses continually seek innovative strategies to stay ahead of the competition, 
improve customer satisfaction, and optimize operational efficiency. Leveraging data analytics has become a cornerstone for achieving 
these objectives. This case study focuses on a retail company that has encountered challenges in understanding its sales performance, 
customer engagement, and inventory management. Through a comprehensive data analysis approach, the company aims to identify high or 
low sales products, effectively segment its customer base, and analyze customer behavior to enhance marketing strategies, inventory
decisions, and overall customer experience.
 
L4Q Rev > 0 - Repeat 
L4Q Rev <0 and L12Q Rev > 0 - Lapsing
L5Q Rev <0 and L12Q Rev > 0 - Inactive
L12Q < 0 - Non Buyers

## Business Problem

The retail company has observed stagnant growth and declining customer engagement metrics over the past quarters. Initial assessments 
indicate potential issues in product performance variability, ineffective customer segmentation, and lack of insights into customer
purchasing behavior. The company seeks to leverage its sales transaction data, customer profiles, and product inventory information 
to address the following key business problems:

1. Product Performance Variability: Identifying which products are performing well in terms of sales and which are not. This insight 
is crucial for inventory management and marketing focus.

2. Customer Segmentation: The company lacks a clear understanding of its customer base segmentation. Effective segmentation is 
essential for targeted marketing and enhancing customer satisfaction.

3. Customer Behavior Analysis: Understanding patterns in customer behavior, including repeat purchases and loyalty indicators, is 
critical for tailoring customer engagement strategies and improving retention rates.

## Objectives

To utilize SQL queries for data cleaning and exploratory data analysis to ensure data quality and gain initial insights.

To identify high and low sales products to optimize inventory and tailor marketing efforts.

To segment customers based on their purchasing behavior for targeted marketing campaigns. Create Customer segments - 

Total Number of order Customer_Segment

0							No Orders
1-10						Low
10-30						Mid
>30							High Values

To analyze customer behavior for insights on repeat purchases and loyalty, informing customer retention strategies.

## Datasets

<a href="https://github.com/guntassinghgs/Retail_Analytics_SQL_Project/blob/main/sales_transaction-1714027462.csv">Sales Transaction</a> : Records of sales transactions, including transaction ID, customer ID, product ID, quantity purchased, transaction date, and price.

<a href="https://github.com/guntassinghgs/Retail_Analytics_SQL_Project/blob/main/customer_profiles-1-1714027410.csv">Customer_data</a> : Information on customers, including customer ID, age, gender, location, and join date.

<a href="https://github.com/guntassinghgs/Retail_Analytics_SQL_Project/blob/main/product_inventory-1-1714027438.csv">product_data</a> : Data on product inventory, including product ID, product name, category, stock level, and price.


## Activity/Outcomes 

Data Cleaning

Remove duplicate transactions and correct any discrepancies in product prices between sales transactions and product inventory. Also take care of null values 

Exploratory Data Analysis (EDA)

Perform basic product performance overview, customer purchase frequency analysis, and product categories performance evaluation.

Detailed Analysis

High or Low Sales Products: Identify products with the highest and lowest sales to inform inventory decisions. Also find the sales trends and the m-o-m growth of sales from the dataset 

Customer Segmentation: Segment customers based on total products purchased  and spending to tailor marketing efforts. Also identify loyal customer based on duration between purchases 

Customer Behavior Analysis: Analyze patterns in repeat purchases and loyalty indicators to improve customer retention and satisfaction.

Also, segment customers based on total quantity of products purchased 

SQL FILE : <a href="https://github.com/guntassinghgs/Retail_Analytics_SQL_Project/blob/main/retail%20case%20study.sql">Dataset</a>

