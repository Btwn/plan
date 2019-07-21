SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spWMSTarimaCambioEstatus
@Empresa CHAR(5),
@Sucursal INT,
@Usuario CHAR(10),
@Almacen VARCHAR(10),
@Tarima VARCHAR(20),
@Tipo VARCHAR(20),
@EstatusNuevo VARCHAR(15)

AS
BEGIN
DECLARE
@Estatus VARCHAR(15),
@EstatusActual VARCHAR(15),
@EstatusControlCalidad VARCHAR(15),
@FechaRegistro DATETIME
SELECT @FechaRegistro=GETDATE()
SELECT @Estatus=Estatus
FROM WMSEstatusControlCalidad
WHERE EstatusControlCalidad=@EstatusNuevo
SELECT @EstatusActual=Estatus, @EstatusControlCalidad=EstatusControlCalidad
FROM Tarima
WHERE Tarima=@Tarima AND Almacen=@Almacen
IF @Estatus NOT IN ('ALTA', 'BAJA')
RETURN
IF @EstatusNuevo NOT IN (SELECT EstatusControlCalidad FROM WMSEstatusControlCalidad WHERE NULLIF(LTRIM(RTRIM(EstatusControlCalidad)),'') IS NOT NULL)
RETURN
IF @Tipo<>'Ubicacion'
RETURN
ELSE
IF @EstatusControlCalidad=@EstatusNuevo
RETURN
ELSE
BEGIN
UPDATE Tarima SET Estatus=@Estatus, EstatusControlCalidad=@EstatusNuevo
WHERE Almacen=@Almacen
AND Tarima=@Tarima
INSERT INTO WMSTarmiaCambioHist(Empresa, Sucursal, Ejercicio, Periodo, FechaRegistro, Usuario, Tarima, Almacen, Estatus, EstatusNuevo, EstatusControlCalidad)
SELECT @Empresa, @Sucursal, YEAR(@FechaRegistro), MONTH(@FechaRegistro), @FechaRegistro, @Usuario, @Tarima, @Almacen, @EstatusActual, @EstatusNuevo, @Estatus
END
END

