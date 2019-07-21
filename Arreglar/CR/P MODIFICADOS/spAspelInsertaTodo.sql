SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  spAspelInsertaTodo
(
@Estacion		int
)

AS BEGIN
DECLARE
@Ok		int,
@OkRef		varchar(255)
SET @Ok = NULL
UPDATE Aspel_paso WITH(ROWLOCK) SET
Ventas = 0, DescripcionVentas = '', RegistrosVentas = 0, TotalVentas = 0,
Compras = 0, DescripcionCompras = '', RegistrosCompras = 0, TotalCompras = 0,
CuentasPorCobrar = 0, DescripcionCxC = '', RegistrosCxC = 0, TotalCxC = 0,
CuentasPorPagar = 0, DescripcionCxP = '', RegistrosCxP = 0, TotalCxP = 0,
Inventarios = 0, DescripcionInventarios = '', RegistrosInventarios = 0,
Polizas = 0, DescripcionPolizas = '', RegistrosPolizas = '',
PolizaAjuste = 0, DescripcionPolAjuste = ''
Exec spAspelActualizaProcesos 0
EXEC spAspelInsertaCatalogos
EXEC spAspelInsertaMovimientos @Estacion 
/*
IF @Ok IS NOT NULL AND @Ok < 80000
ROLLBACK TRANSACTION ASPEL
ELSE
COMMIT TRANSACTION ASPEL
IF @Ok IS NOT NULL AND @Ok < 80000
SELECT 'Migraci�n con Errores, Revise los Archivos LOG'
ELSE
*/
Exec spAspelActualizaProcesos 1
/*
Exec spAspelkits
Exec spAspelultimocosto
Exec spAspelcontactos
*/
END

