--Select *
--From PortfolioProject..CovidDeaths
--Where continent is not null  
--order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4


---Select Location,date,total_cases,total_deaths,population
---From PortfolioProject..CovidDeaths
---order by 1,2

---Looking at Total Cases vs Deaths
--- Shows the likelihood of dying if you contract covid in your country

--Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)* 100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--WHERE location like '%Georgia%'
--order by 1,2

---- Looking at Total Cases vs Population
---- Shows what percentage of population got Covid

--Select Location,date,total_cases,population,(total_cases/population)* 100 as PercentPopulationInfected 
--From PortfolioProject..CovidDeaths
--WHERE location like '%Georgia%'
--order by 1,2

---Looking at Countries with Highest Infection Rate compared to Population	

--Select Location,Population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as PercentPopulationInfected
--From PortfolioProject..CovidDeaths
--WHERE location like '%Georgia%'
--Group by location,population
--order by PercentPopulationInfected desc


---Showing Countries with Highest Death	count per Population

--Select Location,MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--WHERE location like '%Georgia%'
--Where continent is not null 
--Group by location
--order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

--Select continent,MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--WHERE location like '%Georgia%'
--Where continent is not null 
--Group by continent
--order by TotalDeathCount desc

-- Showing continents with the highest death count per population

--Select continent,MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--WHERE location like '%Georgia%'
--Where continent is not null 
--Group by continent
--order by TotalDeathCount desc


-- Global Numbers

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--Where location like '%Georgia%'
--where continent is not null
--Group By date
--order by 1, 2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.location,
-- dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
--from PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists 
Create Table 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating Veiw store data for later vizualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollinngPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	     On dea.location = vac.location
		 and dea.date = vac.date
where dea.continent is not null


Select *
From PercentPopulationVaccinated