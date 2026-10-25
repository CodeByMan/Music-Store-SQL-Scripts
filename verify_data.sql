USE MusicStoreSQL;

DECLARE @counts TABLE (table_name NVARCHAR(30), expected_rows INT, actual_rows INT);

INSERT INTO @counts (table_name, expected_rows, actual_rows)
VALUES
    (N'artist', 275, (SELECT COUNT(*) FROM dbo.artist)),
    (N'album', 347, (SELECT COUNT(*) FROM dbo.album)),
    (N'customer', 59, (SELECT COUNT(*) FROM dbo.customer)),
    (N'employee', 9, (SELECT COUNT(*) FROM dbo.employee)),
    (N'genre', 25, (SELECT COUNT(*) FROM dbo.genre)),
    (N'invoice', 614, (SELECT COUNT(*) FROM dbo.invoice)),
    (N'invoice_line', 4757, (SELECT COUNT(*) FROM dbo.invoice_line)),
    (N'media_type', 5, (SELECT COUNT(*) FROM dbo.media_type)),
    (N'playlist', 18, (SELECT COUNT(*) FROM dbo.playlist)),
    (N'playlist_track', 8715, (SELECT COUNT(*) FROM dbo.playlist_track)),
    (N'track', 3503, (SELECT COUNT(*) FROM dbo.track));

SELECT table_name, expected_rows, actual_rows,
    CASE WHEN actual_rows = expected_rows THEN N'PASS' ELSE N'FAIL' END AS status
FROM @counts
ORDER BY table_name;

IF EXISTS (SELECT 1 FROM @counts WHERE actual_rows <> expected_rows)
    THROW 50002, N'One or more CSV row counts do not match.', 1;

SELECT COUNT(*) AS invalid_invoice_lines
FROM dbo.invoice_line
WHERE unit_price IS NULL OR unit_price < 0 OR quantity IS NULL OR quantity <= 0;

IF EXISTS (
    SELECT 1 FROM dbo.invoice_line
    WHERE unit_price IS NULL OR unit_price < 0 OR quantity IS NULL OR quantity <= 0
)
    THROW 50003, N'An invoice line has an invalid price or quantity.', 1;

SELECT name, is_not_trusted
FROM sys.foreign_keys
WHERE parent_object_id IN (
    OBJECT_ID(N'dbo.album'), OBJECT_ID(N'dbo.employee'),
    OBJECT_ID(N'dbo.customer'), OBJECT_ID(N'dbo.track'),
    OBJECT_ID(N'dbo.invoice'), OBJECT_ID(N'dbo.invoice_line'),
    OBJECT_ID(N'dbo.playlist_track')
)
ORDER BY name;

IF (SELECT COUNT(*) FROM sys.foreign_keys
    WHERE parent_object_id IN (
        OBJECT_ID(N'dbo.album'), OBJECT_ID(N'dbo.employee'),
        OBJECT_ID(N'dbo.customer'), OBJECT_ID(N'dbo.track'),
        OBJECT_ID(N'dbo.invoice'), OBJECT_ID(N'dbo.invoice_line'),
        OBJECT_ID(N'dbo.playlist_track')
    ) AND is_not_trusted = 0) <> 11
    THROW 50004, N'The 11 foreign keys have not all been validated.', 1;

SELECT (SELECT SUM(total) FROM dbo.invoice) AS invoice_total,
       (SELECT SUM(unit_price * quantity) FROM dbo.invoice_line) AS line_total;

IF (SELECT SUM(total) FROM dbo.invoice) <>
   (SELECT SUM(unit_price * quantity) FROM dbo.invoice_line)
    THROW 50005, N'Invoice and invoice-line totals do not match.', 1;
