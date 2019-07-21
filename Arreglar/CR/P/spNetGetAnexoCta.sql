SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetGetAnexoCta
@Rama    varchar(10) = NULL,
@Cuenta  varchar(20) = NULL
AS BEGIN
DECLARE @Anexos TABLE(
ID		  int,
AnexoBase64 nvarchar(16),
Ext		  varchar(10),
Rama		  varchar(5),
Cuenta	  varchar(20),
Nombre	  varchar(255),
Direccion	  varchar(255),
Tipo		  varchar(10),
Documento	  varchar(50))
INSERT INTO @Anexos
SELECT	SUBSTRING(CAST(Comentario AS VARCHAR(255)), 0, CHARINDEX(',', CAST(Comentario AS VARCHAR(255)))) ID,
SUBSTRING(CAST(Comentario AS VARCHAR(255)), CHARINDEX(',', CAST(Comentario AS VARCHAR(255)))+1, LEN(CAST(Comentario AS VARCHAR(255)))) AnexoBase64,
LOWER(REVERSE(SUBSTRING(REVERSE(Direccion),0,CHARINDEX('.',REVERSE(Direccion))))) Ext,
Rama,
Cuenta,
Nombre,
Direccion,
Tipo,
Documento
FROM	AnexoCta
WHERE	Rama = @Rama
AND Cuenta = @Cuenta
SELECT ac.*, b.Archivo
FROM @Anexos ac
JOIN AnexoBase64 b ON ac.ID = b.ID AND ac.AnexoBase64 = b.AnexoBase64
RETURN
END

