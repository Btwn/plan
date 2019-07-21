SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDAlmacenar
@Modulo		char(5),
@ID		int,
@Usuario	varchar(10),
@Adicional	bit

AS BEGIN
DECLARE
@Empresa		char(5),
@Sucursal		int,
@Cliente		char(10),
@Agente		char(10),
@Mov		varchar(20),
@MovID		varchar(20),
@FechaEmision	datetime,
@XML		bit,
@PDF		bit,
@ArchivoXML		varchar(255),
@ArchivoPDF		varchar(255),
@Ruta		varchar(255),
@Nombre		varchar(100),
@Reporte		varchar(100),
@NomArch		varchar(255),
@eMail		varchar(100),
@EnviarXML		bit,
@EnviarPDF		bit,
@EnviarMedio	varchar(20),
@EnviarDireccion	varchar(255),
@EnviarRuta		varchar(255),
@EnviarUsuario	varchar(100),
@EnviarContrasena	varchar(100),
@EnviarDe		varchar(255),
@EnviarPara		varchar(255),
@EnviarCC		varchar(255),
@EnviarCCO		varchar(255),
@EnviarAsunto	varchar(255),
@EnviarMensaje	varchar(255),
@Serie			varchar(20),
@Folio			bigint,
@Estatus		varchar(20),
@Anexos			varchar(8000)
SELECT @XML = 0, @PDF = 0, @NomArch = NULL
IF @Modulo = 'VTAS' SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Cliente = Cliente, @Agente = Agente, @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @Estatus = Estatus FROM Venta WHERE ID = @ID
IF @Modulo = 'CXC' SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Cliente = Cliente, @Agente = Agente, @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @Estatus = Estatus  FROM CXC WHERE ID = @ID
SELECT @Reporte = CFD_Reporte FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @Adicional = 0
BEGIN
SELECT @XML = AlmacenarXML, @PDF = AlmacenarPDF, @Ruta = AlmacenarRuta, @Nombre = Nombre,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarMedio = EnviarMedio, @EnviarDireccion = EnviarDireccion, @EnviarRuta = EnviarRuta, @EnviarUsuario = EnviarUsuario, @EnviarContrasena = EnviarContrasena, @EnviarDe = EnviarDe, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje
FROM CteCFD
WHERE Cliente = @Cliente AND Almacenar = 1 AND AlmacenarTipo = 'ESPECIFICO'
IF @@ROWCOUNT = 0
SELECT @XML = AlmacenarXML, @PDF = AlmacenarPDF, @Ruta = AlmacenarRuta, @Nombre = Nombre,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarMedio = EnviarMedio, @EnviarDireccion = EnviarDireccion, @EnviarRuta = EnviarRuta, @EnviarUsuario = EnviarUsuario, @EnviarContrasena = EnviarContrasena, @EnviarDe = EnviarDe, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje
FROM EmpresaCFD
WHERE Empresa = @Empresa AND Almacenar = 1
END ELSE
SELECT @XML = AlmacenarXML, @PDF = AlmacenarPDF, @Ruta = AlmacenarRuta, @Nombre = Nombre,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @EnviarMedio = EnviarMedio, @EnviarDireccion = EnviarDireccion, @EnviarRuta = EnviarRuta, @EnviarUsuario = EnviarUsuario, @EnviarContrasena = EnviarContrasena, @EnviarDe = EnviarDe, @EnviarAsunto = EnviarAsunto, @EnviarMensaje = EnviarMensaje
FROM CteCFD
WHERE Cliente = @Cliente AND Validar = 1 AND AlmacenarTipo = 'ADICIONAL'
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Folio OUTPUT
SELECT @NomArch = @Nombre
SELECT @NomArch = REPLACE(@NomArch, '<Movimiento>', @Mov)
SELECT @NomArch = REPLACE(@NomArch, '<Serie>', ISNULL(@Serie,''))
SELECT @NomArch = REPLACE(@NomArch, '<Folio>', CONVERT(varchar, @Folio))
SELECT @NomArch = REPLACE(@NomArch, '<Cliente>', @Cliente)
SELECT @Ruta = REPLACE(@Ruta, '<Cliente>', @Cliente)
SELECT @Ruta = REPLACE(@Ruta, '<Ejercicio>', CONVERT(varchar, YEAR(GETDATE())))
SELECT @Ruta = REPLACE(@Ruta, '<Periodo>', CONVERT(varchar, MONTH(GETDATE())))
EXEC xpCFDAlmacenar @Modulo, @ID, @Usuario, @Adicional, @XML OUTPUT, @PDF OUTPUT, @NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT
IF RIGHT(@Ruta, 1) = '\' SELECT @Ruta = SUBSTRING(@Ruta, 1, LEN(@Ruta)-1)
IF @Adicional = 0 AND @Estatus != 'CANCELADO'
BEGIN
DELETE AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 
DELETE CFDEnviar WHERE Modulo = @Modulo AND ModuloID = @ID
END
IF @XML = 1
BEGIN
SELECT @ArchivoXML = @Ruta+'\'+@NomArch+'.xml'
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Nombre LIKE '%.xml')
AND @Estatus != 'CANCELADO'
INSERT AnexoMov (Sucursal,  Rama,    ID,  Nombre,          Direccion,    Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ID, @NomArch+'.xml', @ArchivoXML, 'Archivo', 17, 1)
END
IF @PDF = 1
BEGIN
SELECT @ArchivoPDF = @Ruta+'\'+@NomArch+'.pdf'
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Nombre LIKE '%.pdf')
AND @Estatus != 'CANCELADO'
INSERT AnexoMov (Sucursal,  Rama,    ID,  Nombre,          Direccion,   Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ID, @NomArch+'.pdf', @ArchivoPDF, 'Archivo', 745, 1)
END
IF @EnviarDe = '(Usuario)' SELECT @EnviarDe = dbo.fnCorreoNombre(eMail, Nombre) FROM Usuario WHERE Usuario = @Usuario ELSE
IF @EnviarDe = '(Agente)'  SELECT @EnviarDe = dbo.fnCorreoNombre(eMail, Nombre) FROM Agente  WHERE Agente  = @Agente
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
EXEC xpCFDEnviar @Modulo, @ID, @Usuario, @Adicional, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, @ArchivoXML OUTPUT, @ArchivoPDF OUTPUT, @EnviarMedio OUTPUT, @EnviarDireccion OUTPUT, @EnviarRuta OUTPUT, @EnviarUsuario OUTPUT, @EnviarContrasena OUTPUT, @EnviarDe OUTPUT, @EnviarPara OUTPUT, @EnviarCC OUTPUT, @EnviarCCO OUTPUT, @EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT
IF @EnviarXML = 1 SELECT @Anexos = NULLIF(@ArchivoXML,'')
IF @EnviarPDF = 1
BEGIN
IF @Anexos IS NOT NULL SELECT @Anexos = @Anexos + ';'
SELECT @Anexos = ISNULL(@Anexos,'') + @ArchivoPDF
END
IF @EnviarXML = 1 OR @EnviarPDF = 1
INSERT CFDEnviar (Modulo, ModuloID, Estatus,     ArchivoXML,  /*ArchivoPDF,*/  Medio,        Direccion,        Ruta,        Usuario,        Contrasena,        De,        Para,        CC,        CCO,        Asunto,        Mensaje)
VALUES (@Modulo, @ID,     'PENDIENTE', @Anexos, /*@ArchivoPDF,*/ @EnviarMedio, @EnviarDireccion, @EnviarRuta, @EnviarUsuario, @EnviarContrasena, @EnviarDe, @EnviarPara, @EnviarCC, @EnviarCCO, @EnviarAsunto, @EnviarMensaje)
IF @Estatus != 'CANCELADO'
SELECT 'XML' = @XML, 'PDF' = @PDF, 'NomArch' = @NomArch, 'Reporte' = @Reporte, 'Ruta' = @Ruta
ELSE
SELECT 'XML' = '', 'PDF' = '', 'NomArch' = '', 'Reporte' = '', 'Ruta' = ''
RETURN
END

