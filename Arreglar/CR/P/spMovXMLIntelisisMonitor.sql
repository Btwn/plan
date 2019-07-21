SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovXMLIntelisisMonitor
@Estacion int

AS BEGIN
DECLARE
@Modulo					varchar(5),
@ModuloID			    int,
@Mov					varchar(15),
@Empresa				varchar(15),
@Ruta	                varchar(255)
SELECT Modulo, ID
FROM ListaModuloID
WHERE Estacion = @Estacion
DECLARE crListaModuloID CURSOR FOR
SELECT Modulo, ID
FROM ListaModuloID
WHERE Estacion = @Estacion
OPEN crListaModuloID
FETCH NEXT FROM crListaModuloID INTO @Modulo, @ModuloID
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Modulo = 'VTAS'
SELECT @Empresa = Empresa, @Mov = RTRIM(Mov) FROM Venta WHERE ID= @ModuloID
IF @Modulo = 'CXC'
SELECT @Empresa = Empresa, @Mov = RTRIM(Mov) FROM Cxc WHERE ID= @ModuloID
IF (Select Cancelado From  CFDFlex Where Modulo = @Modulo And ModuloID = @ModuloID) = 0
Begin
EXEC spCFDRutaArchivosMonitor  @Empresa, @Modulo, @Mov, @ModuloID,'XML', @Ruta OUTPUT
EXEC spCFDIRegenerarXml @Empresa, @Mov, @ModuloID, @Modulo, @Ruta,0
End
FETCH NEXT FROM crListaModuloID INTO @Modulo, @ModuloID
END
CLOSE crListaModuloID
DEALLOCATE crListaModuloID
DELETE FROM ListaModuloID WHERE Estacion = @Estacion
RETURN
END

