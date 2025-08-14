-- 1. TotalGastoCliente
DELIMITER //
CREATE FUNCTION TotalGastoCliente(ClienteID INT, Anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT IFNULL(SUM(Total), 0)
    INTO total
    FROM Invoice
    WHERE CustomerId = ClienteID
      AND YEAR(InvoiceDate) = Anio;
    RETURN total;
END //
DELIMITER ;

-- 2. PromedioPrecioPorAlbum
DELIMITER //
CREATE FUNCTION PromedioPrecioPorAlbum(AlbumID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(UnitPrice)
    INTO promedio
    FROM Track
    WHERE AlbumId = AlbumID;
    RETURN promedio;
END //
DELIMITER ;

-- 3. DuracionTotalPorGenero
DELIMITER //
CREATE FUNCTION DuracionTotalPorGenero(GeneroID INT)
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE total_ms BIGINT;
    SELECT IFNULL(SUM(t.Milliseconds), 0)
    INTO total_ms
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    WHERE t.GenreId = GeneroID;
    RETURN total_ms;
END //
DELIMITER ;

-- 4. DescuentoPorFrecuencia
DELIMITER //
CREATE FUNCTION DescuentoPorFrecuencia(ClienteID INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE compras INT;
    DECLARE descuento DECIMAL(5,2);
    SELECT COUNT(*) INTO compras
    FROM Invoice
    WHERE CustomerId = ClienteID;
    IF compras >= 50 THEN
        SET descuento = 0.20; 
    ELSEIF compras >= 20 THEN
        SET descuento = 0.10; 
    ELSEIF compras >= 10 THEN
        SET descuento = 0.05;
    ELSE
        SET descuento = 0.00;
    END IF;
    RETURN descuento;
END //
DELIMITER ;

-- 5. VerificarClienteVIP
DELIMITER //
CREATE FUNCTION VerificarClienteVIP(ClienteID INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE gasto_anual DECIMAL(10,2);
    SET gasto_anual = TotalGastoCliente(ClienteID, YEAR(CURDATE()));
    RETURN gasto_anual >= 1000;
END //
DELIMITER ;
