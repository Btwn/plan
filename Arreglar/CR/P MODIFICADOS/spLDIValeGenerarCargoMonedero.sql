SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIValeGenerarCargoMonedero
@Empresa		char(5),
@Modulo			char(10),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Accion			char(20),
@Usuario		char(10),
@Sucursal		int,
@MovMoneda		char(10),
@MovTipoCambio		float,
@Ok 			int 		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Servicio           varchar(20),
@ServicioInverso    varchar(20),
@Articulo           varchar(20),
@Serie              varchar(50),
@Importe            float,
@FormaCobroTarjetas varchar(50)
SELECT @FormaCobroTarjetas = CxcFormaCobroTarjetas FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Servicio = LDIServicio FROM FormaPago WITH(NOLOCK) WHERE FormaPago = @FormaCobroTarjetas AND LDI = 1
SELECT @ServicioInverso = ServicioInverso FROM LDIServicio WITH(NOLOCK) WHERE Servicio = @Servicio
IF @Accion = 'CANCELAR'
SELECT @Servicio = @ServicioInverso
DECLARE crValeSerie CURSOR FOR
SELECT d.Serie, ABS(d.Importe)
FROM ValeD d WITH(NOLOCK)
WHERE ID = @ID
OPEN crValeSerie
FETCH NEXT FROM crValeSerie INTO @Serie, @Importe
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NULLIF(@Servicio,'') IS NOT NULL AND NULLIF(@Serie,'') IS NOT NULL  AND @Importe > 0.0
EXEC spLDI @Servicio, @ID, @Serie, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = NULL, @RIDCobro = NULL, @ADO = 0
FETCH NEXT FROM crValeSerie INTO @Serie, @Importe
END
CLOSE crValeSerie
DEALLOCATE crValeSerie
RETURN
END

