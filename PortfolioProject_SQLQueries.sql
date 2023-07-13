/****** Looking through the data about Covid Infections and Vaccinations  ******/

-- Selecting the data that I will be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
Order By Location, date

--Looking at the total cases Vs the total number of deaths
-- Likelihood of dying from Covid per Country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Percentage_of_Deaths
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY Location, date

--Looking at the total cases Vs Population
--Showing what % of population contracted Covid in United Kingdom

SELECT Location, date, total_cases, population, (total_cases/population)*100 AS Contracted_Covid_Percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location LIKE '%kingdom%'
AND continent IS NOT NULL
ORDER BY Location, date

-- Total number of Cases vs the total Population
-- Showing what percentage of the Population got infected with Covid

SELECT Location, date, Population, total_cases, (total_cases/population)*100 as Percentage_Population_Infected
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY Location, date


-- Showing the Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) as Highest_Infection_Count,  Max((total_cases/population))*100 as Percentage_Population_Infected
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, Population
ORDER BY Percentage_Population_Infected DESC


-- Countries with Highest Death Count per Population

SELECT Location, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY Total_Death_Count DESC

-- Showing which Contintents had the highest death count 

SELECT continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC

-- Showing the Global Impact of Covid

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS Percentage_of_Deaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL

-- Showing the Total Population vs number of those who are vaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY Location, date


