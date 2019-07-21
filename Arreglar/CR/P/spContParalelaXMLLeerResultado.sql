SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaXMLLeerResultado
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@Resultado			varchar(max),
@ISReferencia		varchar(100),
@IDEmpresa			int,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @iSolicitud		int,
@Referencia		varchar(50)
IF NULLIF(RTRIM(@Resultado), '') IS NULL OR(@Resultado = '<?xml version="1.0" encoding="windows-1252" ?>')
BEGIN
SELECT @Ok = 4
RETURN
END
BEGIN TRY
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Resultado
SELECT @Ok = NULLIF(Ok, 0), @OkRef = NULLIF(OkRef, '')
FROM OPENXML (@iSolicitud, '/Intelisis',1)
WITH (Ok			int,
OkRef		varchar(255),
Mov			varchar(20),
MovID		varchar(20)
)
SELECT @Referencia = ISNULL(RTRIM(Mov), '')+' '+ISNULL(RTRIM(MovID), '')
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/ContParalela',1)
WITH (Mov		varchar(20),
MovID	varchar(20)
)
IF @Ok IS NULL
BEGIN
UPDATE ContParalelaXML SET Resultado = @Resultado WHERE ID = @ID
IF @MovTipo = 'CONTP.ENVIARCUENTAS'
BEGIN
SELECT Cuenta, CtaEstatus
INTO #Cuentas
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/ContParalelaD',1)
WITH (Cuenta			varchar(20),
CtaEstatus		varchar(50))
UPDATE ContParalelaD
SET CtaEstatus = #Cuentas.CtaEstatus
FROM ContParalelaD
JOIN #Cuentas ON ContParalelaD.Cuenta = #Cuentas.Cuenta
WHERE ContParalelaD.ID = @ID
END
IF @MovTipo = 'CONTP.PAQUETE'
BEGIN
SELECT ContID, ContMov, ContMovID, ContFechaEmision, ContOrigenTipo, ContOrigen, ContOrigenID, PolizaEstatus
INTO #Polizas
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/ContParalelaD',1)
WITH (ContID				int,
ContMov				varchar(20),
ContMovID			varchar(20),
ContFechaEmision	datetime,
ContOrigenTipo		varchar(5),
ContOrigen			varchar(5),
ContOrigenID		varchar(5),
PolizaEstatus		varchar(50)
)
UPDATE ContParalelaD
SET PolizaEstatus = #Polizas.PolizaEstatus
FROM ContParalelaD
JOIN #Polizas ON ContParalelaD.ContID = #Polizas.ContID
WHERE ContParalelaD.ID = @ID
END
END
EXEC sp_xml_removedocument @iSolicitud
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
RETURN
END CATCH
RETURN
END

