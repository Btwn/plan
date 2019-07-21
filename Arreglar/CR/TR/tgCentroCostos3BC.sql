SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCentroCostos3BC ON CentroCostos3

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CentroCostos3N  	varchar(20),
@CentroCostos3A	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CentroCostos3N = CentroCostos3 FROM Inserted
SELECT @CentroCostos3A = CentroCostos3 FROM Deleted
IF @CentroCostos3N = @CentroCostos3A RETURN
IF @CentroCostos3N IS NULL
BEGIN
DELETE CentroCostos3Empresa  WHERE CentroCostos3 = @CentroCostos3A
DELETE CentroCostos3Sucursal WHERE CentroCostos3 = @CentroCostos3A
DELETE CentroCostos3Usuario  WHERE CentroCostos3 = @CentroCostos3A
END ELSE
IF @CentroCostos3A IS NOT NULL
BEGIN
UPDATE CentroCostos3Empresa  SET CentroCostos3 = @CentroCostos3N WHERE CentroCostos3 = @CentroCostos3A
UPDATE CentroCostos3Sucursal SET CentroCostos3 = @CentroCostos3N WHERE CentroCostos3 = @CentroCostos3A
UPDATE CentroCostos3Usuario  SET CentroCostos3 = @CentroCostos3N WHERE CentroCostos3 = @CentroCostos3A
END
END

