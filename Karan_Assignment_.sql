use assignment;
show tables;
select * from product;

-- Task 1

-- 1. Determine the number of drugs approved each year and provide insights into the yearly trends.
select
	ActionType, year(DocDate) as approval_year,
	count(*) as number_of_drugs_approved
from appdoc where ActionType= 'AP' group by year(DocDate) order by approval_year;

-- 2. Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.
-- Descending
select
	year(DocDate) as approval_year,
    count(*) as number_of_drugs_approved
from appdoc where ActionType= 'AP' group by year(DocDate) order by number_of_drugs_approved DESC LIMIT 3;
-- Ascending
select
	year(DocDate) as approval_year,
    count(*) as number_of_drugs_approved
from appdoc where ActionType= 'AP' group by year(DocDate) order by number_of_drugs_approved ASC LIMIT 3;

-- 3. Explore approval trends over the years based on sponsors.
select year(r.ActionDate) as approval_year,
a.SponsorApplicant,r.ActionType,
count(*) as num_of_approvals
from regactiondate r
join application a on r.ApplNo=a.ApplNo
where r.ActionType='AP'
group by (r.ActionDate),a.SponsorApplicant 
order by approval_year,num_of_approvals DESC;

-- 4. Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.
select year(r.ActionDate) as year, 
a.SponsorApplicant,
count(*) AS NumOfApproval,
rank() over (partition by year(r.ActionDate) order by COUNT(*) desc) as Ranks
from RegActionDate r
join Application a on r.ApplNo = a.ApplNo
where r.ActionType = 'AP' and year(r.ActionDate) between 1939 and 1960
group by year(r.ActionDate), a.SponsorApplicant
order by year, Ranks;

-- Task 2

-- 1. Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.
select 
    ProductMktStatus,
    count(*) as num_products
from product
group by ProductMktStatus
order by num_products DESC;

-- 2. Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.
select year(r.ActionDate) as year, p.ProductMktStatus, COUNT(*) as num_of_applications
from RegActionDate r
join Product p on r.ApplNo = p.ApplNo
where year(r.ActionDate) > 2010
group by year(r.ActionDate), p.ProductMktStatus
order by year, p.ProductMktStatus;

-- 3. Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.
-- MarketingStatus with the maximum number of applications
select p.ProductMktStatus, Count(*) as numofapplications
from product p
join regactiondate r on p.ApplNo = r.ApplNo
group by p.ProductMktStatus
order by Numofapplications DESC;

-- its trend over time
select year(r.ActionDate) as year, count(*) as Numofapplications
from Product p
join RegActionDate r on p.ApplNo = r.ApplNo
where p.ProductMktStatus = (
    select p.ProductMktStatus
    from Product p
    join RegActionDate r on p.ApplNo = r.ApplNo
    group by p.ProductMktStatus
    order by COUNT(*) Desc
    LIMIT 1
)
group by year(r.ActionDate)
order by year;

-- Task 3
-- 1. Categorize Products by dosage form and analyze their distribution.
select Form,
count(*) as Numofproducts
from product
group by Form
order by Numofproducts DESC;

-- 2. Calculate the total number of approvals for each dosage form and identify the most successful forms.
select p.Dosage,
count(*) as numofapprovals
from product p
join regactiondate r on p.ApplNo = r.ApplNo
where r.ActionType='AP'
group by p.Dosage
order by numofapprovals DESC;

-- 3. Investigate yearly trends related to successful forms.
select year(r.ActionDate) as year,
p.Form,
count(*) as NumOfApprovals
from Product p
join regactiondate r on p.ApplNo = r.ApplNo
where r.ActionType = 'AP'
group by year(r.ActionDate), p.Form
order by year, NumOfApprovals DESC;

-- Task 4
-- 1. Analyze drug approvals based on the therapeutic evaluation code (TE_Code).
select p.TECode,
count(*) as NumOfApproval
from product p
join regactiondate r on p.ApplNo = r.ApplNo
where p.TECode = 'AP'
group by p.TECode
order by NumOfApproval DESC;

-- 2. Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
select year(r.ActionDate) as year, 
pte.TECode,
count(*) as NumOfApproval,
rank() over(partition by year(r.ActionDate) order by count(*) desc) as Ranks
from product p
join regactiondate r on p.ApplNo = r.ApplNo
join product_tecode pte on pte.ApplNo = p.ApplNo
where r.ActionType = 'AP'
group by year (r.ActionDate), pte.TECode
order by year, Ranks;