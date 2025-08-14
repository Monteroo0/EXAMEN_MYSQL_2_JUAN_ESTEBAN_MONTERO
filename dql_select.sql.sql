
USE Chinook;

-- 1)
SELECT e.EmployeeId, e.FirstName, e.LastName,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS TotalVendido
FROM Invoice i
JOIN Customer c       ON c.CustomerId = i.CustomerId
LEFT JOIN Employee e  ON e.EmployeeId = c.SupportRepId
JOIN InvoiceLine il   ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY TotalVendido DESC
LIMIT 1;

-- 2) 
SELECT ar.ArtistId, ar.Name AS Artista,
       SUM(il.Quantity) AS CancionesVendidas
FROM Invoice i
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN Track t        ON t.TrackId = il.TrackId
JOIN Album al       ON al.AlbumId = t.AlbumId
JOIN Artist ar      ON ar.ArtistId = al.ArtistId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY ar.ArtistId, ar.Name
ORDER BY CancionesVendidas DESC
LIMIT 5;

-- 3) 
SELECT i.BillingCountry AS Pais,
       ROUND(SUM(i.Total),2) AS TotalVentasFactura,
       SUM(il.Quantity) AS CancionesVendidas
FROM Invoice i
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
GROUP BY i.BillingCountry
ORDER BY TotalVentasFactura DESC;

-- 4) 

-- 5) 
SELECT c.CustomerId, c.FirstName AS Cliente,
       a.AlbumId, a.Title AS Album
FROM Customer c
JOIN Invoice i     ON i.CustomerId = c.CustomerId
JOIN InvoiceLine l ON l.InvoiceId = i.InvoiceId
JOIN Track t       ON t.TrackId = l.TrackId
JOIN Album a       ON a.AlbumId = t.AlbumId
GROUP BY c.CustomerId, a.AlbumId, a.Title
HAVING COUNT(DISTINCT t.TrackId) = (
  SELECT COUNT(*) FROM Track t2 WHERE t2.AlbumId = a.AlbumId
);

-- 6) 
SELECT i.BillingCountry AS Pais,
       ROUND(SUM(i.Total),2) AS TotalVentas
FROM Invoice i
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY i.BillingCountry
ORDER BY TotalVentas DESC
LIMIT 3;

-- 7) 
SELECT g.GenreId, g.Name AS Genero,
       SUM(il.Quantity) AS CancionesVendidas
FROM Invoice i
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN Track t        ON t.TrackId = il.TrackId
JOIN Genre g        ON g.GenreId = t.GenreId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY g.GenreId, g.Name
ORDER BY CancionesVendidas ASC
LIMIT 5;

-- 8)

-- 9)
SELECT e.EmployeeId, e.FirstName, e.LastName,
       ROUND(SUM(il.UnitPrice * il.Quantity),2) AS TotalRock
FROM Invoice i
JOIN Customer c       ON c.CustomerId = i.CustomerId
LEFT JOIN Employee e  ON e.EmployeeId = c.SupportRepId
JOIN InvoiceLine il   ON il.InvoiceId = i.InvoiceId
JOIN Track t          ON t.TrackId = il.TrackId
JOIN Genre g          ON g.GenreId = t.GenreId
WHERE g.Name = 'Rock'
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY TotalRock DESC
LIMIT 5;

-- 10)
SELECT c.CustomerId, c.FirstName AS Cliente,
       COUNT( i.InvoiceId) AS CantFacturas,
       ROUND(SUM(i.Total),2) AS TotalGastado
FROM Customer c
LEFT JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId, Cliente
ORDER BY CantFacturas DESC, TotalGastado DESC;

-- 11) 
SELECT g.GenreId, g.Name AS Genero,
       ROUND(SUM(il.UnitPrice * il.Quantity) / NULLIF(SUM(il.Quantity),0), 4) AS PrecioPromedio
FROM InvoiceLine il
JOIN Track t ON t.TrackId = il.TrackId
JOIN Genre g ON g.GenreId = t.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY PrecioPromedio DESC;

-- 12) 
SELECT t.TrackId, t.Name AS Cancion, t.Milliseconds,
       a.Title AS Album, ar.Name AS Artista
FROM Track t
JOIN Album a  ON a.AlbumId  = t.AlbumId
JOIN Artist ar ON ar.ArtistId = a.ArtistId
JOIN InvoiceLine il ON il.TrackId = t.TrackId
JOIN Invoice i      ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY t.TrackId, Cancion, t.Milliseconds, a.Title, ar.Name
ORDER BY t.Milliseconds DESC
LIMIT 5;

-- 13) 
SELECT c.CustomerId, CONCAT(c.FirstName,' ',c.LastName) AS Cliente,
       SUM(il.Quantity) AS CancionesJazz
FROM Invoice i
JOIN Customer c ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN Track t ON t.TrackId = il.TrackId
JOIN Genre g ON g.GenreId = t.GenreId
WHERE g.Name = 'Jazz'
GROUP BY c.CustomerId, Cliente
ORDER BY CancionesJazz DESC
LIMIT 10;

-- 14) 


-- 15)
SELECT DATE(i.InvoiceDate) AS Dia,
       DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS Mes,
       SUM(il.Quantity) AS CancionesVendidas
FROM Invoice i
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY Dia, Mes
ORDER BY Dia;

-- 16) 
SELECT e.EmployeeId, e.FirstName, e.LastName,
       ROUND(SUM(il.UnitPrice * il.Quantity),2) AS TotalVendido
FROM Invoice i
JOIN Customer c       ON c.CustomerId = i.CustomerId
LEFT JOIN Employee e  ON e.EmployeeId = c.SupportRepId
JOIN InvoiceLine il   ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY TotalVendido DESC;

-- 17)
SELECT i.InvoiceId, i.InvoiceDate, i.Total,
       c.CustomerId, c.FirstName AS Cliente
FROM Invoice i
JOIN Customer c ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY i.Total DESC
LIMIT 1;

-- 18)
SELECT a.AlbumId, a.Title AS Album, ar.Name AS Artista,
       SUM(il.Quantity) AS CancionesVendidas
FROM Invoice i
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN Track t        ON t.TrackId = il.TrackId
JOIN Album a        ON a.AlbumId = t.AlbumId
JOIN Artist ar      ON ar.ArtistId = a.ArtistId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.AlbumId, Album, ar.Name
ORDER BY CancionesVendidas DESC
LIMIT 5;

-- 19)
SELECT g.GenreId, g.Name AS Genero,
       SUM(il.Quantity) AS CancionesVendidas
FROM Invoice i
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN Track t        ON t.TrackId = il.TrackId
JOIN Genre g        ON g.GenreId = t.GenreId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY g.GenreId, g.Name
ORDER BY CancionesVendidas DESC;

-- 20) 
SELECT c.CustomerId, c.FirstName AS Cliente, c.Email
FROM Customer c
LEFT JOIN Invoice i
  ON i.CustomerId = c.CustomerId
 AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE i.InvoiceId IS NULL
ORDER BY Cliente;
