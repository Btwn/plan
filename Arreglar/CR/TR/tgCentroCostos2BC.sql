SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCentroCostos2BC ON CentroCostos2

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CentroCostos2N  	varchar(20),
@CentroCostos2A	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CentroCostos2N = CentroCostos2 FROM Inserted
SELECT @CentroCostos2A = CentroCostos2 FROM Deleted
IF @CentroCostos2N = @CentroCostos2A RETURN
IF @CentroCostos2N IS NULL
BEGIN
DELETE CentroCostos2Empresa  WHERE CentroCostos2 = @CentroCostos2A
DELETE CentroCostos2Sucursal WHERE CentroCostos2 = @CentroCostos2A
DELETE CentroCostos2Usuario  WHERE CentroCostos2 = @CentroCostos2A
END ELSE
IF @CentroCostos2A IS NOT NULL
BEGIN
UPDATE CentroCostos2Empresa  SET CentroCostos2 = @CentroCostos2N WHERE CentroCostos2 = @CentroCostos2A
UPDATE CentroCostos2Sucursal SET CentroCostos2 = @CentroCostos2N WHERE CentroCostos2 = @CentroCostos2A
UPDATE CentroCostos2Usuario  SET CentroCostos2 = @CentroCostos2N WHERE CentroCostos2 = @CentroCostos2A
END
END

