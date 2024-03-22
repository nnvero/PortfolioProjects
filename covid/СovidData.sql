select * from PortfolioProject..CovidDeaths 
order by 3,4

-- 1. Select data I'm going to use
SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths 
ORDER BY 1,2

-- 2. Total cases VS total deaths, percentage of people who got infected and died
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deaths_percentage 
FROM PortfolioProject..CovidDeaths  
WHERE location = 'Ukraine' 
ORDER BY 1,2

-- 3. Total cases VS population. Shows what percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as infected_percentage 
FROM PortfolioProject..CovidDeaths  
WHERE location = 'Ukraine' 
ORDER BY 1,2

-- 4. Countries with highest infetion rate compared to the population
SELECT location, population, MAX(total_cases) as highest_total_cases, MAX((total_cases/population)*100) as max_infected_percentage 
FROM PortfolioProject..CovidDeaths  
GROUP BY location, population 
ORDER BY max_infected_percentage desc

-- 5. Countries with highest deaths rate (campared to population)
SELECT location, population, MAX(total_deaths) as highest_total_deaths, MAX((total_deaths/population)*100) as max_deaths_percentage 
FROM PortfolioProject..CovidDeaths  
GROUP BY location, population 
ORDER BY max_deaths_percentage desc

SELECT location, MAX(CAST(total_deaths as int)) as max_deaths
FROM PortfolioProject..CovidDeaths
GROUP BY location
ORDER BY max_deaths desc
 
-- Why do nulls appear 
SELECT * 
FROM PortfolioProject..CovidDeaths 
WHERE location in (SELECT location FROM PortfolioProject..CovidDeaths GROUP BY location HAVING MAX(CAST(total_deaths as int)) is NULL)

-- 6. Breaking down by continents. Showing continents with highest deaths counts
SELECT continent, MAX(CAST(total_deaths as int)) as max_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY max_deaths desc

SELECT location, MAX(CAST(total_deaths as int)) as max_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY max_deaths desc

-- 7. Global numbers
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deaths_percentage 
FROM PortfolioProject..CovidDeaths  
WHERE continent is not NULL 
ORDER BY 1,2

-- New cases for each date in the world
SELECT date, SUM(new_cases) as sum_new_cases
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL 
GROUP BY date
ORDER BY sum_new_cases desc

-- New deaths for each date
SELECT date, SUM(CAST(new_deaths as int)) as sum_new_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL 
GROUP BY date
ORDER BY sum_new_deaths desc

-- New deaths - new cases ratio
SELECT date, SUM(new_cases) as sum_new_cases, SUM(CAST(new_deaths as int)) as sum_new_deaths, (SUM(CAST(new_deaths as int)) / SUM(new_cases))*100 as deaths_to_ncases_ratio
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL 
GROUP BY date
ORDER BY deaths_to_ncases_ratio desc

-- 8. Joining CovidDeaths and CovidVaccinations tables
SELECT * from PortfolioProject..CovidDeaths as deaths 
JOIN PortfolioProject..CovidVaccinations as vac 
	ON deaths.location = vac.location
	and deaths.date = vac.date

-- 9. Total population VS vaccinations
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths as deaths 
JOIN PortfolioProject..CovidVaccinations as vac 
	ON deaths.location = vac.location
	and deaths.date = vac.date
WHERE deaths.continent is not NULL 
ORDER BY 2,3

-- 10. Counting total vactinations per day using window function
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as rollong_vac_people
FROM PortfolioProject..CovidDeaths as deaths 
JOIN PortfolioProject..CovidVaccinations as vac 
	ON deaths.location = vac.location
	and deaths.date = vac.date
WHERE deaths.continent is not NULL 
ORDER BY 2,3

-- 11. Creating CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, rollong_vac_people) 
as 
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as rollong_vac_people 
FROM PortfolioProject..CovidDeaths deaths 
JOIN PortfolioProject..CovidVaccinations vac 
	ON deaths.location = vac.location 
	and deaths.date = vac.date 
WHERE deaths.continent is not NULL
)
SELECT *, (rollong_vac_people/population) FROM PopvsVac
ORDER BY rollong_vac_people desc

-- 12. Temp table
CREATE TABLE #PercentPeopleVaccinated
(
continent nvarchar(255)
, location nvarchar(255)
, date datetime
, population numeric
, new_vaccinations numeric
, rollong_vac_people numeric
)
INSERT INTO #PercentPeopleVaccinated
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as rollong_vac_people 
FROM PortfolioProject..CovidDeaths deaths 
JOIN PortfolioProject..CovidVaccinations vac 
	ON deaths.location = vac.location 
	and deaths.date = vac.date 
WHERE deaths.continent is not NULL 


SELECT *, (rollong_vac_people/population) FROM #PercentPeopleVaccinated
ORDER BY rollong_vac_people desc

-- 13. Creating view for visualisation
CREATE VIEW PercentPeopleVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as rollong_vac_people 
FROM PortfolioProject..CovidDeaths deaths 
JOIN PortfolioProject..CovidVaccinations vac 
	ON deaths.location = vac.location 
	and deaths.date = vac.date 
WHERE deaths.continent is not NULL 