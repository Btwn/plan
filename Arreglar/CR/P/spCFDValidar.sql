SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDValidar
@Modulo		char(5),
@ID		int,
@Usuario	varchar(10),
@Adicional	bit

AS BEGIN
DECLARE
@Empresa		char(5),
@Cliente		char(10),
@Schema			varchar(255),
@Fecha			datetime
SELECT @Schema = NULL
IF @Modulo = 'VTAS' SELECT @Empresa = Empresa, @Cliente = Cliente FROM Venta WHERE ID = @ID
IF @Modulo = 'CXC'  SELECT @Empresa = Empresa, @Cliente = Cliente FROM CXC WHERE ID = @ID
SELECT @Fecha = Fecha FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
IF @Fecha IS NULL SELECT @Fecha = GETDATE()
IF @Adicional = 0
BEGIN
SELECT @Schema = ValidarSchema FROM CteCFD WHERE Cliente = @Cliente AND Validar = 1 AND ValidarTipo = 'ESPECIFICO'
IF @@ROWCOUNT = 0
SELECT @Schema = CASE WHEN VersionFecha < @Fecha OR VersionFecha IS NULL THEN ValidarSchema ELSE ValidarSchemaAnterior END FROM EmpresaCFD WHERE Empresa = @Empresa AND Validar = 1
END ELSE
SELECT @Schema = ValidarSchema FROM CteCFD WHERE Cliente = @Cliente AND Validar = 1 AND ValidarTipo = 'ADICIONAL'
EXEC xpCFDValidar @Modulo, @ID, @Usuario, @Adicional, @Schema OUTPUT
SELECT 'Schema' = @Schema
RETURN
END

