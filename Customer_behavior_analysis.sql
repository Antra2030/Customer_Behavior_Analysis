--Que1. what is the total revenue generated  by male and female customer
SELECT "Gender", SUM("Purchase Amount (USD)") AS revenue
FROM customer
GROUP BY "Gender";

--Que2. which customer used a discounnt but still spent more than the average purchase amount?
select "Customer ID", "Purchase Amount (USD)"
from customer
where "Discount Applied" = 'Yes' and "Purchase Amount (USD)" >=(select Avg("Purchase Amount (USD)") from customer)

--Que3. which are the top  5 products with the highest average review rating?
select  "Item Purchased", ROUND(AVG("Review Rating")::NUMERIC, 2) as "Average Product Rating"
from customer
group by "Item Purchased"
order by avg("Review Rating") DESC
limit 5; 

--Que4. compare the average purchase amount between standard and express shipping
select "Shipping Type",
Round(avg("Purchase Amount (USD)"),2)
from customer
where "Shipping Type" in ('Standard','Express')
group by "Shipping Type"

--Que5. Do subscribed customers spends more? compare average spend and total revenue between subscribers and non subscribers
select "Subscription Status",
count("Customer ID") as "Total_Customer",
round(Avg("Purchase Amount (USD)"),2) as "average_Spend",
round(SUM("Purchase Amount (USD)"),2) as  "total_Revenue"
from customer 
group by "Subscription Status"
order by "total_Revenue", "average_Spend" DESC


--Que6. which 5 products have the highest percentage of purchase with discount applied[which product rely heavily on discount]
SELECT "Item Purchased",
Round(100.0 * sum(Case When "Discount Applied" = 'Yes' then 1 else 0 End)/count(*),2) as "Discount_Rate"
from customer
group by "Item Purchased"
order by "Discount_Rate" DESC
limit 5

--Que7. Segment customers into new, returning, and loyal based on their total number of previous purchases,
  --and show the count of each segment[imp]
with "Customer Type" as (
select "Customer ID", "Previous Purchases",
CASE
WHEN"Previous Purchases" = 1 then 'New'
  when "Previous Purchases" BETWEEN 2 and 10 then 'Returning' 
  else 'Loyal'
  END as "Customer Segment" from customer
  )

select "Customer Segment", count (*) as "Number of Customers"
from "Customer Type"
group by "Customer Segment"



--Que8. What are the top 3 most purchase product within each category[will need window function]
with "Item counts" as (
  select "Category",
  "Item Purchased",
  COUNT("Customer ID") as "total Orders",
  ROW_NUMBER() over(PARTITION BY "Category" order by COUNT("Customer ID")DESC) as "Item Rank"
  from customer
  group by "Category", "Item Purchased"
)

select "Item Rank", "Category","Item Purchased", "total Orders"
from "Item counts"
where "Item Rank" <= 3;

--Que9. Are customer who are repeat buyers(more than 5 previous purchase) also likely to subscribe?[imp]
SELECT "Subscription Status",
count("Customer ID") as "Repeat Buyers"
from customer
where "Previous Purchases" > 5
group by "Subscription Status"

--Que10. What is the revenue contribution of each age group?[Age group does not exist so it is incomplete query]
select "Age",
sum("Purchase Amount (USD)") as "total Revenue"
from customer
group by "Age"
order by "total Revenue" DESC

