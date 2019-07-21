SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutNominaInbursa
@Estacion			int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@NumeroCliente		varchar(10),
@Cuenta  			varchar(10),
@Sucursal			varchar(50),
@Consecutivo		int		,
@Ok					int					OUTPUT,
@OkRef				varchar(255)		OUTPUT

AS BEGIN
DECLARE
@ID					int,
@Numero				int,
@Texto				varchar(Max)
DECLARE	@Resultado	table
(
Texto	varchar(4000)
)
SELECT @ID= ID FROM Nomina WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
DECLARE crContador CURSOR FOR
SELECT
'{INC0001}' +
',' +
ndip.Personal +
',' +
RTRIM(ISNULL(ndip.Nombre,'')) + ' ' + RTRIM(ISNULL(ndip.ApellidoPaterno,'')) + ' ' + RTRIM(ISNULL(ndip.ApellidoMaterno,'')) +
',' +
ndip.PersonalCuenta +
',' +
dbo.fnRellenarCerosIzquierda(dbo.fnFormatearNumero2(ndip.Importe,2),15)
FROM Nomina n WITH(NOLOCK) JOIN NominaDImportePersonal ndip WITH(NOLOCK)
ON n.ID = ndip.ID   AND @ID = n.ID
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

