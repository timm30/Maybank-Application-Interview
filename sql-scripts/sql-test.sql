/*
My understanding of this question is as follows: 
The data is captured from the "source system" and updated into TableA. However, due to network latency, there may be a delay 
between the time the data is captured by the source system and the time it is actually applied to the target system (TableA). 
This delay refers to the time difference between the "capture time" of the data and the time it is "applied to the target system.

To address this, we can:
1) Create a LatencyLog table
2) Create a trigger to capture the action, do the calculation and finally insert the record into our LatencyLog table

The SQL below are the SQL that are used for testing the trigger.
*/

-- 1) Create Database
CREATE DATABASE TestDB;

-- 2) Create TableA
CREATE TABLE TableA (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Description NVARCHAR(255),
    SourceDate CHAR(6),    -- Format: YYMMDD
    SourceTime CHAR(8)     -- Format: HHmmss.SS
);

-- 3) Create LatencyLog
CREATE TABLE LatencyLog (
    Description NVARCHAR(255),       -- Description of the updated record
    SourceDateTime DATETIME,         -- Time when the data was captured by the source system
    TargetDateTime DATETIME,         -- Time when the data was applied to the target system
    LatencyInSeconds INT             -- Calculated latency in seconds
    -- Note: This table does not have a primary key, as it's meant for logging purposes.
);


-- 4) Create a trigger to calculate and log latency
CREATE TRIGGER CalculateLatency
ON TableA
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LatencyLog (Description, SourceDateTime, TargetDateTime, LatencyInSeconds)
SELECT 
    i.Description,
    CONVERT(DATETIME, 
            '20' + SUBSTRING(i.SourceDate, 1, 2) + '-' + 
            SUBSTRING(i.SourceDate, 3, 2) + '-' + 
            SUBSTRING(i.SourceDate, 5, 2) + ' ' + 
            LEFT(i.SourceTime, 2) + ':' + 
            SUBSTRING(i.SourceTime, 3, 2) + ':' + 
            SUBSTRING(i.SourceTime, 5, 2), 120),  -- Convert SourceDate and SourceTime to DATETIME
    GETDATE(),  -- Current time as TargetDateTime
    DATEDIFF(SECOND, 
             CONVERT(DATETIME, 
                     '20' + SUBSTRING(i.SourceDate, 1, 2) + '-' + 
                     SUBSTRING(i.SourceDate, 3, 2) + '-' + 
                     SUBSTRING(i.SourceDate, 5, 2) + ' ' + 
                     LEFT(i.SourceTime, 2) + ':' + 
                     SUBSTRING(i.SourceTime, 3, 2) + ':' + 
                     SUBSTRING(i.SourceTime, 5, 2), 120), 
             GETDATE())  -- Calculate latency in seconds
FROM inserted i;
END;

-- Insert test data
INSERT INTO TableA (Description, SourceDate, SourceTime)
VALUES ('Test Data', '250119', '22260000'); -- Example: Jan 19, 2025, 22:26:00

-- Update test data to trigger the latency calculation
UPDATE TableA 
SET SourceDate = '250119', SourceTime = '22300000' 
WHERE Description = 'Test Data';
