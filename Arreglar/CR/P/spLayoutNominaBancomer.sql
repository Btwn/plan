SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutNominaBancomer
@Estacion			int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@NumeroCliente		varchar(10),
@Consecutivo        varchar(50),
@Cuenta  			varchar(10),
@Sucursal			varchar(50),
@Descripcion		varchar(50),
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
dbo.fnRellenarCerosIzquierda (@Empresa,5) +
dbo.fnRellenarEspaciosDerecha (e.RFC,16) +
dbo.fnRellenarCerosIzquierda ( @Consecutivo,9) +
'99' +
dbo.fnRellenarCerosIzquierda ( ndi.CtaDinero,12) +
dbo.fnRellenarCerosIzquierda ('',12) +
dbo.fnFormatearNumero( ndi.Importe,13,2) +
dbo.fnFormatearFecha(n.FechaEmision,'AAAAMMDD') +
dbo.fnRellenarCerosIzquierda ('',8) +
'01' +
dbo.fnRellenarEspaciosDerecha ('',40) +
'{INC0001}' +
dbo.fnRellenarCerosIzquierda (ndi.BancoSucursal,6) +
dbo.fnRellenarCerosIzquierda ('99',3) +
dbo.fnRellenarCerosIzquierda ('03',3) +
dbo.fnRellenarCerosIzquierda('',16) +
dbo.fnRellenarEspaciosDerecha ('',12) +
dbo.fnRellenarEspaciosDerecha ('.',1)
FROM Nomina n JOIN Empresa e
ON n.Empresa = e.Empresa JOIN NominaDImporte ndi
ON n.ID = ndi.ID
WHERE RTRIM(n.Empresa) = RTRIM(@Empresa)
AND n.ID = @ID
UNION ALL
SELECT
dbo.fnRellenarCerosIzquierda (@Empresa,5) +
dbo.fnRellenarEspaciosDerecha (p.Registro2,16) +
dbo.fnRellenarEspaciosDerecha(' ',9) +
'99' +
dbo.fnRellenarCerosIzquierda ( ndip.CtaDinero,12) +
dbo.fnRellenarCerosIzquierda (ndip.PersonalCuenta,12) +
dbo.fnFormatearNumero(ndip.Importe ,13,2) +
dbo.fnFormatearFecha(n.FechaEmision,'AAAAMMDD') +
dbo.fnRellenarCerosIzquierda ('',8) +
dbo.fnRellenarCerosIzquierda ('01',2) +
dbo.fnRellenarEspaciosDerecha (RTRIM(ISNULL(ndip.Nombre,'')) + ',' + RTRIM(ISNULL(ndip.ApellidoPaterno,'')) + '/' + RTRIM(ISNULL(ndip.ApellidoMaterno,'')),40) +
'{INC0001}' +
dbo.fnRellenarCerosIzquierda (ndip.BancoSucursal,6) +
dbo.fnRellenarCerosIzquierda ('99',3) +
dbo.fnRellenarCerosIzquierda ('03',3) +
dbo.fnRellenarCerosIzquierda (ndip.PersonalCuenta,16) +
dbo.fnRellenarEspaciosDerecha (' ',12) +
dbo.fnRellenarEspaciosDerecha ('.',1)
FROM NominaDImportePersonal	ndip JOIN Personal p
ON p.Personal = ndip.Personal
JOIN Nomina n
ON n.ID = ndip.ID
WHERE ndip.CtaDinero = @Cuenta AND ndip.BancoSucursal = @Sucursal
UNION ALL
SELECT
dbo.fnRellenarCerosIzquierda (@Empresa,5) +
dbo.fnRellenarEspaciosDerecha ('T',16) +
dbo.fnRellenarCerosIzquierda ( @Consecutivo,9) +
'99' +
dbo.fnRellenarCerosIzquierda ( ndi.CtaDinero,12) +
dbo.fnRellenarCerosIzquierda ('',12) +
dbo.fnFormatearNumero( ndi.Importe,13,2) +
dbo.fnFormatearFecha(n.FechaEmision,'AAAAMMDD') +
dbo.fnRellenarCerosIzquierda ('',8) +
'01' +
dbo.fnRellenarEspaciosDerecha (' ',40) +
'{INC0001}' +
dbo.fnRellenarCerosIzquierda (ndi.BancoSucursal,6) +
dbo.fnRellenarCerosIzquierda ('99',3) +
dbo.fnRellenarCerosIzquierda ('03',3) +
dbo.fnRellenarCerosIzquierda('',16) +
dbo.fnRellenarEspaciosDerecha (' ',12) +
dbo.fnRellenarEspaciosDerecha ('.',1)
FROM Nomina n JOIN Empresa e
ON n.Empresa = e.Empresa JOIN NominaDImporte ndi
ON n.ID = ndi.ID JOIN NumeroRegistro nr
ON nr.ID = ndi.ID
SET @Numero = 1
OPEN crContador
FETCH NEXT FROM  crContador INTO @Texto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT  INTO @Resultado VALUES (REPLACE(@Texto,'{INC0001}',CONVERT(varchar,dbo.fnRellenarCerosIzquierda(@Numero,5))))
IF @@ERROR <> 0 SET @Ok = 1
SET @Numero = @Numero + 1
FETCH NEXT FROM crContador INTO @Texto
END
CLOSE crContador
DEALLOCATE crContador
IF @Ok IS NULL
BEGIN
SELECT Texto AS COLUMN1 FROM @Resultado
IF @@ERROR <> 0 SET @Ok = 1
END
END

