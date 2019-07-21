SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebPaginaBC ON WebPagina

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@PaginaA	varchar(20),
@PaginaN	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @PaginaA = Pagina FROM Deleted
SELECT @PaginaN = Pagina FROM Inserted
IF @PaginaA = @PaginaN RETURN
IF @PaginaN IS NULL
BEGIN
DELETE WebPaginaParam      WHERE Pagina = @PaginaA
DELETE WebPaginaParamGrupo WHERE Pagina = @PaginaA
DELETE WebPaginaParamLista WHERE Pagina = @PaginaA
DELETE WebPaginaAcceso     WHERE Pagina = @PaginaA
DELETE WebPaginaBlog       WHERE Pagina = @PaginaA
DELETE WebPaginaCalendario WHERE Pagina = @PaginaA
DELETE WebPaginaTarea      WHERE Pagina = @PaginaA
DELETE WebPaginaVista      WHERE Pagina = @PaginaA
DELETE WebPaginaCampo      WHERE Pagina = @PaginaA
DELETE WebPaginaDoc	       WHERE Pagina = @PaginaA
END ELSE
BEGIN
UPDATE WebPaginaParam      SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaParamGrupo SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaParamLista SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaAcceso     SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaBlog       SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaCalendario SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaTarea      SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaVista      SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaCampo      SET Pagina = @PaginaN WHERE Pagina = @PaginaA
UPDATE WebPaginaDoc        SET Pagina = @PaginaN WHERE Pagina = @PaginaA
END
END

