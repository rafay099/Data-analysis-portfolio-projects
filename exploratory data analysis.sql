-- Exploratory Data Analysis

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select min(`date`), max(`date`)
from layoffs_staging2;


select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;


select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;




select substring(`date`, 1, 7) AS Month, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by month
order by 1 asc;



with Rolling_Total AS
(
select substring(`date`, 1, 7) AS Month, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by Month
order by 1 asc
)
select Month, total_off, sum(total_off) over(order by Month) AS rolling_total
from Rolling_Total;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


with Company_Year (company, years, total_laid_off) AS
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank AS
(select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from Company_Year
where years is not null
order by ranking)
select *
from company_year_rank
where ranking <= 5;