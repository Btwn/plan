SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarAlmPosTemp
@Estacion       int,
@Empresa	varchar(5),
@Usuario	varchar(10),
@Almacen	varchar(10)

AS BEGIN
DELETE PlugInAlmacenTemp WHERE Estacion = @Estacion
INSERT PlugInAlmacenTemp(Estacion , Empresa,  Usuario,  Almacen)
SELECT                   @Estacion, @Empresa, @Usuario, @Almacen
RETURN
END

