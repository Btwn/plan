SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarValidarLic
@Modulo		char(5),
@ID                  int,
@Accion		char(20),
@Base		char(20),
@GenerarMov		char(20),
@Usuario		char(10),
@SincroFinal		bit,
@EnSilencio	        bit,
@Ok               	int 		OUTPUT,
@OkRef            	varchar(255) 	OUTPUT,
@FechaRegistro	datetime

AS BEGIN
DECLARE
@DocumentoXML		xml,
@iDatos			int,
@Documento		varchar(max),
@LimitarMovTipo	bit,
@MaxIDLic			int,
@IDLic			int,
@ClavePermitida	varchar(20),
@ModuloClavePermitida varchar(20),
@MovTipo			varchar(20),
@MovTipoGenerar	varchar(20),
@Licenciamiento   varchar(50)
SELECT @Licenciamiento = Licenciamiento FROM Usuario WHERE Usuario = @Usuario
SELECT @Documento = LicenciamientoXML FROM  master.dbo.IntelisisMKLic WHERE Licenciamiento = @Licenciamiento
IF CHARINDEX('<LimitarMovTipo>S</LimitarMovTipo>',@Documento,1) > 0
SELECT @LimitarMovTipo = 1
IF @LimitarMovTipo != 1
RETURN
IF @LimitarMovTipo = 1
BEGIN
CREATE TABLE #LicClavePermitida (ID int identity(1,1), Clave varchar(20) COLLATE DATABASE_DEFAULT NULL)
CREATE TABLE #ClavePermitida (Clave varchar(20) COLLATE DATABASE_DEFAULT NULL)
EXEC spMovInfo @ID, @Modulo, @MovTipo = @MovTipo OUTPUT
EXEC spMovInfo NULL, @Modulo, @Mov = @GenerarMov, @MovTipo = @MovTipoGenerar OUTPUT
SELECT @DocumentoXML = CONVERT(XML,REPLACE(REPLACE(@Documento,'encoding="UTF-8"','encoding="Windows-1252"'),'?<?xml','<?xml'))
EXEC sp_xml_preparedocument @iDatos OUTPUT, @DocumentoXML
INSERT INTO #LicClavePermitida (Clave)
SELECT  Clave FROM OPENXML (@iDatos, 'Intelisis/MovTipo/MovTipoDet',1) WITH (Clave  varchar(20))
EXEC sp_xml_removedocument @iDatos
SELECT @MaxIDLic = MAX(ID) FROM #LicClavePermitida
SELECT @IDLic = 1, @ClavePermitida = NULL
WHILE @IDLic <= @MaxIDLic
BEGIN
SELECT @IDLic = ID, @ClavePermitida = Clave FROM #LicClavePermitida WHERE ID = @IDlic
IF CHARINDEX('*',@ClavePErmitida) > 1
BEGIN
SELECT @ModuloClavePermitida = REPLACE(@ClavePermitida,'.*','')
INSERT INTO #ClavePermitida (Clave) SELECT Clave FROM MovTipo WHERE Modulo = @ModuloClavePermitida
END
ELSE
INSERT INTO #ClavePermitida (Clave) SELECT @ClavePermitida
SELECT @IDLic = @IDLic+1, @ClavePermitida = NULL
END
IF @MovTipo IS NOT NULL AND @MovTipo NOT IN (SELECT Clave FROM #ClavePermitida)
SELECT @Ok = 10065, @OkREf = 'Su licenciamiento no tiene acceso a este movimiento. '+@MovTipo
IF @Ok IS NULL AND @MovTipoGenerar IS NOT NULL AND @MovTipoGenerar NOT IN (SELECT Clave FROM #ClavePermitida)
SELECT @Ok = 10065, @OkREf = 'Su licenciamiento no tiene acceso a este movimiento. '+@MovTipoGenerar
END
RETURN
END

