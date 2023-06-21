CREATE TEMPORARY TABLE temptsupply AS
SELECT "Id", 
"ClientId",
"SupplyStatusId",
"DeviceId","FeederName",
"FeederType","ServiceBand",
"Status","VoltageSupplied",
"CurrentSupplied","CommunityId",
"CommunityName","StateName",
"StateCode","LgaName","LgaCode",
"HostAddress","HostName","Longitude",
"Latitude","BatteryLevel",
"SignalStrength","SupplyZoneId",
DATE("DateUpdated") as "Date_Updated",
"DateUpdated"::TIME as Time_Updated,
"DateUpdated" as "DateTimeUpdated",
"CurrentSupplied1","CurrentSupplied2",
"CurrentSupplied3","VoltageSupplied1",
"VoltageSupplied2","VoltageSupplied3","FromDate","ToDate",
COALESCE(EXTRACT(EPOCH FROM ("ToDate" - "FromDate"))/ 60, 0) AS "SupplyDuration"
from public."SupplyHistories";


DELETE FROM temptsupply 
WHERE "Id" IN 
(SELECT "Id" FROM temptsupply ORDER BY "Id" LIMIT 2);

--ALTER COLUMN column_name TYPE new_datatype;
alter table temptsupply
alter column "ClientId" type text,
alter column "SupplyStatusId" type text,
alter column "Status" type text;

select * from temptsupply
order by "Id" desc;

drop table temptsupply



select * from temptsupply
where "Status" = '0'

-----------------
-- this sum the time intervals recorded for a time column
SELECT SUM("time_updated"::INTERVAL) AS total_time
FROM temptsupply;
---------------------
SELECT
  EXTRACT(EPOCH FROM SUM("time_updated")) / 3600 AS total_hours
FROM
  (
    SELECT
      "time_updated"::TIME AS "time_updated"
    FROM
      temptsupply
  ) AS subquery;

-------------------------
----------------------------
--GEtting monitoring time in seconds
WITH interval_data AS (
    SELECT 
        "time_updated",
        LAG("time_updated") OVER (ORDER BY "time_updated") AS previous_timestamp
    FROM temptsupply
)
SELECT 
    SUM(EXTRACT(EPOCH FROM ("time_updated" - previous_timestamp))) AS total_monitoring_time
FROM interval_data;
