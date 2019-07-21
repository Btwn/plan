SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegistroOk
@Cual            varchar(20),
@Registro        varchar(20),
@Empresa		char(5) = NULL,
@EnSilencio	bit	= 0,
@Ok		bit 	= 1	OUTPUT  

AS BEGIN
DECLARE
@Largo                     int,
@Digito                    varchar(1)
IF (SELECT ValidarRegistros FROM EmpresaGral WHERE Empresa = @Empresa) = 0
IF @EnSilencio = 0
BEGIN
SELECT "Ok" = @Ok
RETURN
END
SELECT @Ok = 1
SELECT @Registro = NULLIF(NULLIF(RTRIM(@Registro),  '0'),  '')
IF @Cual='RFC' AND LEN(ISNULL(@REGISTRO, '')) > 0
BEGIN
SELECT @Largo=LEN(ISNULL(@Registro, ''))
IF (@Largo < 9 AND @Largo <>0) SELECT @Ok=0
IF @Largo=10 OR @Largo=13                 
BEGIN
IF dbo.fnEsNumerico(SUBSTRING(@Registro, 7, 2)) < 1 or dbo.fnEsNumerico(SUBSTRING(@Registro, 7, 2)) > 12 SELECT @OK=0
IF dbo.fnEsNumerico(SUBSTRING(@Registro, 9, 2)) < 1 or dbo.fnEsNumerico(SUBSTRING(@Registro, 9, 2)) > 31 SELECT @OK=0
IF dbo.fnEsNumerico(SUBSTRING(@Registro, 1, 1))<>0 OR dbo.fnEsNumerico(SUBSTRING(@Registro, 2, 1))<>0 OR
dbo.fnEsNumerico(SUBSTRING(@Registro, 3, 1))<>0 OR dbo.fnEsNumerico(SUBSTRING(@Registro, 4, 1))<>0 OR
dbo.fnEsNumerico(SUBSTRING(@Registro, 5, 6))<>1 SELECT @OK=0
IF @LARGO = 13
BEGIN
EXEC spRFCDigitoVerificador @Registro,  @Digito OUTPUT
IF RIGHT(RTRIM(@REGISTRO), 1) <> @Digito
BEGIN
IF NOT EXISTS(SELECT Valor FROM RFCValidos WHERE Valor = @Registro AND Tipo = @Cual)
SELECT @OK=0
END
END
END ELSE IF @Largo=9 OR @Largo=12         
BEGIN
IF dbo.fnEsNumerico(SUBSTRING(@Registro, 6, 2)) < 1 OR dbo.fnEsNumerico(SUBSTRING(@Registro, 6, 2)) > 12 SELECT @OK=0
IF dbo.fnEsNumerico(SUBSTRING(@Registro, 8, 2)) < 1 OR dbo.fnEsNumerico(SUBSTRING(@Registro, 8, 2)) > 31 SELECT @OK=0
IF dbo.fnEsNumerico(SUBSTRING(@Registro, 1, 1))<>0 OR dbo.fnEsNumerico(SUBSTRING(@Registro, 2, 1))<>0 OR
dbo.fnEsNumerico(SUBSTRING(@Registro, 3, 1))<>0 OR dbo.fnEsNumerico(SUBSTRING(@Registro, 4, 6))<>1 SELECT @OK=0
END ELSE SELECT @OK=0
END  ELSE
IF @Cual='IMSS' AND LEN(ISNULL(@REGISTRO, ''))>0
BEGIN
EXEC spNominaVerDigitoIMSS @Registro, @Digito OUTPUT
IF @Digito=SUBSTRING(RTRIM(@Registro), 11, 1) AND LEN(RTRIM(LTRIM(ISNULL(@Registro, ''))))=11
SELECT  @OK=1
ELSE
BEGIN
IF NOT EXISTS(SELECT Valor FROM RFCValidos WHERE Valor = @Registro AND Tipo = @Cual)
SELECT @OK=0
END
END
IF @Cual='CURP' AND LEN(ISNULL(@REGISTRO, ''))>0
BEGIN
EXEC spCURPDigitoVerificador @Registro,  @Digito OUTPUT
IF RIGHT(RTRIM(@REGISTRO), 1) <> @Digito
BEGIN
IF NOT EXISTS(SELECT Valor FROM RFCValidos WHERE Valor = @Registro AND Tipo = @Cual)
SELECT @OK=0
END
END
IF @EnSilencio = 0
SELECT "Ok" = @Ok
RETURN
END

