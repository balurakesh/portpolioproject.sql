SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathoercentage
FROM [dbo].[CovidDeaths] where location like '%states%' 
order by 1,2
UPDATE [dbo].[CovidDeaths] SET total_deaths=50 Where total_cases=103436829
SP_HELP 'CovidDeaths'

ALTER TABLE CovidDeaths ALTER COLUMN total_deaths BIGINT

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases),(total_deaths/total_cases)*100 as deathpercentage
FROM [dbo].[CovidDeaths] where location like '%states%'
order by 3 desc,4 desc,5 desc
rollback
DROP TABLE IF EXISTS [dbo].[CovidDeaths]
SELECT Location,date,total_cases,population,(total_cases/population)*100 as deathpercentage
FROM [dbo].[CovidDeaths] 
order by 3 desc,5 desc

SELECT LOCATION,population,MAX(total_cases) as HighInfectionCount,MAX((TOTAL_CASES/POPULATION)*100) AS PERCENTPOPULATIONINFECTED
FROM [dbo].[CovidDeaths] 
Group by LOCATION,population
order by percentpopulationinfected desc

SELECT Continent,MAX(total_deaths) as DeathCount
FROM [dbo].[CovidDeaths]
Where Continent is NOT NULL
Group by Continent
order by DeathCount desc

SELECT date,SUM(new_cases),SUM(new_deaths),(SUM(new_deaths)/NULLIF(SUM(new_cases),0))*100 as Deathpercentage
FROM [dbo].[CovidDeaths]
Where Continent is NOT NULL
Group by date
order by 4 desc

SELECT * FROM [dbo].[CovidVacinations]

 SELECT DEA.CONTINENT,DEA.LOCATION,DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
 SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))OVER(PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) AS
 ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
 JOIN CovidVacinations VAC
 ON DEA.location=VAC.location and
 DEA.DATE=VAC.DATE
 WHERE DEA.Continent IS NOT NULL
 ORDER BY 2,3 

 WITH POPVSVAC (CONTINENT,LOCATION,DATE,POPULATION,NEW_VACCINATIONS,ROLLINGPEOPLEVACCINATED)
 AS 
 (
 SELECT DEA.CONTINENT,DEA.LOCATION,DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
 SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))OVER(PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) AS
 ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
 JOIN CovidVacinations VAC
 ON DEA.location=VAC.location and
 DEA.DATE=VAC.DATE
 WHERE DEA.Continent IS NOT NULL
 --ORDER BY 2,3 
 )
 SELECT *,(ROLLINGPEOPLEVACCINATED/POPULATION)*100
 FROM POPVSVAC


 --TEMP TABLE
 CREATE TABLE #PERCENTPOPULATIONVACCINATED
 (
 CONTINENT VARCHAR(255),

 CREATE VIEW PERCENTPOPULATIONVACCINATED AS
 SELECT DEA.CONTINENT,DEA.LOCATION,DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
 SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))OVER(PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) AS
 ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
 JOIN CovidVacinations VAC
 ON DEA.location=VAC.location and
 DEA.DATE=VAC.DATE
 WHERE DEA.Continent IS NOT NULL
 --ORDER BY 2,3 
