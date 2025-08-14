SET GLOBAL event_scheduler = ON;

-- 1. ReporteVentasMensual
CREATE TABLE ReporteMensualVentas (
    ReporteID INT AUTO_INCREMENT PRIMARY KEY,
    MesAnio VARCHAR(7),
    TotalVentas DECIMAL(10,2)
);

CREATE EVENT evt_ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
INSERT INTO ReporteMensualVentas (MesAnio, TotalVentas)
SELECT DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m') AS MesAnio,
       SUM(Total) FROM Invoice
WHERE MONTH(InvoiceDate) = MONTH(NOW() - INTERVAL 1 MONTH)
  AND YEAR(InvoiceDate) = YEAR(NOW() - INTERVAL 1 MONTH);

-- 2. ActualizarSaldosCliente
CREATE EVENT evt_ActualizarSaldosCliente
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
UPDATE Customer c
SET c.Saldo = c.Saldo - IFNULL((
    SELECT SUM(Total) FROM Invoice i
    WHERE i.CustomerId = c.CustomerId
      AND MONTH(i.InvoiceDate) = MONTH(NOW() - INTERVAL 1 MONTH)
      AND YEAR(i.InvoiceDate) = YEAR(NOW() - INTERVAL 1 MONTH)
), 0);

-- 3. AlertaAlbumNoVendidoAnual
CREATE TABLE AlertasAlbum (
    AlertaID INT AUTO_INCREMENT PRIMARY KEY,
    AlbumID INT,
    Fecha DATETIME,
    Mensaje TEXT
);

CREATE EVENT evt_AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
STARTS '2026-01-01 00:00:00'
DO
INSERT INTO AlertasAlbum (AlbumID, Fecha, Mensaje)
SELECT a.AlbumId, NOW(),
       CONCAT('El álbum "', a.Title, '" no tuvo ventas en el último año')
FROM Album a
WHERE a.AlbumId NOT IN (
    SELECT DISTINCT t.AlbumId
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.InvoiceDate >= NOW() - INTERVAL 1 YEAR
);

-- 4. LimpiarAuditoriaCada6Meses
CREATE EVENT evt_LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
STARTS '2026-01-01 00:00:00'
DO
DELETE FROM AuditoriaCliente
WHERE FechaCambio < NOW() - INTERVAL 1 YEAR;

-- 5. ActualizarListaDeGenerosPopulares
CREATE TABLE GenerosPopulares (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    MesAnio VARCHAR(7),
    GeneroID INT,
    Ventas INT
);

CREATE EVENT evt_ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
INSERT INTO GenerosPopulares (MesAnio, GeneroID, Ventas)
SELECT DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m') AS MesAnio,
       t.GenreId,
       COUNT(*) AS Ventas
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE MONTH(i.InvoiceDate) = MONTH(NOW() - INTERVAL 1 MONTH)
  AND YEAR(i.InvoiceDate) = YEAR(NOW() - INTERVAL 1 MONTH)
GROUP BY t.GenreId
ORDER BY Ventas DESC;
