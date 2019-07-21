SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutNominaBanorte
@Estacion			int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@NumeroCliente		varchar(10),
@Consecutivo		int,
@Descripcion		varchar(50),
@Cuenta  			varchar(10),
@Sucursal			varchar(50),
@Ok					int					OUTPUT,
@OkRef				varchar(255)		OUTPUT

AS BEGIN
DECLARE
@ID					int
SELECT @ID= ID FROM Nomina WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
SELECT
'H' +
'NE' +
dbo.fnRellenarCerosIzquierda (ndi.BancoSucursal,8) +
dbo.fnFormatearFecha(n.FechaEmision,'AAAAMMDD') +
dbo.fnRellenarCerosIzquierda(@Consecutivo,2) +
dbo.fnRellenarCerosIzquierda(nr.NumReg,6) +
dbo.fnFormatearNumero( ndi.Importe,13,2) +
dbo.fnRellenarCerosIzquierda('',6)+
dbo.fnRellenarCerosIzquierda('',15) +
dbo.fnRellenarCerosIzquierda('',6) +
dbo.fnRellenarCerosIzquierda('',15) +
dbo.fnRellenarCerosIzquierda('',6) +
'1' +
dbo.fnRellenarEspaciosDerecha (' ',77)  AS COLUMN1
FROM Nomina n JOIN NominaDImporte ndi
ON n.ID = ndi.ID JOIN NumeroRegistro nr
ON nr.ID = ndi.ID
WHERE ndi.CtaDinero = @Cuenta AND ndi.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
AND @ID = n.ID
UNION ALL
SELECT
'D' +
dbo.fnFormatearFecha(n.FechaEmision,'AAAAMMDD') +
dbo.fnRellenarCerosIzquierda(ndip.Personal,10) +
dbo.fnRellenarEspaciosDerecha (' ',40) +
dbo.fnRellenarEspaciosDerecha (' ',40) +
dbo.fnFormatearNumero( ndip.Importe,13,2) +
'072' +
'01' +
dbo.fnRellenarCerosIzquierda(ndip.PersonalCuenta ,18) +
'0' +
' ' +
dbo.fnRellenarCerosIzquierda('',8) +
dbo.fnRellenarEspaciosDerecha (' ',18)  AS COLUMN1
FROM Nomina n JOIN NominaDImportePersonal ndip
ON n.ID = ndip.ID JOIN NumeroRegistro nr
ON nr.ID = ndip.ID JOIN Personal p
ON p.Personal = ndip.Personal
WHERE ndip.CtaDinero = @Cuenta AND ndip.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
IF @@ERROR <> 0 SET @Ok = 1
END

