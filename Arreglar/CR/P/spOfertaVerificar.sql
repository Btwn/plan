SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaVerificar
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
@FechaD			datetime,
@FechaA			datetime,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@CfgOfertaNivelOpcion		bit,
@Articulo					varchar(20),
@SubCuenta				varchar(50)
SELECT @CfgOfertaNivelOpcion = ISNULL(OfertaNivelOpcion, 0)
FROM EmpresaCfg2 ec
WHERE ec.Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END ELSE
BEGIN
IF @Ok IS NULL AND dbo.fnEstaVencido(@FechaEmision, @FechaA) = 1 SELECT @Ok = 10095
ELSE
IF @Ok IS NULL
BEGIN
IF @CfgOfertaNivelOpcion = 1
BEGIN
SELECT @Articulo = Min(od.Articulo), @SubCuenta = Min(ISNULL(od.SubCuenta, ''))
FROM OfertaD od
WHERE id = @ID
GROUP BY od.Articulo, ISNULL(od.SubCuenta, '')
HAVING COUNT(od.Articulo) > 1
IF @Articulo IS NOT NULL
SELECT @OK = 10060, @OkRef = 'Producto Duplicado ' + RTRIM(@Articulo) + ' Opción ' + RTRIM(@SubCuenta)
END
ELSE
BEGIN
SELECT @Articulo = Min(od.Articulo)
FROM OfertaD od
WHERE id = @ID
GROUP BY od.Articulo
HAVING COUNT(od.Articulo) > 1
IF @Articulo IS NOT NULL
SELECT @OK = 10060, @OkRef = 'Producto Duplicado ' + RTRIM(@Articulo)
END
END
END
RETURN
END

