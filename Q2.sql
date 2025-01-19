/*
My understanding of this question is as follows: 
The data is captured from the "source system" and updated into TableA. However, due to network latency, there may be a delay 
between the time the data is captured by the source system and the time it is actually applied to the target system (TableA). 
This delay refers to the time difference between the "capture time" of the data and the time it is "applied to the target system.

To address this, we can:
1) Create a LatencyLog table
2) Create a trigger to capture the action, do the calculation and finally insert the record into our LatencyLog table
*/


-- Step 1: Create a LatencyLog table
CREATE TABLE LatencyLog (
    Description NVARCHAR(255),       -- Description of the updated record
    SourceDateTime DATETIME,         -- Time when the data was captured by the source system
    TargetDateTime DATETIME,         -- Time when the data was applied to the target system
    LatencyInSeconds INT             -- Calculated latency in seconds
    -- Note: This table does not have a primary key, as it's meant for logging purposes.
);


-- Step 2: Create a trigger to calculate and log latency
CREATE TRIGGER CalculateLatency
ON TableA
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LatencyLog (Description, SourceDateTime, TargetDateTime, LatencyInSeconds)
    SELECT 
        i.Description,
        CONVERT(DATETIME, '20' + i.SourceDate + ' ' +  -- Combine SourceDate (YYMMDD) and SourceTime (HHmmss.SS)
                           LEFT(i.SourceTime, 6), 120),-- Convert into DATETIME format
        GETDATE(),                                     -- Current time as TargetDateTime
        DATEDIFF(SECOND,                               -- Calculate the difference between TargetDateTime and SourceDateTime in seconds
                 CONVERT(DATETIME, '20' + i.SourceDate + ' ' + LEFT(i.SourceTime, 6), 120),
                 GETDATE())
    FROM inserted i;
END;
