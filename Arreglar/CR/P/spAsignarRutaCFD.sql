SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsignarRutaCFD
@Modulo		varchar(10),
@ID		int,
@Ruta  varchar(256)

AS BEGIN
DECLARE
@Mov        varchar(20),
@MovID      varchar(20),
@Fecha      datetime,
@Nombre     varchar(40),
@Estatus    varchar(15),
@Sucursal   int,
@Usuario    varchar(10)
IF @Modulo = 'VTAS'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Venta WHERE ID = @ID
IF @Modulo = 'COMS'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Compra WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Cxc WHERE ID = @ID
IF @Modulo = 'CXP'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Cxp WHERE ID = @ID
IF ISNULL(@Ruta,'') <> ''
BEGIN
UPDATE CFD SET RutaAcuse = @Ruta WHERE Modulo = @Modulo AND ModuloID=@ID
SET @Nombre = 'Acuse '+@MovID
DELETE AnexoMov WHERE Rama = @Modulo AND ID = @ID AND Nombre = @Nombre AND CFD = 1
INSERT INTO AnexoMov(Rama,    ID,  Nombre,  Direccion, Icono, Tipo,      Orden, Sucursal,  FechaEmision, Alta,   UltimoCambio, Usuario,  CFD)
VALUES(@Modulo, @ID, @Nombre, @Ruta,     17,    'Archivo', NULL,  @Sucursal, @Fecha,       @Fecha, @Fecha,       @Usuario, 1 )
END
RETURN
END

