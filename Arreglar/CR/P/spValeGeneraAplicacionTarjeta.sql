SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeGeneraAplicacionTarjeta
@Empresa	char(5),
@Modulo		char(5),
@ID		int,
@Mov		char(20),
@MovID		char(20),
@Accion 	char(20),
@Fecha		datetime,
@Usuario	char(10),
@Sucursal	int,
@Importe	money,
@CtaDinero	char(10),
@Moneda		char(10),
@TipoCambio	float,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@LDI            bit = 0,
@Referencia		varchar(50) = NULL

AS
BEGIN
DECLARE
@Serie			char(20),
@IDAplicaTarjeta		int,
@MovAplicaTarjeta		char(20),
@MovIDAplicaTarjeta		varchar(20),
@FormaCobroTarjetas		varchar(50),
@MovTipo			varchar(10),
@FactorMov			int ,
@TarjetaLDI                 bit ,
@LDIServicio                varchar(20)
SELECT @FormaCobroTarjetas = CxcFormaCobroTarjetas FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @MovAplicaTarjeta = NULLIF(RTRIM(CxcAplicacionTarjetas), '') FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @TarjetaLDI = ISNULL(LDI,0), @LDIServicio = NULLIF(LDIServicio,'') FROM FormaPago WHERE FormaPago = @FormaCobroTarjetas
IF @Accion NOT IN ('CANCELAR', 'SINCRO') SELECT @Accion = 'AFECTAR'
IF @Importe <> 0 AND Exists(SELECT * FROM TarjetaSerieMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID)
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDAplicaTarjeta = DID FROM MovFlujo WHERE OID = @ID AND OModulo = @Modulo AND DModulo = 'VALE' AND DMov NOT IN (SELECT Mov FROM MovTipo WHERE Modulo = 'VALE' AND Clave IN ('VALE.AMLDI','VALE.ACTMLDI'))
EXEC spAfectar 'VALE', @IDAplicaTarjeta, @Accion, 'Todo', NULL, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1
END
ELSE
BEGIN
IF @Modulo = 'CXC' 
BEGIN
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovTipo in('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.C') 
SELECT @FactorMov = 1
ELSE
SELECT @FactorMov = -1 
END
ELSE
SELECT @FactorMov = ISNULL(Factor,1) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Importe = @Importe * @FactorMov
INSERT INTO Vale(Empresa, Mov, 			FechaEmision, Moneda, TipoCambio, Usuario, Estatus, OrigenTipo, Origen, OrigenID, Sucursal, Importe, Cantidad, CtaDinero, FormaPago, Referencia)
VALUES(@Empresa, @MovAplicaTarjeta, @Fecha, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Modulo, @Mov, @MovID, @Sucursal, @Importe, 1, @CtaDinero, @FormaCobroTarjetas, @Referencia)
SELECT @IDAplicaTarjeta = SCOPE_IDENTITY()
DECLARE crValeAplicaTarjeta CURSOR FOR
SELECT Serie, Importe
FROM TarjetaSerieMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
OPEN crValeAplicaTarjeta
FETCH NEXT FROM crValeAplicaTarjeta INTO @Serie, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Importe = @Importe * @FactorMov
INSERT INTO ValeD(ID, Serie, Sucursal, Importe)
VALUES(@IDAplicaTarjeta, @Serie, @Sucursal, @Importe)
END
FETCH NEXT FROM crValeAplicaTarjeta INTO @Serie, @Importe
END
CLOSE crValeAplicaTarjeta
DEALLOCATE crValeAplicaTarjeta
EXEC spAfectar 'VALE', @IDAplicaTarjeta, @Accion, 'Todo', NULL, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1
IF @OK is null
BEGIN
SELECT @MovIDAplicaTarjeta = MovID FROM Vale WHERE ID = @IDAplicaTarjeta
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'VALE', @IDAplicaTarjeta, @MovAplicaTarjeta, @MovIDAplicaTarjeta, @Ok = @OK OUTPUT
END
END
END
IF @LDI = 1 AND @TarjetaLDI = 1 AND @LDIServicio IS NOT NULL
EXEC spLDIValeGenerarCargoMonedero @Empresa, 'VALE', @IDAplicaTarjeta, @Mov, @MovID, @MovTipo, @Accion, @Usuario, @Sucursal, @Moneda, @TipoCambio, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

