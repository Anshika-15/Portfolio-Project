SELECT * 
FROM Portfolioproject ..Coviddeaths
ORDER BY 3,4;

SELECT *
FROM Portfolioproject ..CovidVaccinations
ORDER BY 3,4;

-- SELECT DATA WE ARE GOING TO BE USING

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject ..Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

--LOOKING AT TOTAL CASES VS TOTAL DAETHS
--SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100 , 2)AS Deaths_percentage
FROM Portfolioproject ..Coviddeaths
WHERE continent IS NOT NULL 
AND location LIKE 'India' 
ORDER BY 1,2;

--LOOKING AT TOTAL CASES VS POPULATION
--SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percent_population_affected
FROM Portfolioproject ..Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT location, population,  MAX(total_cases) AS Highest_infection_count, MAX((total_cases/population))*100 AS Percent_population_affected
FROM Portfolioproject ..Coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Percent_population_affected DESC;

-- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location, population, MAX(CAST(total_deaths as int)) AS Highest_death_count, MAX(CAST(total_deaths AS INT) / population) * 100 AS Percent_population_died
FROM Portfolioproject ..Coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Percent_population_died DESC;

-- COUNTING GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(CAST(total_deaths AS INT)) AS total_deaths, SUM(new_cases)/SUM(CAST(total_deaths AS INT)) * 100 AS Death_Percentage
FROM Portfolioproject ..Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- LOOKING AT TOTAL POPULATIONS VS VACCINATIONS


WITH PopvsVaccinations(continent, location, date, population,new_vaccinations,rolling_people_vaccinated) AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM Portfolioproject ..Coviddeaths dea
JOIN Portfolioproject ..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT * , (rolling_people_vaccinated / population) * 100 
FROM PopvsVaccinations


-- CREATING VIEW TO STORE DATA FOR LATER

CREATE VIEW PercentPopulationVaccinated
AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM Portfolioproject ..Coviddeaths dea
JOIN Portfolioproject ..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


-- 



