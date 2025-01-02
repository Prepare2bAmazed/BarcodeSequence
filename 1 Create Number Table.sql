BEGIN TRAN

IF OBJECT_ID('dbo.Number') IS NOT NULL
BEGIN
    DROP TABLE dbo.Number
END

CREATE TABLE dbo.Number
(
    ID INT NOT NULL
)
ALTER TABLE dbo.Number ADD CONSTRAINT PK_Number_ID PRIMARY KEY CLUSTERED (ID ASC)

DECLARE @digits TABLE (digit INT)
INSERT @digits
    (digit)
VALUES
    (0),
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9)

INSERT dbo.Number
    (ID)
SELECT
    ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNum
FROM @digits d1
    CROSS JOIN @digits D2
    CROSS JOIN @digits D3
    CROSS JOIN @digits D4
    CROSS JOIN @digits D5
    CROSS JOIN @digits D6

IF @@ERROR = 1
    ROLLBACK
ELSE
    COMMIT