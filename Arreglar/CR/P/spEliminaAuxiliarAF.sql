SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spEliminaAuxiliarAF
@Empresa     varchar(5),
@Modulo      varchar(20),
@ID          int,
@ArticuloID  int,
@Bandera     bit

AS
BEGIN
DECLARE @Estatus varchar(15)
IF @Modulo = 'GAS'
BEGIN
SELECT @Estatus =  Estatus FROM Gasto WHERE ID = @ID
IF (@Estatus = 'CONCLUIDO' OR @Estatus = 'CANCELADO')
RETURN
END
IF @Modulo = 'COMS'
BEGIN
SELECT @Estatus =  Estatus FROM Compra WHERE ID = @ID
IF (@Estatus = 'CONCLUIDO' OR @Estatus = 'CANCELADO')
RETURN
END
IF @Bandera = 0
DELETE AuxiliarActivoFijo
WHERE Modulo = @Modulo AND IDMov = @ID AND Empresa = @Empresa AND ID = @ArticuloID
IF @Bandera = 1
DELETE AuxiliarActivoFijo
WHERE Modulo = @Modulo AND IDMov = @ID AND Empresa = @Empresa
END

