SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPVerificarReduccion
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@FechaRegistro     		datetime,
@Proyecto	      		varchar(50),
@Ejercicio			int,
@Periodo			int,
@ClavePresupuestal		varchar(50),
@Tipo			varchar(20),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Articulo		varchar(20),
@Importe		money,
@ImporteDisponible	money
IF @Ok IS NULL
BEGIN
DECLARE spCPVerificarTraspaso CURSOR LOCAL FOR
SELECT cpa.Articulo, cpa.Cantidad*cpa.Precio
FROM CPArt cpa
WHERE cpa.ID = @ID AND cpa.ClavePresupuestal = @ClavePresupuestal AND cpa.Tipo = @Tipo
OPEN spCPVerificarTraspaso
FETCH NEXT FROM spCPVerificarTraspaso INTO @Articulo, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND ISNULL(@Importe, 0.0) > 0.0
BEGIN
SELECT @ImporteDisponible = 0.0
SELECT @ImporteDisponible = ImporteDisponible
FROM CPArtNetoDisponible
WHERE Empresa = @Empresa AND Proyecto = @Proyecto AND ClavePresupuestal = @ClavePresupuestal AND Articulo = @Articulo
IF @Importe > @ImporteDisponible
SELECT @Ok = 25570, @OkRef = RTRIM(@Mov)+'<BR>'+@ClavePresupuestal+' ('+@Articulo+')<BR>Excedente: '+CONVERT(varchar, @Importe-@ImporteDisponible)
END
FETCH NEXT FROM spCPVerificarTraspaso INTO @Articulo, @Importe
END
CLOSE spCPVerificarTraspaso
DEALLOCATE spCPVerificarTraspaso
END
RETURN
END

