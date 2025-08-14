-- 1. ActualizarTotalVentasEmpleado
ALTER TABLE Employee ADD COLUMN TotalVentas DECIMAL(10,2) DEFAULT 0;

DELIMITER //
CREATE TRIGGER trg_ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN
    UPDATE Employee e
    JOIN Customer c ON e.EmployeeId = c.SupportRepId
    SET e.TotalVentas = e.TotalVentas + NEW.Total
    WHERE c.CustomerId = NEW.CustomerId;
END //
DELIMITER ;

-- 2. AuditarActualizacionCliente
CREATE TABLE AuditoriaCliente (
    AuditoriaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    FechaCambio DATETIME,
    Campo VARCHAR(50),
    ValorAnterior TEXT,
    ValorNuevo TEXT
);

DELIMITER //
CREATE TRIGGER trg_AuditarActualizacionCliente
BEFORE UPDATE ON Customer
FOR EACH ROW
BEGIN
    IF OLD.FirstName <> NEW.FirstName THEN
        INSERT INTO AuditoriaCliente (ClienteID, FechaCambio, Campo, ValorAnterior, ValorNuevo)
        VALUES (OLD.CustomerId, NOW(), 'FirstName', OLD.FirstName, NEW.FirstName);
    END IF;
    IF OLD.LastName <> NEW.LastName THEN
        INSERT INTO AuditoriaCliente (ClienteID, FechaCambio, Campo, ValorAnterior, ValorNuevo)
        VALUES (OLD.CustomerId, NOW(), 'LastName', OLD.LastName, NEW.LastName);
    END IF;
END //
DELIMITER ;

-- 3. RegistrarHistorialPrecioCancion
CREATE TABLE HistorialPrecioCancion (
    HistorialID INT AUTO_INCREMENT PRIMARY KEY,
    TrackID INT,
    FechaCambio DATETIME,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2)
);

DELIMITER //
CREATE TRIGGER trg_RegistrarHistorialPrecioCancion
BEFORE UPDATE ON Track
FOR EACH ROW
BEGIN
    IF OLD.UnitPrice <> NEW.UnitPrice THEN
        INSERT INTO HistorialPrecioCancion (TrackID, FechaCambio, PrecioAnterior, PrecioNuevo)
        VALUES (OLD.TrackId, NOW(), OLD.UnitPrice, NEW.UnitPrice);
    END IF;
END //
DELIMITER ;

-- 4. NotificarCancelacionVenta
CREATE TABLE NotificacionesCancelacion (
    NotificacionID INT AUTO_INCREMENT PRIMARY KEY,
    InvoiceID INT,
    Fecha DATETIME,
    Mensaje TEXT
);

DELIMITER //
CREATE TRIGGER trg_NotificarCancelacionVenta
AFTER DELETE ON Invoice
FOR EACH ROW
BEGIN
    INSERT INTO NotificacionesCancelacion (InvoiceID, Fecha, Mensaje)
    VALUES (OLD.InvoiceId, NOW(), CONCAT('Se canceló la venta con ID ', OLD.InvoiceId));
END //
DELIMITER ;

-- 5. RestringirCompraConSaldoDeudor
ALTER TABLE Customer ADD COLUMN Saldo DECIMAL(10,2) DEFAULT 0;

DELIMITER //
CREATE TRIGGER trg_RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE saldo_actual DECIMAL(10,2);
    SELECT Saldo INTO saldo_actual
    FROM Customer
    WHERE CustomerId = NEW.CustomerId;
    IF saldo_actual > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente con saldo deudor no puede realizar compras.';
    END IF;
END //
DELIMITER ;
