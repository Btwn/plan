SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCCfg
@Empresa		varchar(5),
@Sucursal		int,
@Estacion		int,
@Usuario		varchar(10),
@XMLCfg			varchar(max) OUTPUT

AS
BEGIN
DECLARE @PinPad	varchar(3)
SELECT @PinPad = dbo.fnTCPinPad(@Empresa, @Sucursal, @Usuario, 'Pinpad')
SELECT @XMLCfg = (SELECT TCCfg.Empresa,
Empresa.Nombre 'NombreEmpresa',
dbo.fnTCProcesadorTransCfg(@Empresa, @Sucursal) 'ProcesadorTrans',
dbo.fnTCInstitucionAdquirienteCfg(@Empresa, @Sucursal) 'InstitucionAdquiriente',
dbo.fnTCInstitucionAdquirienteAMEXCfg(@Empresa, @Sucursal) 'InstitucionAdquirienteAMEX',
ConexionExplicita,
@PinPad 'Pinpad',
dbo.fnTCPinPad(@Empresa, @Sucursal, @Usuario, 'Puerto') 'Puerto',
TCPinPad.Velocidad,
TCPinPad.Paridad,
TCPinPad.BitsParada,
TCPinPad.BitsDatos,
CASE ModoOperacion
WHEN 'Produccion'	   THEN 'P'
WHEN 'Prueba Aleatoria' THEN 'R'
WHEN 'Prueba Aprobada'  THEN 'Y'
WHEN 'Prueba Declinada' THEN 'N'
END 'ModoOperacion',
TCSucursalCfg.Usuario,
TCSucursalCfg.Contrasena,
Afiliacion,
dbo.fnTCPinPad(@Empresa, @Sucursal, @Usuario, 'TerminalEquiv') 'TerminalEquivalente'
FROM TCCfg
JOIN Empresa ON TCCfg.Empresa = Empresa.Empresa
LEFT OUTER JOIN TCSucursalCfg ON TCCfg.Empresa = TCSucursalCfg.Empresa AND TCSucursalCfg.Sucursal = @Sucursal
LEFT OUTER JOIN TCPinPad ON TCPinPad.Pinpad = @PinPad
WHERE TCCfg.Empresa = @Empresa
FOR XML RAW('Cfg')
)
END

