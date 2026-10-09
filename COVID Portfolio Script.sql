select * from PortfolioProject..Covid_Deaths
where continent is not null
order by 1,2;

-- select * from PortfolioProject..Covid_Vaccinations
-- order by 1,2;

select location, date, total_cases, new_cases, total_deaths, population

from PortfolioProject..Covid_Deaths
order by 1,2



-- Looking at total coses vs total deaths
-- Shows likelihood of dying if contracting COVID in UAE

select location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases,0)*100) as death_percentages
from PortfolioProject..Covid_Deaths
where location like '%emirates%' 
order by 1,2

-- Looking at total cases vs population
-- Shows percentage of people in the UAE that got COVID
select location, date, total_cases, population, ((total_cases/population)*100) as percentpopinfected
from PortfolioProject..Covid_Deaths
where location like '%emirates%' 
order by 1,2


-- Looking at countriers with highest infection rates compared to population
select location, population,max(total_cases) as highestinfectioncount, ((max(total_cases/population))*100) as percentpopinfected
from PortfolioProject..Covid_Deaths
group by population, location
order by percentpopinfected desc


--Looking at countries with highest death count compared to population
select location, max(cast(total_deaths as int)) as totaldeaths
from PortfolioProject..Covid_Deaths
where continent is not null
group by location
order by totaldeaths desc


-- breaking things down  by continent
-- showing highest death counts by continent. 
select continent, max(cast(total_deaths as int)) as totaldeaths
from PortfolioProject..Covid_Deaths
where continent is not null
group by continent
order by totaldeaths desc



-- global numbers

-- when doing this, the output shows values weekly data recorded as the data is take from WHO who report it weekly.
-- if you don't want it to show in 7 day intervals, we can use the having function where sum(new_cases)>1
-- also when seeing the first case, the deaths trump the cases. it's like that as the deaths would've been reported before the case was actually filed.
select date, sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, sum(new_deaths)/nullif(sum(new_cases),0)*100 as death_percentages
from PortfolioProject..Covid_Deaths
--where location like '%emirates%' 
where continent is not null
group by date
order by 1,2

-- total number of cases vs total deaths globally
select sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, sum(new_deaths)/nullif(sum(new_cases),0)*100 as death_percentages
from PortfolioProject..Covid_Deaths
--where location like '%emirates%' 
where continent is not null
order by 1,2


-- joining the two tables
-- lloking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))  over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- using CTE
with popvsvac (continent, location, date, population,new_vaccinations, rollingpeoplevaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))  over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, (rollingpeoplevaccinated/population)*100 from popvsvac


--temp table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
rollingpeoplevaccinated numeric
)





insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))  over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


select *, (rollingpeoplevaccinated/population)*100 from #percentpopulationvaccinated




--0 creating view to stroe data for later visualizations
drop view if exists percentpopulationvaccinated
use PortfolioProject
go
create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))  over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select* from percentpopulationvaccinated