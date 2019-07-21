SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebPaginaParamBC ON WebPaginaParam

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@PaginaA	varchar(20),
@PaginaN	varchar(20),
@ParametroA	varchar(50),
@ParametroN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @PaginaA = Pagina, @ParametroA = Parametro FROM Deleted
SELECT @PaginaN = Pagina, @ParametroN = Parametro FROM Inserted
IF @ParametroA = @ParametroN RETURN
IF @PaginaN IS NULL
BEGIN
DELETE WebPaginaParamLista WHERE Pagina = @PaginaA AND Parametro = @ParametroA
END ELSE
BEGIN
UPDATE WebPaginaParamLista SET Parametro = @ParametroN WHERE Pagina = @PaginaA AND Parametro = @ParametroA
END
END

