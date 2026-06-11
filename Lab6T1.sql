CREATE DATABASE User_Actions

USE User_Actions
CREATE TABLE User_Logs(
	id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	username TEXT NOT NULL,
	user_action TEXT NOT NULL,
	action_date DATE NOT NULL,
	action_time TIME NOT NULL,
	action_result TEXT NOT NULL,
	)

--Генерация записей
SET NOCOUNT ON;

WITH Tally AS (
    SELECT TOP 1000000
        rn = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v1(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v2(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v3(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v4(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v5(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v6(n)
),
Randomized AS (
    SELECT
        rn,
        rand_val = ABS(CHECKSUM(NEWID()))
    FROM Tally
)
INSERT INTO User_Logs WITH (TABLOCK) (username, user_action, action_date, action_time, action_result)
SELECT
    -- username: user_00001 ... user_99999
    'user_' + RIGHT('00000' + CAST(rand_val % 99999 AS VARCHAR(5)), 5),
    
    -- user_action: используем остаток от деления того же rand_val
    CASE rand_val % 8
        WHEN 0 THEN 'LOGIN'      WHEN 1 THEN 'LOGOUT'
        WHEN 2 THEN 'UPDATE'     WHEN 3 THEN 'DELETE'
        WHEN 4 THEN 'VIEW'       WHEN 5 THEN 'CREATE'
        WHEN 6 THEN 'EXPORT'     WHEN 7 THEN 'IMPORT'
        ELSE 'UNKNOWN'
    END,
    
    -- action_date: случайная дата за год
    DATEADD(DAY, rand_val % 365, '2025-01-01'),
    
    -- action_time: случайное время суток (0-86399 секунд)
    DATEADD(SECOND, rand_val % 86400, CAST('00:00:00' AS TIME)),
    
    -- action_result: случайный статус
    CASE rand_val % 5
        WHEN 0 THEN 'SUCCESS'        WHEN 1 THEN 'FAILED'
        WHEN 2 THEN 'PENDING'        WHEN 3 THEN 'TIMEOUT'
        WHEN 4 THEN 'ACCESS_DENIED'
        ELSE 'ERROR'                 -- Страховка от NULL
    END
FROM Randomized;

SELECT * FROM User_Logs