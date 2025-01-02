/*
    For the given sequence, find the missing barcode IDs
*/
DECLARE
    @seqDate DATE = '1/05/2025',
    @letter CHAR = 'X',
    @start int = 10,
    @end int = 2500

IF OBJECT_ID('tempdb..#AllBarcodes') IS NOT NULL
BEGIN
    DROP TABLE #AllBarcodes
END
CREATE TABLE #AllBarcodes
(
    BarcodeID VARCHAR(14) NOT NULL
)

INSERT #AllBarcodes
SELECT
    CONCAT(
      LEFT(CONVERT(VARCHAR, @seqDate, 112), 6),
      @letter,
      RIGHT(CONCAT(REPLICATE('0', 5), CONVERT(VARCHAR, n.ID)), 6)
    )
FROM dbo.Number n
WHERE n.ID BETWEEN @start AND @end

SELECT
    b.BarcodeID
FROM #AllBarcodes b
    LEFT JOIN dbo.Document d
    ON b.BarcodeID = d.BarcodeID
WHERE d.BarcodeID IS NULL
ORDER BY b.BarcodeID
