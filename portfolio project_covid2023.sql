/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

select*
from PortfolioProjectCovid2023..CovidDeaths
Where continent is not null 
order by 3,4




--Select Data that we are going to be starting with

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProjectCovid2023..CovidDeaths
Where continent is not null 
order by 1,2




-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

--total deaths and total cases are nvarchar type- we should change them to int
From PortfolioProjectCovid2023..CovidDeaths
alter table [CovidDeaths]
alter column [total_deaths] int

From PortfolioProjectCovid2023..CovidDeaths
alter table [CovidDeaths]
alter column [total_cases] int

Select Location, date, total_cases,total_deaths, round((total_deaths*100.0/total_cases),2) as DeathPercentage
From PortfolioProjectCovid2023..CovidDeaths
Where location like '%greece%'
and continent is not null 
order by 1,2




-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  round((total_cases/population)*100,2)as PercentPopulationInfected
From PortfolioProjectCovid2023..CovidDeaths
Where location like '%greece%'
order by 1,2




-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectCovid2023..CovidDeaths
--Where location like '%greece%'
Group by Location, Population
order by PercentPopulationInfected desc




-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjectCovid2023..CovidDeaths
--Where location like '%greece%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjectCovid2023..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc




-- GLOBAL NUMBERS TOTAL
--per day
Select SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_daily_deaths, SUM(new_deaths )/SUM(New_Cases)*100 as DeathPercentageFrom PortfolioProjectCovid2023..CovidDeaths
where continent is not null --Group By dateorder by 1,2




-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select*
from PortfolioProjectCovid2023..CovidVaccinations vac
join PortfolioProjectCovid2023..CovidDeaths dea
on dea.location=vac.location
and dea.date=vac.date


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjectCovid2023..CovidVaccinations vac
join PortfolioProjectCovid2023..CovidDeaths dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
order by 2,3


-- We need a CTE
--Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjectCovid2023..CovidVaccinations vac
join PortfolioProjectCovid2023..CovidDeaths dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

--step 1
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

--step 2
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

from PortfolioProjectCovid2023..CovidVaccinations vac
join PortfolioProjectCovid2023..CovidDeaths dea
on dea.location=vac.location
and dea.date=vac.date

--step 3
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations
Create View RollingPeopleVaccinated asSelect dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinatedfrom PortfolioProjectCovid2023..CovidVaccinations vac
join PortfolioProjectCovid2023..CovidDeaths dea
on dea.location=vac.location
and dea.date=vac.datewhere dea.continent is not null Select *
From RollingPeopleVaccinated