/*
The approach is designed to calculate the average session time per page. 
A session is defined as a pair of "entry" and "exit" events, where each entry 
corresponds to a user's entry onto a page, and the exit marks their departure.

Steps:
1) Separate "entry" and "exit" events using CTE.
2) Pair the "entry" and "exit" events using ROW_NUMBER(). This ensures each "entry" is paired with the corresponding "exit" based on the order of events.
3) Calculate the time difference between each "entry" and "exit" event to determine the session duration.
4) Compute the average session time for each page by taking the average of the session durations for all users on that page.

Assumption: Every session is guaranteed to have a corresponding "entry" and "exit" event.
*/

WITH UserEntry AS (
    SELECT
    PageName,
    CustomerId,
    Timestamp AS EntryTime,
    ROW_NUMBER() OVER (PARTITION BY PageName, CustomerId ORDER BY Timestamp) AS EntryRank
    FROM PageEvents
    WHERE Type = 'entry'
),
UserExit AS (
    SELECT
    PageName,
    CustomerId,
    Timestamp AS ExitTime,
    ROW_NUMBER() OVER (PARTITION BY PageName, CustomerId ORDER BY Timestamp) AS ExitRank
    FROM PageEvents
    WHERE Type = 'exit'
)

SELECT
ue.PageName,
AVG(CAST(DATEDIFF(MINUTE,ue.EntryTime,ux.ExitTime) AS FLOAT)) AS AvgSessionTime
FROM
UserEntry ue
JOIN UserExit ux
ON ue.PageName = ux.PageName and ue.CustomerId = ux.CustomerId and ue.EntryRank = ux.ExitRank
GROUP BY ue.PageName;
