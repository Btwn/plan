SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexAlmacenar
@Modulo			char(5),
@ID				int,
@Usuario		varchar(10),
@Adicional		bit,
@AlmacenarXML	bit OUTPUT,
@AlmacenarPDF	bit OUTPUT,
@Nomarch		varchar(255) OUTPUT,
@Reporte		varchar(100) OUTPUT,
@Ruta			varchar(255) OUTPUT,
@EnviarPara		varchar(255) OUTPUT,
@EnviarAsunto	varchar(255) OUTPUT,
@EnviarMensaje	varchar(255) OUTPUT,
@Cliente		varchar(10)  OUTPUT,
@Sucursal		int OUTPUT,
@Enviar			bit          OUTPUT,
@EnviarXML		bit          OUTPUT,
@EnviarPDF		bit          OUTPUT,
@Cancelacion    bit = 0

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
IF @Modulo = 'VTAS' SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Cliente = RTRIM(Cliente), @Agente = RTRIM(Agente), @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro FROM Venta WHERE ID = @ID
IF @Modulo = 'CXC'  SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Cliente = RTRIM(Cliente), @Agente = RTRIM(Agente), @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro FROM CXC   WHERE ID = @ID
SELECT @Reporte = NULLIF(Reporte,'') FROM EmpresaCFDReporte WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov
IF @Reporte IS NULL SELECT @Reporte = NULLIF(CFD_Reporte,'') FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Enviar = Enviar, @AlmacenarTipo = RTRIM(AlmacenarTipo), @EnviarTipo = RTRIM(EnviarTipo) FROM CteCFD WHERE Cliente = @Cliente AND Almacenar = 1
IF @Adicional = 0
BEGIN
SELECT @AlmacenarXML = AlmacenarXML, @AlmacenarPDF = AlmacenarPDF, @Ruta = AlmacenarRuta, @Nombre = Nombre,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje, @Enviar = Enviar, @AlmacenarTipo = RTRIM(AlmacenarTipo), @EnviarTipo = RTRIM(EnviarTipo)
FROM CteCFD
WHERE Cliente = @Cliente
AND Almacenar = 1
AND AlmacenarTipo = 'ESPECIFICO'
IF @@ROWCOUNT = 0
SELECT @AlmacenarXML = AlmacenarXML, @AlmacenarPDF = AlmacenarPDF, @Ruta = AlmacenarRuta, @Nombre = Nombre, @Enviar = CASE WHEN EnviarXML = 1 OR EnviarPDF = 1 THEN 1 ELSE 0 END,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje
FROM EmpresaCFD
WHERE Empresa = @Empresa
AND (AlmacenarPDF = 1 OR AlmacenarXML = 1)
END ELSE
SELECT @AlmacenarXML = AlmacenarXML, @AlmacenarPDF = AlmacenarPDF, @Ruta = AlmacenarRuta, @Nombre = Nombre,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje, @AlmacenarTipo = RTRIM(AlmacenarTipo), @Enviar = Enviar, @EnviarTipo = RTRIM(EnviarTipo)
FROM CteCFD
WHERE Cliente = @Cliente
AND AlmacenarTipo = 'ADICIONAL'
IF NULLIF(@EnviarTipo,'') IS NULL SET @EnviarTipo = 'Cliente'
IF @Adicional = 0 AND @Cancelacion = 0
BEGIN
IF @AlmacenarTipo = 'Adicional' AND @Enviar = 1 AND @EnviarTipo = 'Cliente' SET @Enviar = 0
DELETE AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1
END ELSE
BEGIN
IF @Adicional = 1 AND @AlmacenarTipo = 'Adicional' AND @Enviar = 1 AND @EnviarTipo = 'Empresa' SET @Enviar = 0
END
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Folio OUTPUT
SELECT @NomArch = @Nombre
SELECT @NomArch = REPLACE(@NomArch, '<Movimiento>', LTRIM(RTRIM(ISNULL(@Mov,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Serie>', LTRIM(RTRIM(ISNULL(@Serie,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Folio>', CONVERT(varchar, LTRIM(RTRIM(ISNULL(@Folio,'')))))
SELECT @NomArch = REPLACE(@NomArch, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @Ruta = REPLACE(@Ruta, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @Ruta = REPLACE(@Ruta, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
IF @Cancelacion = 1
SELECT @Nomarch = 'CANCELACION_'+@NomArch
EXEC xpCFDFlexAlmacenar @Modulo, @ID, @Usuario, @Adicional, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @Nomarch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT, @EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT, @Cliente  OUTPUT, @Sucursal OUTPUT, @Enviar	OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT
IF RIGHT(@Ruta, 1) = '\' SELECT @Ruta = SUBSTRING(@Ruta, 1, LEN(@Ruta)-1)
IF @Adicional = 0 AND @Cancelacion = 0
BEGIN
DELETE AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 
END
SELECT @EnviarPara = '',
@EnviarAsunto  = REPLACE(@EnviarAsunto, '<Nombre>', @NomArch),
@EnviarMensaje = REPLACE(@EnviarMensaje, '<Nombre>', @NomArch)
DECLARE crCteCto CURSOR LOCAL FOR
SELECT eMail
FROM CteCto
WHERE Cliente = @Cliente AND CFD_Enviar = 1 AND NULLIF(RTRIM(eMail), '') IS NOT NULL
OPEN crCteCto
FETCH NEXT FROM crCteCto INTO @eMail
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EnviarPara <> '' SELECT @EnviarPara = @EnviarPara+';'
SELECT @EnviarPara = @EnviarPara + @eMail
END
FETCH NEXT FROM crCteCto INTO @eMail
END
CLOSE crCteCto
DEALLOCATE crCteCto
RETURN
END

