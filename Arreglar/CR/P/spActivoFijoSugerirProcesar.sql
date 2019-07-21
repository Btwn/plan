SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActivoFijoSugerirProcesar
@ID						int,
@EstacionTrabajo		int

AS BEGIN
DECLARE @Clave			varchar(255),
@ClaveAnt			varchar(255),
@MovTipo			varchar(20),
@SubClave			varchar(20),
@SubClaveFiscal	int,
@Mov				varchar(20),
@Moneda			varchar(10),
@Sucursal			int,
@Empresa			varchar(5),
@Fecha			datetime,
@Ok				int
SELECT @Mov		= Mov,
@Moneda	= Moneda,
@Sucursal	= Sucursal,
@Empresa	= Empresa,
@Fecha		= FechaEmision
FROM ActivoFijo
WHERE ID = @ID
SELECT @MovTipo	= MovTipo.Clave,
@SubClave	= MovTipo.SubClave
FROM MovTipo
WHERE Modulo = 'AF'
AND Mov = @Mov
SELECT @SubClaveFiscal = dbo.fnSubClaveFiscal(@SubClave)
DELETE ActivoFijoD WHERE ID = @ID
SELECT @ClaveAnt = ''
WHILE(1=1)
BEGIN
SELECT @Clave = MIN(Clave)
FROM ListaSt
WHERE Estacion = @EstacionTrabajo
AND Clave > @ClaveAnt
IF @Clave IS NULL BREAK
SELECT @ClaveAnt = @Clave, @Ok = NULL
EXEC spActivoFijoCopiarCategoria @Sucursal, @Empresa, @ID, @MovTipo, @Moneda, @Fecha, @Clave, @Ok OUTPUT, @SubClave,
@SubClaveFiscal
END
RETURN
END

