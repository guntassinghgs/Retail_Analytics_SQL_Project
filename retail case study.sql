

-- ############################################# 09 JULY ###############################################
   


create database my_retail;
use my_retail;

select * from customer_profiles;

alter table customer_profiles change column ï»¿CustomerID CustomerID int; 
alter table product_inventory change column ï»¿ProductID ProductID int; 
alter table sales_transaction change column ï»¿TransactionID TransactionID int;

/*
Background : 

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

Business Problem
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

Objectives
To utilize SQL queries for data cleaning and exploratory data analysis to ensure data quality and gain initial insights.
To identify high and low sales products to optimize inventory and tailor marketing efforts.
To segment customers based on their purchasing behavior for targeted marketing campaigns. Create Customer segments - 

Total Number of order Customer_Segment
0							No Orders
1-10						Low
10-30						Mid
>30							High Values

To analyze customer behavior for insights on repeat purchases and loyalty, informing customer retention strategies.

Datasets
Sales Transactions Dataset: Records of sales transactions, including transaction ID, customer ID, product ID, quantity purchased, 
							transaction date, and price.
Customer Profiles Dataset: Information on customers, including customer ID, age, gender, location, and join date.
Product Inventory Dataset: Data on product inventory, including product ID, product name, category, stock level, and price.


Activity/Outcomes 

Data Cleaning
Remove duplicate transactions and correct any discrepancies in product prices between sales transactions and product inventory. Also 
take care of null values 

Exploratory Data Analysis (EDA)
Perform basic product performance overview, customer purchase frequency analysis, and product categories performance evaluation.

Detailed Analysis
High or Low Sales Products: Identify products with the highest and lowest sales to inform inventory decisions. Also find the sales 
trends and the m-o-m growth of sales from the dataset 
Customer Segmentation: Segment customers based on total products purchased  and spending to tailor marketing efforts. Also identify 
loyal customer based on duration between purchases 
Customer Behavior Analysis: Analyze patterns in repeat purchases and loyalty indicators to improve customer retention and satisfaction.
Also, segment customers based on total quantity of products purchased 

*/




--                         $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 14 JULY $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


/* data cleaning - 

1. remove duplicates: identifiy and remove duplicates 
hint: we have 2 duplicates in sales_transaction tables 

*/

-- identify duplicates 

select * , count(*) as count from sales_transaction
group by 1,2,3,4,5,6
having count(*) >1 ;

-- create a new table and push only distinct records to it 

create table sales_new 
select distinct * from sales_transaction;

select * from sales_transaction;  -- 5002 rows 
select * from sales_new; -- 5000 rows , duplicate removed 


-- now delete the old table and rename the present table to sales_transaction 

drop table sales_transaction;

rename table sales_new to sales_transaction;



# identify and correct the discrepency in prices in the sales transaction table 


# price per each is mismatched in sales and product table for some product ids 

select distinct st.productid, st.price as sales_price, pi.price as product_price
from sales_transaction st
join product_inventory pi on pi.productid = st. productid
where st.price <> pi.price;


# now update the prices in the sales transaction table 


update sales_transaction st
join product_inventory pi on pi.productid = st.productid
set st.price = pi.price; 
 
-- above querry will update all the rows we can also do on only the incorrect prices by adding a simple where clause 




# ################################################# 16th July ####################################


select * from customer_profiles;

select * from customer_profiles
where location = '';

update customer_profiles
set location= 'unknown'
where location = '';

-- update location to mod value 


update customer_profiles
set location = 
 (select location from (select location
from customer_profiles
where location <> 'unkown' and location is not null
group by location
order by count(*) desc
limit 1) as mod_value)
where location = 'unknown';


-- join date in customer_profiles is text format changing and making a new column with datw format 

alter table customer_profiles add column modified_date date after joindate;

update customer_profiles 
set modified_date = str_to_date(joindate, '%d/%m/%y');


/*

EDA - exploratory data analysis  

Find the total quantity ordered and total sales per product


*/

select distinct pi.productid,pi.productname,
sum(st.quantitypurchased) over (partition by productid) as quantity_purchased,
sum(st.price*st.quantitypurchased) over (partition by productid) as total_sales
from sales_transaction as st
right join product_inventory pi on pi.productid = st.productid;


-- ###########################################  21 JULY #########################################################


# cast date column in sales table 

/*

create a new table same as transaction table and change the data type odf the date comlumn as date and name it as per your wish 
then delete the old table 
*/



drop table sales_transaction2;


/*create table sales_transaction2 
select * , cast(TransactionDate as date) as transaction_date_updated from sales_transaction;  -- this not works as date is taken as year and vice versa 
*/

create table sales_transaction2 
select * , str_to_date(TransactionDate,'%d/%m/%y') as transaction_date_updated from sales_transaction;


