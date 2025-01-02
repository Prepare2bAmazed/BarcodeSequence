BEGIN TRAN

DECLARE 
    @quantity INT = 10000,
    @scanDate DATE = '1/2/2025'

IF OBJECT_ID('FK_Document_ClaimID') IS NOT NULL
BEGIN
    ALTER TABLE dbo.Document DROP FK_Document_ClaimID
END

IF OBJECT_ID('dbo.Claim') IS NOT NULL
BEGIN
    DROP TABLE dbo.Claim
END


CREATE TABLE dbo.Claim
(
    ID INT NOT NULL
)
ALTER TABLE dbo.Claim ADD CONSTRAINT PK_Claim_ID PRIMARY KEY CLUSTERED (ID ASC) 


INSERT dbo.Claim
    (
    ID
    )
SELECT
    ID
FROM dbo.Number
WHERE ID <= @quantity


IF OBJECT_ID('dbo.Document') IS NOT NULL
BEGIN
    DROP TABLE dbo.Document
END

CREATE TABLE dbo.Document
(
    ID INT NOT NULL,
    ClaimID INT NULL,
    BarcodeID VARCHAR(14) NOT NULL
)
ALTER TABLE dbo.Document ADD CONSTRAINT PK_Document_ID PRIMARY KEY CLUSTERED (ID ASC)
ALTER TABLE dbo.Document ADD CONSTRAINT FK_Document_ClaimID FOREIGN KEY (ClaimID) REFERENCES dbo.Claim(ID)

INSERT dbo.Document
    (
    ID,
    ClaimID,
    BarcodeID
    )
SELECT
    n.ID,
    NULL,
    CONCAT(
      LEFT(CONVERT(VARCHAR, @scanDate, 112), 6),
      'X',
      RIGHT(CONCAT(REPLICATE('0', 5), CONVERT(VARCHAR, n.ID)), 6)
    )
FROM dbo.Number n
WHERE ID <= @quantity
ORDER BY NEWID()


UPDATE dbo.Document
SET ClaimID = c.ClaimID
FROM dbo.Document d
JOIN 
(
SELECT 
    ROW_NUMBER() OVER(ORDER BY (NEWID())) AS DocumentID,
    ID AS ClaimID
FROM dbo.Claim
) c
ON d.ID = c.DocumentID


DECLARE @quantityToDelete INT = @quantity * 0.03

DELETE dbo.Document
WHERE ID IN
(
SELECT TOP(@quantityToDelete)
    d.ID
FROM dbo.Document d
ORDER BY NEWID()
)

IF @@ERROR = 1
    ROLLBACK
ELSE
    COMMIT