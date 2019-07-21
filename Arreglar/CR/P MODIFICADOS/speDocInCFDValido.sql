SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInCFDValido
@XML                                    xml,
@Operando1                              varchar(max),
@Origen                                 varchar(max),
@Empresa				varchar(5),
@Valido                                 bit  OUTPUT,
@Ok					int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RutaFirmaSAT			varchar(255),
@RutaCertificado		        varchar(255),
@Shell				varchar(8000)
DECLARE @Datos			TABLE
(
Datos				varchar(255)
)
SET @Valido = 0
SELECT @RutaFirmaSAT = RutaFirmaSAT, @RutaCertificado = RutaCertificado FROM EmpresaCFD WHERE Empresa = @Empresa
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' VERIFYSIG ' + CHAR(34) + @Origen + CHAR(34)+ CHAR(34)
INSERT @Datos
EXEC xp_cmdshell @Shell
IF @@ERROR <> 0 SET @Ok = 1
IF EXISTS(SELECT * FROM @Datos WHERE Datos = 'OK') AND @Ok IS NULL
SELECT @Valido = 1
END