select * from sales_transaction2;

drop table sales_transaction;

rename table sales_transaction2 to sales_transaction;

select * from sales_transaction;

-- count the number of transactions per customer to understand the purchase frequency 

select customerid , count(*) as no_of_transations
from sales_transaction
group by customerid
order by count(*) desc;

-- evaluate product categories performance based on the total sales 


select pi.category, sum(quantitypurchased) as total_quantity,round(sum(st.QuantityPurchased*st.Price),0) as total_sales
from product_inventory pi
join sales_transaction st on st.productid =pi.productid
group by pi.category
order by total_sales desc;

-- 10 top products with highest total sales revenue 

select productid , round(sum(price*quantitypurchased),0) as total_sales
from sales_transaction
group by productid
order by total_sales desc
limit 10;



-- find 10 products with low sales 
-- use rank dense rank row number and limit


select productid,round(sum(price*quantitypurchased),0) as total_sales,
rank() over (order by sum(price*quantitypurchased)) as sales_rank
from sales_transaction
group by productid
limit 10;

select productid,round(sum(price*quantitypurchased),0) as total_sales,
dense_rank() over (order by sum(price*quantitypurchased)) as sales_rank
from sales_transaction
group by productid
limit 10;

select productid,round(sum(price*quantitypurchased),0) as total_sales,
row_number() over (order by sum(price*quantitypurchased)) as sales_rank
from sales_transaction
group by productid
limit 10;


-- we should do the above problem with cte 


with sales_rank as (

select productid,round(sum(price*quantitypurchased),0) as total_sales,
rank() over (order by sum(price*quantitypurchased)) as sales_rank
from sales_transaction
group by productid 


)

select *
from sales_rank
where sales_rank <= 10;



-- write a query to understand the sales trend to understand the revenue pattern of the company  (date wise)



select transaction_date_updated , 
sum(price*quantitypurchased) as total_sales ,
sum(quantitypurchased) as total_quantity,
count(*) as total_transactions from sales_transaction
group by transaction_date_updated 
order by transaction_date_updated desc;

-- write a query to understand the sales trend to understand the revenue pattern of the company  (month wise)


select month(transaction_date_updated) , 
sum(price*quantitypurchased) as total_sales ,
sum(quantitypurchased) as total_quantity,
count(*) as total_transactions from sales_transaction
group by month(transaction_date_updated) 
order by month(transaction_date_updated) desc;


-- now if we want to check month on month percent change

with monthly_sales as(

select month(transaction_date_updated) as month,
round(sum(price*quantitypurchased),0) as total_sales
from sales_transaction
group by month(transaction_date_updated)

), prev_month as(

select *,
lag(total_sales ) over (order by month) as prev_month  -- LAG provides the last row value
from monthly_sales
)

select month, total_sales,
round(((total_sales - prev_month)/prev_month)*100,2) as percent_change 
from prev_month;



-- ################################################## 25 JULY #####################################################


-- find the customer wise total spends and total transactions to understand customers with high purchase frequency 


select customerid, count(*) total_transactions,
sum(price*quantitypurchased) as money_spent
from sales_transaction
group by customerid
having total_transactions > 10 and money_spent > 1000
order by total_transactions desc;

-- low frequency customers 

select customerid, count(*) total_transactions,
sum(price*quantitypurchased) as money_spent
from sales_transaction
group by customerid
having total_transactions <= 2
order by total_transactions desc;


select * from sales_transaction;

select customerid, productid , count(*) as purchase_frequency 
from sales_transaction
group by customerid, productid
having purchase_frequency >1
order by purchase_frequency desc;



-- loyalty check on customers 
-- show thw following
/*
first purchase date 
last purchase date 
days between first and last purchase 
average days between purchases
purchase frequency 

*/


/* this is what i have done  (this is also correct)

select  distinct customerid,
min(transaction_date_updated) over (partition by customerid) as first_purchase_date,
max(transaction_date_updated) over (partition by customerid) as last_purchase_date,
datediff(max(transaction_date_updated) over (partition by customerid),min(transaction_date_updated) over (partition by customerid)) as date_diff,
count(*) over (partition by customerid) as purchase_frequency,
datediff(date(now()),max(transaction_date_updated) over (partition by customerid)) as days_since_last_purch,
avg(datediff(transaction_date_updated,prev_order_date)) over (partition by customerid) as average_days_between_order
from (select
*,
lag(transaction_date_updated) over (partition by customerid order by transaction_date_updated) as prev_order_date
from sales_transaction) as temp;

select
*,
lag(transaction_date_updated) over (partition by customerid order by transaction_date_updated) as prev_order_date
from sales_transaction

*/


-- this is what arun did

