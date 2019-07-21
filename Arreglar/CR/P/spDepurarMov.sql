SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDepurarMov
@Modulo	char(5),
@Tabla	varchar(50)

AS BEGIN
if exists (select * from sysobjects where id = object_id('dbo.'+@Tabla) and type = 'U')
EXEC("
ALTER TABLE "+@Tabla+" DISABLE TRIGGER ALL
DELETE "+@Tabla+" FROM "+@Tabla+" m, DepurarMov t WHERE t.Modulo = '"+@Modulo+"' AND t.ID = m.ID
ALTER TABLE "+@Tabla+" ENABLE TRIGGER ALL
")
END

