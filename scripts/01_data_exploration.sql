USE PortfolioProject;


GO
-- See All Datas
SELECT *
FROM   PortfolioProject..CovidDeaths;

SELECT *
FROM   PortfolioProject..CovidVaccinations;

-- Checking Deaths per Cases/Population
SELECT   location,
         date,
         population,
         new_cases,
         total_cases,
         total_deaths,
         CAST (COALESCE ((total_deaths * 1.0 / total_cases) * 100, 0) AS DECIMAL (10, 2)) AS deaths_per_cases_percentage,
         CAST (COALESCE ((total_deaths * 1.0 / NULLIF (population, 0) * 100), 0) AS DECIMAL (10, 2)) AS deaths_per_population_percentage
FROM     PortfolioProject..CovidDeaths
-- WHERE    location LIKE 'Vi%'
WHERE    continent IS NOT NULL
ORDER BY location, date;

-- Checking Highest Infection Rate per Population Countries
SELECT   location,
         population,
         MAX(total_cases) AS highest_infection_count,
         CAST (COALESCE ((MAX(total_cases) * 1.0 / NULLIF (population, 0) * 100), 0) AS DECIMAL (10, 2)) AS infection_rate_percentage
FROM     PortfolioProject..CovidDeaths
WHERE    continent IS NOT NULL
GROUP BY location, population
ORDER BY infection_rate_percentage DESC;

-- Checking Highest Death Counts per Population Continent
SELECT   continent,
         MAX(total_deaths) AS highest_death_count
FROM     PortfolioProject..CovidDeaths
WHERE    continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death_count DESC;

-- Global Numbers
SELECT   date,
         SUM(new_cases) AS total_cases,
         SUM(new_deaths) AS total_deaths,
         CAST (COALESCE ((SUM(new_deaths) * 1.0 / NULLIF (SUM(new_cases), 0)) * 100, 0) AS DECIMAL (10, 2)) AS deaths_per_cases_percentage
FROM     PortfolioProject..CovidDeaths
WHERE    continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- Checking Rolling People Vacinated (with CTE)
WITH     PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vacinated)
AS       (SELECT dea.continent,
                 dea.location,
                 dea.date,
                 dea.population,
                 vac.new_vaccinations,
                 COALESCE (SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date), 0) AS rolling_people_vacinated
          FROM   PortfolioProject..CovidDeaths AS dea
                 INNER JOIN
                 PortfolioProject..CovidVaccinations AS vac
                 ON vac.location = dea.location
                    AND vac.date = dea.date
          WHERE  dea.continent IS NOT NULL)
SELECT   *,
         CAST ((rolling_people_vacinated * 1.0 / population) * 100 AS DECIMAL (10, 2)) AS rolling_people_rate_percentage
FROM     PopvsVac
ORDER BY location, date;

-- Insert Data
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated (
    continent                      NVARCHAR (50),
    location                       NVARCHAR (50),
    date                           DATE         ,
    population                     BIGINT       ,
    rolling_people_vacinated       INT          ,
    rolling_people_rate_percentage FLOAT        
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       COALESCE (SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date), 0) AS rolling_people_vacinated
FROM   PortfolioProject..CovidDeaths AS dea
       INNER JOIN
       PortfolioProject..CovidVaccinations AS vac
       ON vac.location = dea.location
          AND vac.date = dea.date
WHERE  dea.continent IS NOT NULL;

SELECT   *,
         CAST ((rolling_people_vacinated * 1.0 / population) * 100 AS DECIMAL (10, 2)) AS rolling_people_rate_percentage
FROM     #PercentPopulationVaccinated
ORDER BY location, date;

-- Creating Views
DROP VIEW IF EXISTS PercentPopulationVaccinated;


GO
CREATE VIEW PercentPopulationVaccinated
AS
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       COALESCE (SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date), 0) AS rolling_people_vacinated
FROM   PortfolioProject..CovidDeaths AS dea
       INNER JOIN
       PortfolioProject..CovidVaccinations AS vac
       ON vac.location = dea.location
          AND vac.date = dea.date
WHERE  dea.continent IS NOT NULL;