with cust_perf as(

select  distinct customerid,
min(transaction_date_updated) over (partition by customerid) as first_purchase_date,
max(transaction_date_updated) over (partition by customerid) as last_purchase_date,
datediff(max(transaction_date_updated) over (partition by customerid),min(transaction_date_updated) over (partition by customerid)) as date_diff,
count(*) over (partition by customerid) as purchase_frequency,
datediff(date('2023-07-30'),max(transaction_date_updated) over (partition by customerid)) as days_since_last_purch

from  sales_transaction),

avg_days as (
select
*,
round(date_diff/ifnull(purchase_frequency,0),1) as avg_days_bet_purch
from cust_perf
)

select * , 
case 
 when days_since_last_purch < 10 and purchase_frequency > 10 then 'High Loyalty'
 when days_since_last_purch < 30 and purchase_frequency > 5 then 'Medium Loyalty'
 else 'Low Loyalty' 
 end as loyalty_tier
from cust_perf;



-- 30 mins excercise on retail case study 

/*
Q1 (Customer Churn Candidates) - Find customers who haven’t made any purchase in the last 3 months from the most recent transaction date in the sales_transaction table.

Q2 (Stock Replenishment Alert) - Write a query to get the products that are in the top 10% of total sales quantity but have stock levels below 20 units.

Q3 (Product Sales Distribution) - For each product, compute the percentage of total revenue it contributed in its category.

Q4 (Lifetime Value (LTV) Tiering) - Assign each customer a tier based on their total purchase value:

Platinum if total > 5000
Gold if 2000–5000
Silver if 500–2000
Bronze otherwise

Return the number of customers in each tier, along with average age and gender distribution.

Q5 (Most Popular Product Among Youth) - Identify the top 3 products purchased by customers aged between 18 and 25.

Q6 (Category Basket Analysis) - For customers who purchased products in more than 2 categories, list their CustomerID, number of distinct categories purchased, and 
total amount spent.
*/



/*

1) find out the customers who hasn't made a transaction in last 3 months from the most recen transaction date in the data

*/ 

-- i first tried in this way but thos doesnt include those customers who haven't ordered even once 
select customerid, max(transaction_date_updated) as last_purschase_date
from sales_transaction
group by customerid
having  datediff((select max(transaction_date_updated) from sales_transaction),max(transaction_date_updated)) > 90;

-- this is the way arun did but is very confusing 
select c.customerid , c.joindate
from customer_profiles c
where not exists (
select 1
from sales_transaction s
where s.customerid = c.customerid and 
s.transaction_date_updated >= c.modified_date - interval 3 month 
);




-- this is the way in which I did and is very efficient

select c.customerid,
max(s.transaction_date_updated) as last_purchase_date
from customer_profiles c
left join sales_transaction s on s.customerid = c.customerid
group by c.customerid
having max(s.transaction_date_updated) is null or max(s.transaction_date_updated) <= (select (max(transaction_date_updated) - interval 3 month) from sales_transaction);


/*
Q3
-- find contribution of individual products towards there respective category
*/

with contribution as(
select distinct p.productid,p.category,p.productname,
round(sum(s.QuantityPurchased*s.Price) over (partition by p.productid),0) as product_revenue,
round(sum(s.QuantityPurchased*s.Price) over (partition by p.category),0) as category_revenue
from sales_transaction s
right join product_inventory p on p.productid = s.productid
)

select productid,productname,category,
concat(round((product_revenue/category_revenue)*100,2), " %") as cont_to_cat
from contribution;


/*

Q4 lifetime value (ltv) tiering classify customers based on their lifetime sales 

*/


select c.customerid,sum(s.QuantityPurchased*s.Price) as sales,
case 
 when sum(s.QuantityPurchased*s.Price) > 5000 then 'platinum'
 when sum(s.QuantityPurchased*s.Price) > 2000 then 'Gold'
 when sum(s.QuantityPurchased*s.Price) > 500 then 'silver'
 else 'bronze'
 end as LTV
from customer_profiles c
join sales_transaction s on s.customerid = c.customerid
group by c.customerid;


/*

	Q 5  top three product id famous in age group of 18 - 25

*/
select * from customer_profiles;

-- using sales 

select  
productid,
sum(QuantityPurchased*Price) as sales

from sales_transaction
where customerid in (    
select customerid from customer_profiles    -- this subquery gives the customer ids with age between 18 to 25
where age >18 and age<25
)
group by 1
order by sales desc
limit 3;

-- using frequency of purchase

select  
productid,
count(*) as purchase_frequency

from sales_transaction
where customerid in (    
select customerid from customer_profiles    -- this subquery gives the customer ids with age between 18 to 25
where age >18 and age<25
)
group by 1
order by purchase_frequency desc
limit 3;