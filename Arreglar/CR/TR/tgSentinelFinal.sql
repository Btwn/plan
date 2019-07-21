SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSentinelFinal ON Sentinel

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Cliente	char(10),
@Usuarios	int
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Cliente = Cliente FROM Inserted
SELECT @Usuarios = ISNULL(SUM(Usuarios), 0) FROM Sentinel WHERE Cliente = @Cliente
IF @Usuarios > (SELECT ISNULL(Licencias, 0) FROM Cte WHERE Cliente = @Cliente)
BEGIN
RAISERROR ('No se Puede Exceder a las Licencias',16,-1)
RETURN
END
IF UPDATE(Serie) OR UPDATE(Cliente) OR UPDATE(Nombre) OR UPDATE(Usuarios) OR UPDATE(Fabricacion) OR UPDATE(Vencimiento)
INSERT SentinelHist (Fecha, Serie, Cliente, Nombre, Usuarios, Fabricacion, Vencimiento, Mantenimiento)
SELECT GETDATE(), Serie, Cliente, Nombre, Usuarios, Fabricacion, Vencimiento, Mantenimiento
FROM Inserted
END

