SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDNominaAlmacenar
@Modulo			char(5),
@ID				int,
@AlmacenarXML	bit OUTPUT,
@AlmacenarPDF	bit OUTPUT,
@NomArch		varchar(255) OUTPUT,
@Reporte		varchar(100) OUTPUT,
@Ruta			varchar(255) OUTPUT,
@EnviarPara		varchar(255) OUTPUT,
@EnviarAsunto	varchar(255) OUTPUT,
@EnviarMensaje	varchar(255) OUTPUT,
@Personal		varchar(10)  OUTPUT,
@Sucursal		int			 OUTPUT,
@Enviar			bit          OUTPUT,
@EnviarXML		bit          OUTPUT,
@EnviarPDF		bit          OUTPUT,
@Cancelacion	bit = 0,
@NoTimbrado		int = 0

AS BEGIN
DECLARE
@Empresa		char(5),
@Agente			char(10),
@Mov			varchar(20),
@MovID			varchar(20),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@ArchivoXML		varchar(255),
@ArchivoPDF		varchar(255),
@Nombre			varchar(100),
@eMail			varchar(100),
@Serie			varchar(20),
@Folio			bigint,
@AlmacenarTipo  varchar(20),
@EnviarTipo		varchar(20)
SELECT @EnviarXML = 0, @EnviarPDF = 0, @NomArch = NULL
IF @Modulo = 'NOM' SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro FROM Nomina WHERE ID = @ID
SELECT @Reporte = NULLIF(Reporte,'') FROM CFDINominaMov WHERE Mov = @Mov
SELECT @AlmacenarXML = AlmacenarXML, @AlmacenarPDF = AlmacenarPDF, @Ruta = NominaAlmacenarRuta, @Nombre = NominaNombre, @Enviar = CASE WHEN EnviarXML = 1 OR EnviarPDF = 1 THEN 1 ELSE 0 END,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje
FROM EmpresaCFD
WHERE Empresa = @Empresa
IF NULLIF(@EnviarTipo,'') IS NULL SET @EnviarTipo = 'Cliente'
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Folio OUTPUT
SELECT @NomArch = @Nombre
SELECT @NomArch = REPLACE(@NomArch, '<Movimiento>', LTRIM(RTRIM(ISNULL(@Mov,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Serie>', LTRIM(RTRIM(ISNULL(@Serie,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Folio>', CONVERT(varchar, LTRIM(RTRIM(ISNULL(@Folio,'')))))
SELECT @NomArch = REPLACE(@NomArch, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Personal>', LTRIM(RTRIM(ISNULL(@Personal,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @NomArch = @NomArch + '_' +  CONVERT(varchar, ISNULL(@NoTimbrado, 1))
IF @Cancelacion = 1
SELECT @Nomarch = @NomArch+'_CANCELACION'
SELECT @Ruta = REPLACE(@Ruta, '<Personal>', LTRIM(RTRIM(ISNULL(@Personal,''))))
SELECT @Ruta = REPLACE(@Ruta, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @Ruta = REPLACE(@Ruta, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
EXEC xpCFDNominaAlmacenar @Modulo, @ID, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT, @EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT, @Personal  OUTPUT, @Sucursal OUTPUT, @Enviar	OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT
IF RIGHT(@Ruta, 1) = '\' SELECT @Ruta = SUBSTRING(@Ruta, 1, LEN(@Ruta)-1)
SELECT @EnviarPara = '',
@EnviarAsunto  = REPLACE(@EnviarAsunto, '<Nombre>', @NomArch),
@EnviarMensaje = REPLACE(@EnviarMensaje, '<Nombre>', @NomArch)
SELECT @EnviarPara = email FROM Personal WHERE Personal = @Personal
RETURN
END

