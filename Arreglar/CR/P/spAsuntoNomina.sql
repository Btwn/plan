SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsuntoNomina
@Empresa   varchar(5),
@ID		int = NULL,
@Personal  varchar(50),
@Asunto	varchar(max)=NULL OUTPUT

AS BEGIN
DECLARE
@Curp				varchar(255),
@FechaPago			varchar(100),
@FechaInicialPago	varchar(100),
@FechaFinalPago		varchar(20),
@Departamento		varchar(20),
@Puesto				varchar(20),
@RfcEmisor			varchar(20),
@Rfc				varchar(20)
SELECT  @Curp = Curp, @FechaPago = FechaPago, @FechaInicialPago = FechaInicialPago, @FechaFinalPago = FechaFinalPago, @Departamento = Departamento,@Puesto	=Puesto ,@RfcEmisor=RfcEmisor, @Rfc=RFC FROM CFDINominaRecibo WHERE RID = @ID  AND Personal =@Personal
SELECT @Asunto=EnviarAsuntoNomina from EmpresaCFD where Empresa =@Empresa
SELECT @Asunto = @Asunto
SELECT @Asunto = REPLACE(@Asunto, '<Personal>', LTRIM(RTRIM(ISNULL(@Personal,''))))
SELECT @Asunto = REPLACE(@Asunto, '<Curp>', LTRIM(RTRIM(ISNULL(@Curp,''))))
SELECT @Asunto = REPLACE(@Asunto, '<FechaPago>', LTRIM(RTRIM(ISNULL(@FechaPago,''))))
SELECT @Asunto = REPLACE(@Asunto, '<FechaInicialPago>', LTRIM(RTRIM(ISNULL(@FechaInicialPago,''))))
SELECT @Asunto = REPLACE(@Asunto, '<FechaFinalPago>', LTRIM(RTRIM(ISNULL(@FechaFinalPago,''))))
SELECT @Asunto = REPLACE(@Asunto, '<Departamento>', LTRIM(RTRIM(ISNULL( @Departamento,''))))
SELECT @Asunto = REPLACE(@Asunto, '<Puesto>', LTRIM(RTRIM(ISNULL(@Puesto,''))))
SELECT @Asunto = REPLACE(@Asunto, '<RfcEmisor>', LTRIM(RTRIM(ISNULL(@RfcEmisor,''))))
SELECT @Asunto = REPLACE(@Asunto, '<Rfc>', LTRIM(RTRIM(ISNULL(@Rfc,''))))
END

