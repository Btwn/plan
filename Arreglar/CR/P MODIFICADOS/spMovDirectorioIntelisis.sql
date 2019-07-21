SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovDirectorioIntelisis
@Empresa     varchar(5),
@Modulo	varchar(5),
@Mov		varchar(20),
@ID		int = NULL

AS BEGIN
DECLARE
@Agente			char(10),
@MovID			varchar(20),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@ArchivoXML		varchar(255),
@ArchivoPDF		varchar(255),
@Nombre			varchar(100),
@eMail			varchar(100),
@Serie			varchar(20),
@Folio			varchar(20),
@AlmacenarTipo  varchar(20),
@EnviarTipo		varchar(20),
@Sucursal       int,
@Cliente        varchar(10),
@Ruta			varchar(255),
@NomArch        varchar(255)
SET @Ruta = ''
IF @Modulo = 'VTAS' SELECT @Sucursal = Sucursal, @Cliente = RTRIM(Cliente), @Agente = RTRIM(Agente), @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Folio = MovID FROM Venta WITH(NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXC'  SELECT @Sucursal = Sucursal, @Cliente = RTRIM(Cliente), @Agente = RTRIM(Agente), @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Folio = MovID FROM CXC WITH(NOLOCK) WHERE ID = @ID
SELECT @Ruta = AlmacenarRuta, @Nombre = Nombre
FROM EmpresaCFD WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Nombre = REPLACE(@Nombre,' ','')
SELECT @NomArch = @Nombre
SELECT @NomArch = REPLACE(@NomArch, '<Movimiento>', LTRIM(RTRIM(ISNULL(@Mov,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Serie>', LTRIM(RTRIM(ISNULL(@Serie,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Folio>', LTRIM(RTRIM(CONVERT(varchar, LTRIM(RTRIM(ISNULL(@Folio,'')))))))
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
IF ISNULL(@Ruta,'') <> ''
SET @Ruta = @Ruta +'\'
SELECT 'DirectorioIntelisis' = @Ruta
RETURN
END

