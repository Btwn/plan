SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEspacioAB ON Espacio

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Espacio		char(10),
@Empresa		char(5),
@NumeroEconomico 	varchar(20),
@Mensaje		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Espacio = NULLIF(RTRIM(Espacio), ''), @Empresa = NULLIF(RTRIM(Empresa), ''), @NumeroEconomico = NULLIF(RTRIM(NumeroEconomico), '') FROM Inserted
IF @Espacio IS NOT NULL AND @Empresa IS NOT NULL AND @NumeroEconomico IS NOT NULL
BEGIN
IF EXISTS (SELECT * FROM Espacio WHERE Empresa = @Empresa AND Espacio <> @Espacio AND NumeroEconomico = @NumeroEconomico)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@NumeroEconomico))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 27010
RAISERROR (@Mensaje,16,-1)
END
END
END

