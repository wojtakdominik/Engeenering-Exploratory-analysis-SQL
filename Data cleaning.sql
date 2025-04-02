CREATE TABLE layoffs_v2
LIKE layoffs;

INSERT layoffs_v2 SELECT * FROM layoffs;

 -- removing duplicates
WITH duplicate_cte as
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, "date",stage,country,funds_raised_millions) as row_num 
FROM layoffs_v2
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_v3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_v3
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, "date",stage,country,funds_raised_millions) as row_num 
FROM layoffs_v2;

DELETE
FROM layoffs_v3
WHERE row_num >1;

-- standardizing

SELECT company, TRIM(company) FROM layoffs_v3;

UPDATE layoffs_v3
SET company = TRIM(company);

SELECT distinct industry 
FROM layoffs_v3
ORDER BY 1;

SELECT * 
FROM layoffs_v3
WHERE industry LIKE "Crypto%";

UPDATE layoffs_v3
SET  industry = "Crypto"
WHERE industry LIKE "Crypto%";

SELECT DISTINCT country
FROM layoffs_v3
ORDER BY 1;


UPDATE layoffs_v3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_v3;

UPDATE layoffs_v3
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_v3
MODIFY COLUMN `date` DATE;

 -- N/A VALUES
 UPDATE layoffs_v3
 SET industry = NULL
 WHERE industry = '';
 
 SELECT *
 FROM layoffs_v3 
 WHERE industry IS NULL 
 OR industry = '';
 
 SELECT *
 FROM layoffs_v3 t1
 JOIN layoffs_v3 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
 
 
UPDATE layoffs_v3 t1
JOIN layoffs_v3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
 
 SELECT * 
 FROM layoffs_v3
 WHERE company LIKE 'Bally%';
 
 SELECT *
 FROM layoffs_v3
 WHERE total_laid_off IS NULL 
 AND percentage_laid_off IS NULL;
 
 DELETE 
  FROM layoffs_v3
 WHERE total_laid_off IS NULL 
 AND percentage_laid_off IS NULL;
 
  SELECT *
 FROM layoffs_v3
 WHERE total_laid_off IS NULL 
 or percentage_laid_off IS NULL;
 
 DELETE 
  FROM layoffs_v3
 WHERE total_laid_off IS NULL 
 or percentage_laid_off IS NULL;
 
 ALTER TABLE layoffs_v3
 DROP COLUMN row_num;
 


