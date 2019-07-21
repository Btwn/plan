SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexGenerarPDFS
@Estacion			int,
@EmpresaEstacion	varchar(5),
@Usuario			varchar(10)

AS BEGIN
DECLARE
@RutaTemporal	varchar(255),
@Modulo			varchar(5),
@ModuloID		int,
@Empresa		varchar(5),
@Mov			varchar(20),
@MovID			varchar(20),
@Archivo		varchar(255),
@IDIS			int,
@Contacto		varchar(10),
@AlmacenarTipo	varchar(20),
@Ok				int,
@OkRef			varchar(255)
SELECT @RutaTemporal = RutaTemporal FROM EmpresaCFD WHERE Empresa = @EmpresaEstacion
DECLARE crListaModuloID CURSOR FOR
SELECT Modulo, ID
FROM ListaModuloID
WHERE Estacion = @Estacion
OPEN crListaModuloID
FETCH NEXT FROM crListaModuloID INTO @Modulo, @ModuloID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Modulo = 'VTAS' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Contacto = Cliente FROM Venta WHERE ID = @ModuloID ELSE
IF @Modulo = 'CXC'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Contacto = Cliente FROM CXC   WHERE ID = @ModuloID
IF @Ok IS NULL
BEGIN
SELECT @AlmacenarTipo = NULL
SELECT @AlmacenarTipo = NULLIF(AlmacenarTipo,'') FROM CteCFD WHERE Cliente = @Contacto
EXEC spCFDFlexGenerarPDF @Empresa, @Modulo, @Mov, @ModuloID, @Usuario, 0, @IDIS OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,1
IF @AlmacenarTipo = 'Adicional'
EXEC spCFDFlexGenerarPDF @Empresa, @Modulo, @Mov, @ModuloID, @Usuario, 1, @IDIS OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,1
END
IF @Ok IS NULL
BEGIN
UPDATE CFD SET GenerarPDF = 1 WHERE Modulo = @Modulo AND ModuloID = @ModuloID
IF @@ERROR <> 0 SET @Ok = 1
END
FETCH NEXT FROM crListaModuloID INTO @Modulo, @ModuloID
END
CLOSE crListaModuloID
DEALLOCATE crListaModuloID
DELETE FROM ListaModuloID WHERE Estacion = @Estacion
END

