/*EXPLORING WORLD HAPPINESS REPORT 2021 DATA*/


--Complete Report
SELECT *
FROM WorldHappinessReport2021$


--Country Rank and Score
SELECT [Country name], [Ladder score] 
FROM WorldHappinessReport2021$


--Least Happiest countries
SELECT TOP(10) [Country name], [Regional Indicator], [Ladder score] 
FROM WorldHappinessReport2021$
ORDER BY 3


--Happiest Countries
SELECT TOP(10) [Country name], [Regional Indicator], [Ladder score] 
FROM WorldHappinessReport2021$
ORDER BY 3 DESC


--Showing the number of countries in each region with a ladder score greater than 6.0
SELECT DISTINCT([Regional indicator]) AS Region, COUNT([Regional Indicator]) AS [Number of Countries]
FROM WorldHappinessReport2021$
WHERE [Ladder score] > 6
GROUP BY [Regional indicator]
ORDER BY 2 DESC


--Showing the happiest regions
SELECT [Regional Indicator], AVG([Ladder score]) AS [Average Ladder Score]
FROM WorldHappinessReport2021$
GROUP BY [Regional Indicator]
ORDER BY 2 DESC


--Healthy life expectancy
--Lowest
SELECT TOP(10) [Country name], [Ladder score], [Healthy life expectancy] 
FROM WorldHappinessReport2021$
ORDER BY 3 

--Highest
SELECT TOP(10) [Country name], [Ladder score], [Healthy life expectancy] 
FROM WorldHappinessReport2021$
ORDER BY 3 DESC


--Perceptions of Corruption
--Lowest
SELECT TOP(10) [Country name], [Ladder score], [Perceptions of corruption]
FROM WorldHappinessReport2021$
ORDER BY 3 

--Highest
SELECT TOP(10) [Country name], [Ladder score], [Perceptions of corruption]
FROM WorldHappinessReport2021$
ORDER BY 3 DESC


--Freedom to make life choices
--Lowest
SELECT TOP(10) [Country name], [Ladder score], [Freedom to make life choices]
FROM WorldHappinessReport2021$
ORDER BY 3

--Highest
SELECT TOP(10) [Country name], [Ladder score], [Freedom to make life choices]
FROM WorldHappinessReport2021$
ORDER BY 3 DESC


--Generosity
--Lowest
SELECT TOP(10) [Country name], [Ladder score], [Generosity]
FROM WorldHappinessReport2021$
ORDER BY 3

--Highest
SELECT TOP(10) [Country name], [Ladder score], [Generosity]
FROM WorldHappinessReport2021$
ORDER BY 3 DESC







