SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSValidarPOSC
@Empresa   varchar(5)

AS
BEGIN
DECLARE
@Host  varchar(20)
SELECT TOP 1 @Host = Host FROM POSiSync
IF NOT EXISTS(SELECT Mov, Sucursal, Host FROM POSC WHERE Empresa = @Empresa AND Host = @Host  GROUP BY Mov, Sucursal, Host HAVING COUNT(*) > 1)
BEGIN
UPDATE POSCfg SET MovDuplicados = 0 WHERE Empresa = @Empresa
IF NOT EXISTS (SELECT * FROM sysindexes, sysobjects WHERE sysobjects.name = 'POSC' AND sysindexes.name = 'POSCMovSucursal' AND sysobjects.id = sysindexes.id)
CREATE  INDEX  POSCMovSucursal ON dbo.POSC (Mov, Sucursal, Host) ON [PRIMARY]
END
ELSE
BEGIN
UPDATE POSCfg SET MovDuplicados = 1 WHERE Empresa IN (SELECT Empresa FROM POSC GROUP BY Mov, Sucursal,Empresa HAVING COUNT(*) > 1)
END
END

