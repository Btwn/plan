SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutNominaBanamexD
@Estacion			int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@NumeroCliente		varchar(10),
@Consecutivo			int,
@Descripcion		varchar(20),
@Cuenta  			varchar(10),
@Sucursal			varchar(50),
@Ok					int					OUTPUT,
@OkRef				varchar(255)		OUTPUT

AS BEGIN
DECLARE
@ID					int
SELECT @ID= ID FROM Nomina WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
SELECT
'1' +
dbo.fnRellenarCerosIzquierda(@NumeroCliente		,12)+
dbo.fnFormatearFecha(n.FechaEmision,'DDMMAA') +
dbo.fnRellenarCerosIzquierda(@Consecutivo,4) +
dbo.fnRellenarEspaciosDerecha(SUBSTRING(e.Nombre,1,36),36) +
dbo.fnRellenarEspaciosDerecha(@Descripcion,20) +
'15' +
'D' +
'01' AS COLUMN1
FROM Nomina n WITH (NOLOCK)  JOIN Empresa e WITH (NOLOCK)
ON n.Empresa = e.Empresa
WHERE RTRIM(n.Empresa) = RTRIM(@Empresa)
AND n.ID = @ID
UNION ALL
SELECT
'2' +
'1' +
'001' +
dbo.fnFormatearNumero( ndi.Importe,16,2) +
'01' +
dbo.fnRellenarCerosIzquierda(ndi.BancoSucursal,3) +
dbo.fnRellenarCerosIzquierda(ndi.CtaDinero ,17) +
dbo.fnRellenarCerosIzquierda(nr.NumReg,6) AS COLUMN1
FROM Nomina n WITH (NOLOCK)  JOIN NominaDImporte ndi WITH (NOLOCK) 
ON n.ID = ndi.ID JOIN NumeroRegistro nr WITH (NOLOCK) 
ON nr.ID = ndi.ID
WHERE ndi.CtaDinero = @Cuenta AND ndi.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
AND  n.ID = @ID
UNION ALL
SELECT
'3' +
'0' +
'001' +
'01' +
'001' +
dbo.fnFormatearNumero(ndip.Importe,16,2) +
'03' +
dbo.fnRellenarCerosIzquierda(ndip.PersonalCuenta,20) +
dbo.fnRellenarEspaciosDerecha('Pago Banamex',16) +
dbo.fnRellenarEspaciosDerecha (RTRIM(ISNULL(ndip.Nombre,'')) + ',' + RTRIM(ISNULL(ndip.ApellidoPaterno,'')) + '/' + RTRIM(ISNULL(ndip.ApellidoMaterno,'')),55) +
dbo.fnRellenarEspaciosDerecha (' ',35) +
dbo.fnRellenarEspaciosDerecha (' ',35) +
dbo.fnRellenarEspaciosDerecha (' ',35) +
dbo.fnRellenarEspaciosDerecha (' ',35) +
'0000' +
'00' +
dbo.fnRellenarEspaciosDerecha (' ',14) +
dbo.fnRellenarEspaciosDerecha (' ',8) AS COLUMN1
FROM Nomina n  WITH (NOLOCK) JOIN NominaDImportePersonal ndip WITH (NOLOCK) 
ON n.ID = ndip.ID
WHERE ndip.CtaDinero = @Cuenta AND ndip.BancoSucursal = @Sucursal
AND  n.ID = @ID
UNION ALL
SELECT
'4' +
'001' +
dbo.fnRellenarCerosIzquierda(nr.NumReg,6) +
dbo.fnFormatearNumero( ndi.Importe,16,2) +
dbo.fnRellenarCerosIzquierda('1',6) +
dbo.fnFormatearNumero( ndi.Importe,16,2) AS COLUMN1
FROM Nomina n  WITH (NOLOCK) JOIN NominaDImporte ndi WITH (NOLOCK) 
ON n.ID = ndi.ID JOIN NumeroRegistro nr WITH (NOLOCK) 
ON nr.ID = ndi.ID
WHERE ndi.CtaDinero = @Cuenta AND ndi.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
AND n.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END

