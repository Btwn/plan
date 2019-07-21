SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistCorridaActualizar (
@Empresa              varchar(5),
@Corrida              int
)

AS
BEGIN
DECLARE @ret            bit
DECLARE @UltimaCorrida  int
SET @ret = 0
BEGIN TRY
IF EXISTS(SELECT * FROM DistCorrida WHERE Empresa = @Empresa)
BEGIN
SELECT TOP 1 @UltimaCorrida = Corrida FROM DistCorrida WHERE Empresa = @Empresa
SET @UltimaCorrida = ISNULL(@UltimaCorrida,0)
IF @Corrida > @UltimaCorrida
BEGIN
UPDATE DistCorrida SET Corrida = @Corrida WHERE Empresa = @Empresa
END
END
ELSE
BEGIN
INSERT INTO DistCorrida (Empresa, Corrida) VALUES (@Empresa, @Corrida)
END
SET @ret = 1
END TRY
BEGIN CATCH
SET @ret = 0
END CATCH
SELECT @ret
END

