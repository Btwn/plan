SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spLayoutNominaSantander
@Estacion			int,
@Empresa			varchar(10),
@Mov				varchar(20),
@MovID				varchar(20),
@NumeroCliente		varchar(10),
@Consecutivo		int,
@Descripcion		varchar(20),
@Cuenta  			varchar(10),
@Sucursal			varchar(50),
@FechaAplicacion    datetime ,
@Ok					int					OUTPUT,
@OkRef				varchar(255)		OUTPUT

AS BEGIN
DECLARE
@ID					int,
@Numero				int,
@Texto				varchar(MAX)
DECLARE	@Resultado	table
(
Texto	varchar(4000)
)
SELECT @ID= ID FROM Nomina WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
DECLARE crContador CURSOR FOR
SELECT
'1' +
'{INC0001}' +
'E' +
dbo.fnFormatearFecha(n.FechaEmision,'MMDDAAAA') +
dbo.fnRellenarCerosIzquierda(ndi.CtaDinero,16) +
dbo.fnFormatearFecha(@FechaAplicacion,'MMDDAAAA')
FROM Nomina n JOIN NominaDImporte ndi
ON n.ID = ndi.ID JOIN NumeroRegistro nr
ON nr.ID = ndi.ID
WHERE ndi.CtaDinero = @Cuenta AND ndi.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
AND @ID = n.ID
UNION ALL
SELECT
'2' +
'{INC0001}' +
dbo.fnRellenarEspaciosIzquierda (ndip.Personal,7) +
dbo.fnRellenarEspaciosDerecha (RTRIM(ISNULL(ndip.ApellidoPaterno,'')),30) +
dbo.fnRellenarEspaciosDerecha (RTRIM(ISNULL(ndip.ApellidoMaterno,'')),20) +
dbo.fnRellenarEspaciosDerecha (RTRIM(ISNULL(ndip.Nombre,'')),30) +
dbo.fnRellenarEspaciosDerecha (ndip.PersonalCuenta,16) +
dbo.fnFormatearNumero(ndip.Importe,16,2)
FROM Nomina n JOIN NominaDImportePersonal ndip
ON n.ID = ndip.ID JOIN NumeroRegistro nr
ON nr.ID = ndip.ID
WHERE ndip.CtaDinero = @Cuenta AND ndip.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
AND @ID = n.ID
UNION ALL
SELECT
'3' +
'{INC0001}' +
dbo.fnFormatearNumero( ndi.Importe,16,2)
FROM Nomina n JOIN NominaDImporte ndi
ON n.ID = ndi.ID JOIN NumeroRegistro nr
ON nr.ID = ndi.ID
WHERE ndi.CtaDinero = @Cuenta AND ndi.BancoSucursal = @Sucursal
AND nr.CtaDinero = @Cuenta AND nr.BancoSucursal = @Sucursal
AND @ID = n.ID
SET @Numero = 1
OPEN crContador
FETCH NEXT FROM  crContador INTO @Texto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT  INTO @Resultado VALUES (REPLACE(@Texto,'{INC0001}',CONVERT(varchar,dbo.fnRellenarCerosIzquierda(@Numero,5))))
SET @Numero = @Numero + 1
FETCH NEXT FROM crContador INTO @Texto
END
CLOSE crContador
DEALLOCATE crContador
SELECT Texto AS COLUMN1 FROM @Resultado
IF @@ERROR <> 0 SET @Ok = 1
END

