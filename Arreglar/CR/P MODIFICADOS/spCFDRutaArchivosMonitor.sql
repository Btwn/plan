SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDRutaArchivosMonitor
@Empresa     varchar(5),
@Modulo      varchar(5),
@Mov         varchar(20),
@ID          int = NULL,
@TipoDocumento varchar(20) =NULL,
@Ruta   varchar(250) OUTPUT

AS
DECLARE
@Agente   char(10),
@MovID   varchar(20),
@FechaEmision datetime,
@FechaRegistro datetime,
@ArchivoXML  varchar(255),
@ArchivoPDF  varchar(255),
@Nombre   varchar(100),
@eMail   varchar(100),
@Serie   varchar(20),
@Folio   varchar(20),
@AlmacenarTipo  varchar(20),
@EnviarTipo  varchar(20),
@Sucursal       int,
@Cliente        varchar(10),
@RutaOriginal   varchar(255),
@NomArch        varchar(255),
@RutaActual   varchar(255)
SET @RutaOriginal = ''
IF @TipoDocumento = 'XML'  SELECT @RutaOriginal = direccion FROM AnexoMov WITH (NOLOCK) WHERE Rama =@Modulo  AND  ID=@ID  AND Icono =17
IF @TipoDocumento = 'PDF'  SELECT @RutaOriginal = direccion FROM AnexoMov WITH (NOLOCK) WHERE Rama =@Modulo  AND  ID=@ID  AND Icono =745
IF @Modulo        = 'VTAS' SELECT @Sucursal = Sucursal, @Cliente = RTRIM(Cliente), @Agente = RTRIM(Agente), @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Folio = MovID FROM Venta WITH (NOLOCK) WHERE ID = @ID
IF @Modulo        = 'CXC'  SELECT @Sucursal = Sucursal, @Cliente = RTRIM(Cliente), @Agente = RTRIM(Agente), @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Folio = MovID FROM CXC WITH (NOLOCK)   WHERE ID = @ID
SELECT @RutaActual = AlmacenarRuta, @Nombre = Nombre   FROM EmpresaCFD WITH (NOLOCK)     WHERE Empresa = @Empresa
SELECT @NomArch = @Nombre
SELECT @NomArch = REPLACE(@NomArch, '<Movimiento>', LTRIM(RTRIM(ISNULL(@Mov,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Serie>', LTRIM(RTRIM(ISNULL(@Serie,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Folio>', LTRIM(RTRIM(CONVERT(varchar, LTRIM(RTRIM(ISNULL(@Folio,'')))))))
SELECT @NomArch = REPLACE(@NomArch, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @RutaActual = REPLACE(@RutaActual, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @RutaActual = REPLACE(@RutaActual, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @RutaActual = REPLACE(@RutaActual, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @RutaActual = REPLACE(@RutaActual, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @RutaActual = REPLACE(@RutaActual, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
IF   CHARINDEX('\',@RutaActual,DATALENGTH(@RutaActual))=0 SELECT @RutaActual=@RutaActual+'\'
IF ISNULL(@RutaActual,'') <> '' AND ISNULL(@NomArch,'') <> ''
BEGIN
IF @TipoDocumento ='PDF'
SELECT  @NomArch= @NomArch+'.pdf'
IF @TipoDocumento ='XML'
SELECT @NomArch= @NomArch+'.xml'
IF @RutaOriginal =NULL
BEGIN
IF @TipoDocumento ='PDF'
BEGIN
IF NOT EXISTS(SELECT * FROM AnexoMov WITH (NOLOCK) WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Nombre LIKE '%.pdf')
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,          Direccion,   Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ID, @NomArch, @RutaActual+@NomArch, 'Archivo', 745,   1)
SELECT @Ruta  =  @RutaActual+ @NomArch
END
IF @TipoDocumento ='XML'
BEGIN
IF NOT EXISTS(SELECT * FROM AnexoMov WITH (NOLOCK) WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Nombre LIKE '%.xml')
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,          Direccion,   Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ID, @NomArch, @RutaActual+@NomArch, 'Archivo', 17,   1)
SELECT @Ruta  =  @RutaActual+ @NomArch
END
END
ELSE
BEGIN
IF @TipoDocumento ='PDF'
UPDATE AnexoMov WITH (ROWLOCK) SET  Nombre=@NomArch,Direccion=@RutaActual+@NomArch WHERE ID=@ID AND Icono=745 AND CFD=1 AND Rama  =@Modulo AND Sucursal =@Sucursal
IF @TipoDocumento ='XML'
UPDATE AnexoMov WITH (ROWLOCK) SET  Nombre=@NomArch,Direccion=@RutaActual+@NomArch WHERE ID=@ID AND Icono=17 AND CFD=1 AND Rama  =@Modulo AND Sucursal =@Sucursal
IF ISNULL(@TipoDocumento ,'')=''
SELECT @Ruta  =  @RutaActual
ELSE
SELECT @Ruta  =  @RutaActual  + @NomArch
END
END
ELSE
SELECT @Ruta  =  @RutaActual
RETURN

