
----Creating a database named dataexplorationdatabase
create DATABASE dataexplorationdatabase;

-----Retreiving data from the two tables we just exported
select * from covidvaccinationinfo;
select * from CovidDeathInfo where continent is not null

-----Total cases vs total deaths
select location, date, total_cases, total_deaths,
cast(total_deaths/cast (total_cases as decimal(38,4))as decimal(38,4))*100 as DeathPercentage
from CovidDeathInfo where continent is not null order by [date] DESC

select location, date, total_cases, total_deaths,
cast(total_deaths/cast (total_cases as decimal(38,4))as decimal(38,4))*100 as DeathPercentage
from CovidDeathInfo where location='India' and continent is not null  order by [date] DESC

-----Total cases vs population
select location, date, total_cases, population,
cast(total_cases/cast(population as decimal(38,4))as decimal(38,4))*100 as DeathPercentage 
from CovidDeathInfo order by [date] DESC

select location, date, total_cases, population,
cast(total_cases/cast(population as decimal(38,4))as decimal(38,4))*100 as DeathPercentage 
from CovidDeathInfo where location='United states' order by [date] DESC

------Countries with highest infection Rate compared to population
select location, population, MAX(total_cases) as highest_infection_count, 
max(cast(total_cases/cast(population as decimal(38,2))as decimal(38,2))*100 )
as population_infected from CovidDeathInfo 
group by [location],population
order by population_infected DESC

-----Countries with the highest death count per population by location
select location, max(total_deaths) as total_death_count 
from CovidDeathInfo
where continent is not null group by [location] 
order by total_death_count desc

 -----Countries with the highest death count per population by continent
 select continent, max(total_deaths) as total_death_count 
from CovidDeathInfo
where continent is not null
group by [continent] 
order by total_death_count desc

 ------new cases, new deaths and death percentage
 select date,sum(new_cases) as total_new_cases, 
 sum(new_deaths) as total_new_deaths, 
 sum(cast(new_deaths as decimal(38,0)))/nullif(sum(cast(new_cases as decimal(38,0))),0)*100 as Deathpercentage 
 from CovidDeathInfo 
 group by [date]
 order by [date] DESC

 -----How many people got vaccinated out of the whole population in India
 select dea.continent, dea.location, dea.DATE, dea.population, vac.new_vaccinations
 from CovidDeathInfo as dea
 join covidvaccinationinfo as vac 
 on dea.[location]=vac.[location]
 and dea.date=vac.[date]
 where dea.continent is not NULL
 and dea.location='India'
 order by dea.date DESC

  -----How many people got vaccinated out of the whole population 
 select dea.continent, dea.location, dea.DATE, dea.population, vac.new_vaccinations
 from CovidDeathInfo as dea
 join covidvaccinationinfo as vac 
 on dea.[location]=vac.[location]
 and dea.date=vac.[date]
 where dea.continent is not NULL
 order by vac.new_vaccinations DESC


-------vaccination per population percentage
 select dea.continent, dea.location, dea.DATE, dea.population, cast(vac.new_vaccinations as bigint),
 cast(vac.new_vaccinations as decimal(38,4))/cast(dea.population as decimal(38,4)) * 100 as vaccination_per_population_percent
 from CovidDeathInfo as dea
 join covidvaccinationinfo as vac 
 on dea.[location]=vac.[location]
 and dea.date=vac.[date]
 where dea.continent is not NULL
 order by  vaccination_per_population_percent DESC

 -------creating temperory table
 create table #temptable(
    continent nvarchar(max),
    location nvarchar(max),
    date date,
    population bigint,
    new_vaccinations bigint,
    vaccination_per_population_percentage DECIMAL(38,4)
 )
 insert into #temptable
 select dea.continent, dea.location, dea.DATE, dea.population, cast(vac.new_vaccinations as bigint),
 cast(vac.new_vaccinations as decimal(38,4))/cast(dea.population as decimal(38,4)) * 100 as vaccination_per_population_percent
 from CovidDeathInfo as dea
 join covidvaccinationinfo as vac 
 on dea.[location]=vac.[location]
 and dea.date=vac.[date]
 where dea.continent is not NULL
 order by  vaccination_per_population_percent DESC

 select * from #temptable;
 drop table #temptable