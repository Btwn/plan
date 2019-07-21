SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCVerificarPinPad
@Empresa	varchar(5),
@Modulo		varchar(5),
@ID			int,
@Sucursal	int,
@Estacion	int,
@Accion		varchar(20),
@Usuario	varchar(10),
@CancelaRID	int				= NULL,
@Ok			int				= NULL OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT

AS
BEGIN
DECLARE @MonedaCodigoNumerico varchar(10),
@Moneda				varchar(10),
@CxcID				int,
@DinEstatus			varchar(15),
@DinMov				varchar(20),
@DinMovID				varchar(20),
@Clave                varchar(20) 
IF @Modulo='VTAS'
BEGIN
EXEC spAfectar 'VTAS', @ID, 'VERIFICAR', @EnSilencio=1, @Ok=@Ok Output, @OkRef=@OkRef Output
IF @Ok = 8 SELECT @Ok = NULL, @OkRef = NULL 
IF @Ok IS NULL
BEGIN
SELECT @MonedaCodigoNumerico=CAST(MonCodigoInternacional.CodigoNumerico as varchar(10)),
@Moneda=Venta.Moneda
FROM Venta
JOIN Mon ON Venta.Moneda = Mon.Moneda
LEFT OUTER JOIN MonCodigoInternacional ON Mon.Moneda = MonCodigoInternacional.Moneda
WHERE Venta.Empresa=@Empresa
AND Venta.ID = @ID
AND Venta.Sucursal=@Sucursal
IF @MonedaCodigoNumerico IS NULL OR @MonedaCodigoNumerico='' OR @MonedaCodigoNumerico='0'
BEGIN
SELECT @Ok = 35065, @OkRef = @Moneda
END
IF @Ok IS NULL
BEGIN
SELECT @CxcID = CxcID FROM TCTransaccion WHERE RID = @CancelaRID
SELECT @DinEstatus = d.Estatus,
@DinMov		= d.Mov,
@DinMovID   = d.MovID,
@Clave      = m.Clave 
FROM Cxc o
JOIN Dinero d ON d.OrigenTipo = 'CXC' AND d.Origen = o.Mov AND d.OrigenID = o.MovID AND d.Empresa = o.Empresa
JOIN MovTipo m ON m.Modulo='DIN' AND m.Mov=d.Mov  
WHERE o.ID = @CxcID
IF @DinEstatus = 'CONCLUIDO' and @Clave in ('DIN.SD','DIN.SCH') 
SELECT @Ok = 60060, @OkRef = RTRIM(@DinMov) + ' '+@DinMovID
END
END
END
END

