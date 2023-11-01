--Looking at Total cases vs total Deaths
--Shows likleihood of dating if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeath
where location like'%states%'
order by 1,2 

--Looking at Total cases vs Population
Select location, date, total_cases, total_deaths,population, (total_cases/Population)*100 PercentPopulationInfected
from CovidDeath
order by 1,2 

--Looking at the Countries with Highest Infection Rate compared to Population
Select location,population, max(total_cases) as HighstInfectionCount, max((total_cases/Population))*100 as PercentPopulationInfected
from CovidDeath
Group by location, population
order by PercentPopulationInfected desc

--Looking at the Countries with Highest death Rate compared to Population
Select continent, max(total_deaths) as HighstDeathCount from CovidDeath
where continent is not null
Group by continent
order by HighstDeathCount desc

--GLOBAL NUMBERS

Select date, Sum(new_cases) as newcases ,Sum (new_deaths) as newdeaths,(Sum(new_deaths)/Sum (new_cases))*100 as DeathPercenatge
from CovidDeath
where continent is not null and new_cases<>0
Group by date 
order by 1,2 



Select Sum(new_cases) as total_cases ,Sum (new_deaths) as total_deaths,(Sum(new_deaths)/Sum (new_cases))*100 as DeathPercenatge
from CovidDeath
where continent is not null 
order by 1,2 


--vaccinations vs Population

with PopvsVac (continent , location , date , Population, new_vaccinations , RollingPeopleVccinated)
as (
Select CovidDeath.continent, CovidDeath.location,CovidDeath.date , CovidDeath.population , CovidVaccinations.new_vaccinations
,sum(Convert(bigint,CovidVaccinations.new_vaccinations )) over(Partition by CovidDeath.location order by CovidDeath.location , CovidDeath.date) as RollingPeopleVccinated
from CovidDeath
join CovidVaccinations
on CovidDeath.location = CovidVaccinations.location 
and CovidDeath.date = CovidVaccinations.date
where CovidDeath.continent is not null and new_vaccinations is not null
)
Select * ,(RollingPeopleVccinated/Population)*100 as RollingPeopleVccinatedPercentage
from PopvsVac



Create View  PercentPopulationVccinated as
(
Select CovidDeath.continent, CovidDeath.location,CovidDeath.date , CovidDeath.population , CovidVaccinations.new_vaccinations
,sum(Convert(bigint,CovidVaccinations.new_vaccinations )) over(Partition by CovidDeath.location order by CovidDeath.location , CovidDeath.date) as RollingPeopleVccinated
from CovidDeath
join CovidVaccinations 
on CovidDeath.location = CovidVaccinations.location 
and CovidDeath.date = CovidVaccinations.date
where CovidDeath.continent is not null and new_vaccinations is not null
)

Select * from PercentPopulationVccinated
Order by 2, 3



