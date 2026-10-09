# COVID-19 Data Exploration in SQL Server

## Overview
This project explores global COVID-19 case, death, and vaccination data using SQL Server. It uses T-SQL to clean and query the data, calculate death rates and vaccination progress, and prepare a view for later visualization.

## Dataset
The data comes from the [Our World in Data COVID-19 dataset](https://github.com/owid/covid-19-data), split into two tables and imported from Excel into a database called PortfolioProject:

* Covid_Deaths: cases, deaths, and population by country and date
* Covid_Vaccinations: vaccination figures by country and date

The newer version of this dataset reports many figures weekly, so each row for a date often holds a weekly total rather than a daily one.

## Tools
* SQL Server Express
* SQL Server Management Studio (SSMS)

## SQL Skills Demonstrated
* Filtering and aggregating with WHERE, GROUP BY, and HAVING
* Joining tables on location and date
* Window functions for rolling vaccination totals
* Data type conversion with CAST
* Handling divide by zero errors with NULLIF
* Removing continent and income group aggregates from country level analysis
* Creating a
