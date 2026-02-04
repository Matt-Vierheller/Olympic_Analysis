--Olympics Host Advanctage Analysis Queries


--Query 1: total medal count
--how many medals have been awarded
SELECT COUNT(*) AS total_medals
FROM athlete_events
WHERE "Medal"!='None';

--Query 2: Host Cities and Years
--which cities hosted the olympics?
SELECT DISTINCT "City", "Year", "Season"
FROM athlete_events
ORDER BY "Year";


--Query 3: Medal Count by country
--Which countries have the most medals won
--This query counts all athletes that won medals there can be several
--of the same event medals counted. Meaning team sports have a lot more medals

SELECT
    nr.region AS country,
    COUNT(*) AS medal_count
FROM athlete_events AS athlete_events
LEFT JOIN noc_regions nr ON ae."NOC" = nr."NOC"
WHERE ae."Medal" != 'None'
GROUP BY nr.region
ORDER BY medal_count DESC
LIMIT 10;

--Query 4: Host vs Not Host - All Meals by event
--compares average medals when hosting vs not hosting
SELECT
    country,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Summer' THEN medals END),2)
    AS avg_summer_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Not Host' AND season = 'Summer' THEN medals END),2)
    AS avg_summer_not_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Summer' THEN medals END)-
    AVG(CASE WHEN host_status = 'Not Host' AND season = 'Summer' THEN medals END),2) AS summer_difference,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Winter' THEN medals END),2
    AS avg_winter_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Not Host' AND season = 'Winter' THEN medals END),2)
    AS avg_winter_not_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Winter' THEN medals END)-
    AVG(CASE WHEN host_status = 'Not Host' AND season = 'Winter' THEN medals END),2) AS winter_difference)
FROM (
    SELECT
        nr.region AS country,
        ae."Games",
        ae."Season" AS season,
        CASE
            WHEN nr.region = c."Host_Country" Then 'Host'
            ELSE 'Not Host'
        END AS host_status
        COUNT(DISTINCT ae."Event" || ae."MEda'") as medals
    FROM athlete_events AS ae
    JOIN noc_regions AS nr ON ae."NOC" = nr."NOC"
    JOIN host_cities AS hc ON ae."City" = hc."City"
    WHERE ae."Medal" != 'None'
    GROUP BY nr.region, ae."Games", ae."Season", hc."Host_Country"
) AS sub
WHERE country IN (SELECT DISTINCT "Host_Country" FROM host_cities)
GROUP BY country
ORDER BY country;

--Query 5: Gold Medals Only Hosting vs Not Hosting
SELECT 
    country,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Summer' THEN medals END), 2) AS avg_summer_gold_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Not Host' AND season = 'Summer' THEN medals END), 2) AS avg_summer_gold_not_host,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Summer' THEN medals END) - 
          AVG(CASE WHEN host_status = 'Not Host' AND season = 'Summer' THEN medals END), 2) AS summer_gold_difference,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Winter' THEN medals END), 2) AS avg_winter_gold_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Not Host' AND season = 'Winter' THEN medals END), 2) AS avg_winter_gold_not_host,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Winter' THEN medals END) - 
          AVG(CASE WHEN host_status = 'Not Host' AND season = 'Winter' THEN medals END), 2) AS winter_gold_difference
FROM (
    SELECT 
        nr.region AS country,
        ae."Games",
        ae."Season" AS season,
        CASE 
            WHEN nr.region = hc."Host_Country" THEN 'Host'
            ELSE 'Not Host'
        END AS host_status,
        COUNT(DISTINCT ae."Event") AS medals
    FROM athlete_events ae
    JOIN noc_regions nr ON ae."NOC" = nr."NOC"
    JOIN host_cities hc ON ae."City" = hc."City"
    WHERE ae."Medal" = 'Gold'
    GROUP BY nr.region, ae."Games", ae."Season", hc."Host_Country"
) subquery
WHERE country IN (SELECT DISTINCT "Host_Country" FROM host_cities)
GROUP BY country
ORDER BY country;

--Query 6: Russion vs USA Comparison
SELECT 
    country,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Summer' THEN medals END), 2) AS avg_summer_gold_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Not Host' AND season = 'Summer' THEN medals END), 2) AS avg_summer_gold_not_host,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Summer' THEN medals END) - 
          AVG(CASE WHEN host_status = 'Not Host' AND season = 'Summer' THEN medals END), 2) AS summer_gold_difference,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Winter' THEN medals END), 2) AS avg_winter_gold_as_host,
    ROUND(AVG(CASE WHEN host_status = 'Not Host' AND season = 'Winter' THEN medals END), 2) AS avg_winter_gold_not_host,
    ROUND(AVG(CASE WHEN host_status = 'Host' AND season = 'Winter' THEN medals END) - 
          AVG(CASE WHEN host_status = 'Not Host' AND season = 'Winter' THEN medals END), 2) AS winter_gold_difference
FROM (
    SELECT 
        nr.region AS country,
        ae."Games",
        ae."Season" AS season,
        CASE 
            WHEN nr.region = hc."Host_Country" THEN 'Host'
            ELSE 'Not Host'
        END AS host_status,
        COUNT(DISTINCT ae."Event") AS medals
    FROM athlete_events ae
    JOIN noc_regions nr ON ae."NOC" = nr."NOC"
    JOIN host_cities hc ON ae."City" = hc."City"
    WHERE ae."Medal" = 'Gold'
    GROUP BY nr.region, ae."Games", ae."Season", hc."Host_Country"
) subquery
WHERE country IN ('Russia', 'USA')
GROUP BY country
ORDER BY country;

