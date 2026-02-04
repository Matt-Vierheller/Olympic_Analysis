import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
password = 'L@cr0553'
encoded_password = quote_plus(password)
engine = create_engine(f'postgresql://postgres:{encoded_password}@localhost:5432/olympics')



query = """
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
    FROM athlete_event ae
    JOIN noc_regions nr ON ae."NOC" = nr."NOC"
    JOIN host_cities hc ON ae."City" = hc."City"
    WHERE ae."Medal" = 'Gold'
    GROUP BY nr.region, ae."Games", ae."Season", hc."Host_Country"
) subquery
WHERE country IN (SELECT DISTINCT "Host_Country" FROM host_cities)
GROUP BY country
ORDER BY country;
"""

result = pd.read_sql(query, engine)
print(result)
result = pd.read_sql(query, engine)
result.to_csv('host_analysis_gold_medal.csv', index=False)
print("✅ Saved to host_analysis_gold_medal.csv")