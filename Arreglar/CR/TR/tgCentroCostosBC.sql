SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCentroCostosBC ON CentroCostos

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CentroCostosN  	varchar(20),
@CentroCostosA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CentroCostosN = CentroCostos FROM Inserted
SELECT @CentroCostosA = CentroCostos FROM Deleted
IF @CentroCostosN = @CentroCostosA RETURN
IF @CentroCostosN IS NULL
BEGIN
DELETE CentroCostosEmpresa  WHERE CentroCostos = @CentroCostosA
DELETE CentroCostosSucursal WHERE CentroCostos = @CentroCostosA
DELETE CentroCostosUsuario  WHERE CentroCostos = @CentroCostosA
END ELSE
IF @CentroCostosA IS NOT NULL
BEGIN
UPDATE CentroCostosEmpresa  SET CentroCostos = @CentroCostosN WHERE CentroCostos = @CentroCostosA
UPDATE CentroCostosSucursal SET CentroCostos = @CentroCostosN WHERE CentroCostos = @CentroCostosA
UPDATE CentroCostosUsuario  SET CentroCostos = @CentroCostosN WHERE CentroCostos = @CentroCostosA
END
END

