-- Olympics Host Advantage Analysis
-- Database: PostgreSQL



--table 1: Athlete Events
--contains all olympic athlete participation records
CREATE TABEL IF NOT EXISTS athlete_events(
    "ID" BIGINT,
    "Name" TEXT,
    "Sex" TEXT,
    "Age" DOUBLE PRECISION,
    "Height" DOUBLE PRECISION,
    "Weight" DOUBLE PPRECISION,
    "Team" TEXT,
    "NOC" TEXT,
    "Games" TEXT,
    "Year" BIGINT,
    "Season" TEXT,
    "City" TEXT,
    "Sport" TEXT,
    "Event" TEXT,
    "Medal" TEXT
);

--table 2: NOC Regions
--Maps NOC codes to country names
CREATE TABLE IF NOT EXISTS noc_regions (
    "NOC" TEXT PRIMARY KEY,
    "Region" TEXT,
    "notes" TEXT
);

--table 3: host cities
--maps olympic to the host
CREATE TABLE IF NOT EXISTS host_cities (
    "CITY" TEXT,
    "Host_Country" TEXT
)