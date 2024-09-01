/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Select Data that we are going to be starting with

Select Location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject..CovidDeaths
where Continent is Not Null
order by 1,2

--Showing Total Cases Vs Total Deaths
--Likelihood of contracting Covid in your country e.g UK

Select location,date,total_cases,total_deaths,
(CAST(total_deaths AS float)/total_cases)*100 As Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%kingdom%'
order by 1,2

--Showing Total Cases Vs Population
--Shows percentage of people who got Covid in your country e.g UK
Select location,date,population, total_cases,
(CAST(total_cases AS float)/population)*100 As Percent_Population_Infected
from PortfolioProject..CovidDeaths
where location like '%kingdom%'
order by 1,2

--Showing countries with Highest Infection Rate compared to population

Select location,population,MAX(total_cases) As Highest_Infection_Count,
(CAST(MAX(total_cases)As float)/population)*100 AS Highest_Infection_Rate
from PortfolioProject..CovidDeaths
where Continent is Not Null
group by location,population
order by Highest_Infection_Rate Desc

--Showing countries with Highest Death Count per population

Select location,population,MAX(total_deaths) As Highest_Death_Count,
(CAST(MAX(total_deaths)As float)/population)*100 AS Highest_Death_Rate
from PortfolioProject..CovidDeaths
where Continent is Not Null
group by location,population
order by Highest_Death_Rate Desc

----Showing countries with Highest Death Count

Select location,MAX(total_deaths) As Highest_Death_Count
from PortfolioProject..CovidDeaths
where Continent is not null
group by location
order by Highest_Death_Count Desc

-- BREAKING THINGS DOWN BY CONTINENT

--- Showing contintents with the highest death count per population
Select continent,MAX(total_deaths) As Highest_Death_Count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by Highest_Death_Count Desc

--Global Numbers

Select date,SUM(new_cases) As TotalCases,SUM(new_deaths) As TotalDeaths,
CAST(SUM(new_deaths)as float)/SUM(new_cases) *100 As Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by DATE
order by Death_Percentage

--Total Population Vs Vaccination 
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent,dea.location,dea.population,dea.date,vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations as Float)) over (partition by dea.location order by dea.location,dea.date )
As Tot_New_Vac
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopVsVac (continent,location,population,date,new_vaccinations,Tot_New_Vac) 
As (
Select dea.continent,dea.location,dea.population,dea.date,vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations as Float)) over (partition by dea.location order by dea.location,dea.date )
As Tot_New_Vac
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
)
Select continent,date,population,(Tot_New_Vac/Population)*100 As VaccinatedRate
from PopVsVac
order by VaccinatedRate DESC


---- Using Temp Table to perform Calculation on Partition By in previous query
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
population numeric,
date datetime,
new_vaccinations numeric,
Tot_New_Vac numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.population,dea.date,vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations as Float)) over (partition by dea.location order by dea.location,dea.date )
As Tot_New_Vac
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vacc
on dea.location=vacc.location
and dea.date=vacc.date
Select continent,date,population,(Tot_New_Vac/Population)*100 As VaccinatedRate
from #PercentPopulationVaccinated

--Creating View to store data for later visualisation

Create View PercentPopulationVaccinated As
Select dea.continent,dea.location,dea.population,dea.date,vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations as Float)) over (partition by dea.location order by dea.location,dea.date )
As Tot_New_Vac
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
