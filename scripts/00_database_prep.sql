-- Create Database
IF NOT EXISTS (SELECT *
               FROM   sys.databases
               WHERE  name = 'PortfolioProject')
    BEGIN
        CREATE DATABASE PortfolioProject;
    END

USE PortfolioProject;


GO
-- Delete Existing Tables
DROP TABLE IF EXISTS CovidDeaths;

DROP TABLE IF EXISTS CovidVaccinations;

-- Create Tables and Import Data manually using "Import Flat File"
-- CREATE TABLE for reference only
CREATE TABLE CovidDeaths (
    iso_code                           NVARCHAR (50) NOT NULL,
    continent                          NVARCHAR (50),
    Location                           NVARCHAR (50),
    date                               DATE          NOT NULL,
    population                         BIGINT       ,
    total_cases                        BIGINT       ,
    new_cases                          INT          ,
    new_cases_smoothed                 FLOAT        ,
    total_deaths                       INT          ,
    new_deaths                         INT          ,
    new_deaths_smoothed                FLOAT        ,
    total_cases_per_million            FLOAT        ,
    new_cases_per_million              FLOAT        ,
    new_cases_smoothed_per_million     FLOAT        ,
    total_deaths_per_million           FLOAT        ,
    new_deaths_per_million             FLOAT        ,
    new_deaths_smoothed_per_million    FLOAT        ,
    reproduction_rate                  FLOAT        ,
    icu_patients                       INT          ,
    icu_patients_per_million           FLOAT        ,
    hosp_patients                      INT          ,
    hosp_patients_per_million          FLOAT        ,
    weekly_icu_admissions              FLOAT        ,
    weekly_icu_admissions_per_million  FLOAT        ,
    weekly_hosp_admissions             FLOAT        ,
    weekly_hosp_admissions_per_million FLOAT        
);

CREATE TABLE CovidVaccinations (
    iso_code                              NVARCHAR (50) NOT NULL,
    continent                             NVARCHAR (50),
    location                              NVARCHAR (50),
    date                                  DATE          NOT NULL,
    new_tests                             BIGINT       ,
    total_tests                           BIGINT       ,
    total_tests_per_thousand              FLOAT        ,
    new_tests_per_thousand                FLOAT        ,
    new_tests_smoothed                    FLOAT        ,
    new_tests_smoothed_per_thousand       FLOAT        ,
    positive_rate                         FLOAT        ,
    tests_per_case                        FLOAT        ,
    tests_units                           NVARCHAR (50),
    total_vaccinations                    BIGINT       ,
    people_vaccinated                     BIGINT       ,
    people_fully_vaccinated               BIGINT       ,
    new_vaccinations                      BIGINT       ,
    new_vaccinations_smoothed             FLOAT        ,
    total_vaccinations_per_hundred        FLOAT        ,
    people_vaccinated_per_hundred         FLOAT        ,
    people_fully_vaccinated_per_hundred   FLOAT        ,
    new_vaccinations_smoothed_per_million FLOAT        ,
    stringency_index                      FLOAT        ,
    population_density                    FLOAT        ,
    median_age                            FLOAT        ,
    aged_65_older                         FLOAT        ,
    aged_70_older                         FLOAT        ,
    gdp_per_capita                        FLOAT        ,
    extreme_poverty                       FLOAT        ,
    cardiovasc_death_rate                 FLOAT        ,
    diabetes_prevalence                   FLOAT        ,
    female_smokers                        FLOAT        ,
    male_smokers                          FLOAT        ,
    handwashing_facilities                FLOAT        ,
    hospital_beds_per_thousand            FLOAT        ,
    life_expectancy                       FLOAT        ,
    human_development_index               FLOAT        
);