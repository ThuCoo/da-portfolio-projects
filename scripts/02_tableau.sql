USE PortfolioProject;


GO
-- 1
SELECT   SUM(new_cases) AS total_cases,
         SUM(new_deaths) AS total_deaths,
         CAST ((SUM(new_deaths) * 1.0 / SUM(new_cases)) * 100 AS DECIMAL (10, 2)) AS death_percentage
FROM     PortfolioProject.dbo.CovidDeaths
WHERE    continent IS NOT NULL
ORDER BY total_cases, total_deaths;

-- 2
SELECT   location,
         SUM(new_deaths) AS total_deaths
FROM     PortfolioProject.dbo.CovidDeaths
WHERE    continent IS NULL
         AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY total_deaths DESC;

-- 3
SELECT   location,
         population,
         MAX(total_cases) AS highest_infection_count,
         CAST (COALESCE ((MAX(total_cases) * 1.0 / population) * 100, 0) AS DECIMAL (10, 2)) AS population_infection_percentage
FROM     PortfolioProject.dbo.CovidDeaths
GROUP BY location, population
ORDER BY population_infection_percentage DESC;

-- 4
SELECT   location,
         population,
         date,
         MAX(total_cases) AS highest_infection_count,
         CAST (COALESCE ((MAX(total_cases) * 1.0 / population) * 100, 0) AS DECIMAL (10, 2)) AS population_infection_percentage
FROM     PortfolioProject.dbo.CovidDeaths
GROUP BY location, population, date
ORDER BY population_infection_percentage DESC;

-- 5
SELECT   dea.continent,
         dea.location,
         dea.date,
         dea.population,
         MAX(vac.total_vaccinations) AS rolling_people_vaccinated,
         CAST (COALESCE ((MAX(vac.total_vaccinations) * 1.0 / population) * 100, 0) AS DECIMAL (10, 2)) AS rolling_people_vaccinated_percentage
FROM     PortfolioProject.dbo.CovidDeaths AS dea
         INNER JOIN
         PortfolioProject.dbo.CovidVaccinations AS vac
         ON vac.location = dea.location
            AND vac.date = dea.date
WHERE    dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.date, dea.population
ORDER BY rolling_people_vaccinated DESC;