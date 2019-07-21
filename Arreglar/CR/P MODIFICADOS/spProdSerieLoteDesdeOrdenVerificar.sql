SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdSerieLoteDesdeOrdenVerificar
@Sucursal			int,
@Modulo				char(5),
@OID				int,
@Accion				varchar(20),
@EstatusNuevo			varchar(15),
@Ok				int OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
DECLARE
@ProdValidarSLEntradaProduccion		bit,
@ProdSerieLoteDesdeOrden		bit,
@Empresa				varchar(5),
@OMovTipo				varchar(20),
@ProdAutoLote				varchar(20),
@Verificar				int
SELECT
@Empresa = p.Empresa,
@OMovTipo = mt.Clave
FROM Prod p WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK)
ON mt.Mov = p.Mov AND mt.Modulo = 'PROD'
WHERE ID = @OID
SELECT
@ProdSerieLoteDesdeOrden = ProdSerieLoteDesdeOrden ,
@ProdValidarSLEntradaProduccion = ProdValidarSLEntradaProduccion,
@ProdAutoLote = ProdAutoLote
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @ProdSerieLoteDesdeOrden = 1 AND @ProdValidarSLEntradaProduccion = 1 AND  @ProdAutoLote ='Nivel Renglon' AND @Accion = 'AFECTAR' AND @Ok IS NULL
BEGIN
SELECT @Verificar = COUNT(SerieLote) FROM SerieLoteMov WITH(NOLOCK)
WHERE  ID = @OID
AND  Empresa = @Empresa
AND  Modulo = 'PROD'
END
IF @Verificar = 0 AND @OMovTipo IN ('PROD.O') AND @EstatusNuevo IN ('BORRADOR','PENDIENTE') SELECT @ok = 20051
END

