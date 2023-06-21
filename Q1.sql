SELECT * FROM public."SupplyStatuses"

SELECT * FROM public."SupplyHistories"
order by "DateUpdated" desc
--limit 30
where "StateName" = 'ONDO'

SELECT  COUNT(DISTINCT "StateName"), "StateName"
FROM "SupplyHistories"
group by "StateName";

SELECT  COUNT(*), "StateName"
FROM "SupplyHistories"
group by "StateName";

WITH cte AS (
    SELECT "Id", "ClientId", "SupplyStatusId","DeviceId","FeederName","FeederType","ServiceBand", 
	"Status","VoltageSupplied","CurrentSupplied","CommunityId","CommunityName","StateName",
	"StateCode","LgaName","LgaCode","HostAddress","HostName","Longitude","Latitude","BatteryLevel",
	"SignalStrength","SupplyZoneId","DateUpdated","CurrentSupplied1","CurrentSupplied2",
	"CurrentSupplied3","VoltageSupplied1","VoltageSupplied2","VoltageSupplied3","FromDate","ToDate" 
	FROM public."SupplyStatuses"
    --WHERE condition
),
updated_cte AS (
    DELETE FROM cte
	WHERE Id IN (SELECT Id FROM cte ORDER BY Id LIMIT 2)
    RETURNING *
)

CREATE TABLE supplytable AS
SELECT *
FROM updated_cte;

alter table supplytable
alter column ClientId type text,
alter column SupplyStatusId type text,
alter column Status type text;

select * from supplytable



-- Step 1: Create the temporary table
CREATE TEMPORARY TABLE temp_table AS
SELECT "Id", "ClientId", "SupplyStatusId","DeviceId","FeederName","FeederType","ServiceBand", 
	"Status","VoltageSupplied","CurrentSupplied","CommunityId","CommunityName","StateName",
	"StateCode","LgaName","LgaCode","HostAddress","HostName","Longitude","Latitude","BatteryLevel",
	"SignalStrength","SupplyZoneId","DateUpdated","CurrentSupplied1","CurrentSupplied2",
	"CurrentSupplied3","VoltageSupplied1","VoltageSupplied2","VoltageSupplied3","FromDate","ToDate" 
FROM public."SupplyStatuses"
WHERE condition;

-- Step 2: Delete the first two rows from the temporary table
WITH deleted_rows AS (
    DELETE FROM temp_table
    WHERE Id IN (SELECT Id FROM temp_table LIMIT 2)
    RETURNING *
)
-- Step 3: Create the final table with altered column data types
CREATE TABLE supply AS
SELECT *
FROM deleted_rows;

-- Step 4: Alter the column data types in the supplytable
ALTER TABLE supply
alter column ClientId type text,
alter column SupplyStatusId type text,
alter column Status type text;


-- Step 5: Display the cleaned and manipulated table
SELECT *
FROM supplytable;




--- try describe table






--with supplytable as (
	
select "Id", "ClientId", "SupplyStatusId","DeviceId","FeederName","FeederType","ServiceBand",
"Status","VoltageSupplied","CurrentSupplied","CommunityId","CommunityName","StateName",
"StateCode","LgaName","LgaCode","HostAddress","HostName","Longitude","Latitude","BatteryLevel",
"SignalStrength","SupplyZoneId","DateUpdated","CurrentSupplied1","CurrentSupplied2",
"CurrentSupplied3","VoltageSupplied1","VoltageSupplied2","VoltageSupplied3","FromDate","ToDate" 
from public."SupplyHistories")
select * from supplytable

--DELETE FROM supplytable
--WHERE Id IN (SELECT Id FROM supplytable ORDER BY Id LIMIT 2);

alter table supplytable 
alter column Id type text;
alter table supplytable alter column ClientId type text;
alter table supplytable alter column SupplyStatusId type text;
alter table supplytable alter column Status type text;

select * from supplytable