-- Exploratory Data Analysis

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_v3;

SELECT company, SUM(total_laid_off)
FROM layoffs_v3
GROUP BY company
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_v3
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_v3
GROUP BY YEAR(`date`)
ORDER BY 1 ASC;



-- Rolling total of layoffs



WITH rolling as
(
SELECT SUBSTRING(`date`,1,7) AS MONTH, SUM(total_laid_off) as total_off
FROM layoffs_v3 
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)

SELECT `MONTH`,total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total_of_layoffs
FROM rolling;


WITH company_year (company, years, total_laid_off) as
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_v3
GROUP BY company, YEAR(`date`)
)

SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM company_year
WHERE years IS NOT NULL
ORDER BY RANKING ASC;

