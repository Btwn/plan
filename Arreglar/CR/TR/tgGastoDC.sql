SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgGastoDC ON GastoD

FOR UPDATE
AS BEGIN
DECLARE
@Estatus	varchar(15),
@ID		int,
@Renglon	float,
@RenglonSub	int
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ID = ID, @Renglon = Renglon, @RenglonSub = RenglonSub FROM Inserted
SELECT @Estatus = Estatus FROM Gasto WHERE ID = @ID
IF @Estatus = 'CONCLUIDO'
EXEC spMovDReg 'GAS', @ID, @Renglon, @RenglonSub, @UnicamenteActualizar = 1
END

