/*COVID-19 DATA ANALYSIS PROJECT*/


--Showing full Covid Deaths Table.
SELECT *
FROM CovidDeaths$
WHERE continent is not null
Order by 3,4


--Showing full Covid Vaccinations Table.
SELECT *
FROM CovidVaccinations$
Order by 3,4

--Covid Deaths table showing Cases and Deaths.
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths$
Order by 1,2

--Total cases vs Total deaths
--Shows the percentage of deaths per cases in different countries.
SELECT location, continent, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as PercentageDeath 
FROM CovidDeaths$
WHERE continent is not null
Order by 1,2

--Total cases vs Population
--Shows the percentage of the population that got Covid.
SELECT location, continent, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected 
FROM CovidDeaths$
WHERE continent is not null
Order by 1,2


--Showing Countries with highest infection rate compared to Population
SELECT location, continent, population, MAX(total_cases) AS HighestCaseCount, MAX((total_cases/population)*100) as PercentagePopulationInfected 
FROM CovidDeaths$
WHERE continent is not null
Group by location, continent, population
Order by 4 DESC


--Showing Countries with highest death count compared to Population
SELECT location, continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM CovidDeaths$
WHERE continent is not null
Group by location, continent
Order by 3 DESC

--Showing Highest death count per continent
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM CovidDeaths$
WHERE continent is null AND location <> 'world'
Group by location
Order by 2 DESC



--For visualisation purposes, editing above code
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM CovidDeaths$
WHERE continent is not null
--where location like '%kingdom%'
Group by continent
Order by 2 DESC



--GLOBAL NUMBERS

--By Date
SELECT date, SUM(new_cases) as TotalGlobalCases, 
SUM(CAST(new_deaths AS int)) as TotalGlobalDeaths, 
SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as GlobalPercentageDeathPerCase 
FROM CovidDeaths$
WHERE continent is not null
Group by date
Order by 1,2

--Without Date
SELECT SUM(new_cases) as TotalGlobalCases, 
SUM(CAST(new_deaths AS int)) as TotalGlobalDeaths, 
SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as GlobalPercentageDeathPerCase 
FROM CovidDeaths$
WHERE continent is not null
Order by 1,2


--Looking at Total Population vs Vaccination
--Showing the number of people in the population vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as TotalVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3
--To show percentage, a CTE or Temp Table can be used.
--Using CTE
WITH PopVsVac (Continent, location, date, population, new_vaccinations, TotalVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as TotalVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)

Select *, (TotalVaccinated/population)*100 AS PercentageVaccinated
FROM PopVsVac

--Using Temp Tables

DROP TABLE IF EXISTS #PercentVaccinated 
CREATE TABLE #PercentVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
TotalVaccinated numeric)

Insert into #PercentVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as TotalVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

Select *, (TotalVaccinated/population)*100 AS PercentageVaccinated
FROM #PercentVaccinated





/*CREATING VIEWS TO STORE DATA FOR LATER VISUALIZATIONS*/

--PERCENTAGE POPULATION VACCINATED
Create View PercentagePopulationVaccinated AS
WITH PopVsVac (Continent, location, date, population, new_vaccinations, TotalVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as TotalVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)

Select *, (TotalVaccinated/population)*100 AS PercentageVaccinated
FROM PopVsVac

SELECT *
FROM PercentagePopulationVaccinated

--TOTAL VACCINATIONS
CREATE VIEW TotalVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as TotalVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

SELECT * 
FROM TotalVaccinated

--GLOBAL DEATH RATE
CREATE VIEW GlobalDeathPercentagePerCase AS
SELECT SUM(new_cases) as TotalGlobalCases, 
SUM(CAST(new_deaths AS int)) as TotalGlobalDeaths, 
SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as GlobalPercentageDeathPerCase 
FROM CovidDeaths$
WHERE continent is not null

SELECT *
FROM GlobalDeathPercentagePerCase

--DEATH COUNT

CREATE VIEW DeathCount AS
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM CovidDeaths$
WHERE continent is not null
--where location like '%kingdom%'
Group by continent

SELECT *
FROM DeathCount

--DEATH COUNT BY LOCATION
CREATE VIEW DeathCountByLocation AS
SELECT location, continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM CovidDeaths$
WHERE continent is not null
--where location like '%kingdom%'
Group by location, continent

SELECT * 
FROM DeathCountByLocation

--PERCENT POPULATION INFECTED
CREATE VIEW PercentPopulationInfected AS
SELECT location, continent, population, MAX(total_cases) AS HighestCaseCount, MAX((total_cases/population)*100) as PercentagePopulationInfected 
FROM CovidDeaths$
WHERE continent is not null
--where location like '%kingdom%'
Group by location, continent, population

SELECT * 
FROM PercentPopulationInfected