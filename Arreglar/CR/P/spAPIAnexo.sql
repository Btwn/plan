SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spAPIAnexo
@ID        int,
@Mov	   varchar(20),
@finalPath varchar(max)
AS BEGIN
DECLARE @Ok int, @OkRef varchar(max)
IF ISNULL(@Mov,'') = 'Toyota'
BEGIN
DECLARE
@Estatus    varchar(15),
@MovI       varchar(20),
@Sucursal   int,
@usuario	varchar(20),
@Empresa    varchar(15),
@NomArch    varchar(255),
@Ext	    varchar(20),
@icono		int,
@i			int,
@Tipo		varchar(10),
@FechaEmision datetime
SELECT	@Empresa = Empresa,
@FechaEmision = FechaEmision,
@Sucursal = Sucursal,
@Empresa = Empresa,
@MovI = Mov,
@Estatus = Estatus,
@usuario = usuario
FROM	Venta
WHERE	ID = @ID
select @NomArch = ''
select @i = charindex('\', @finalPath)
select @NomArch = @finalPath
while (@i > 0)
begin
select @NomArch = substring(@NomArch, @i+1, len(@NomArch))
select @i = charindex('\', @NomArch)
end
select @i = charindex('.', @NomArch)
select @Ext = @NomArch
while (@i > 0)
begin
select @Ext = substring(@Ext, @i+1, len(@Ext))
select @i = charindex('.', @Ext)
end
IF (LOWER(@Ext) IN  ('png', 'jpg', 'bmp', 'gif'))
SELECT @icono = 59, @Tipo = 'Imagen'
IF (LOWER(@Ext) IN  ('pdf'))
SELECT @icono = 745, @Tipo = 'Archivo'
IF (LOWER(@Ext) IN  ('doc', 'docx'))
SELECT @icono = 738, @Tipo = 'Archivo'
IF (LOWER(@Ext) IN  ('xls', 'xlsx'))
SELECT @icono = 733, @Tipo = 'Archivo'
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'VTAS' AND @Estatus = 'CANCELADO')
BEGIN
INSERT AnexoMov (Sucursal,  Rama,    ID,  Nombre,    Direccion,   Tipo,      Icono, Alta,          UltimoCambio, Usuario)
VALUES (@Sucursal, 'VTAS',  @ID, @NomArch, @finalPath,   @Tipo, @icono,   @FechaEmision, GETDATE(),   @Usuario)
END
END
SELECT @Ok Ok, @OkRef OkRef
RETURN
END

