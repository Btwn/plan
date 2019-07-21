SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionActMonGravExce
@Empresa			varchar(5),
@Proveedor			varchar(10),
@Estacion			int,
@ConceptoSAT		varchar(2)

AS
BEGIN
DECLARE @RID                int,
@Modulo             varchar(5),
@ID                 int,
@montoTotOperacion  money,
@montoTotGrav       float,
@montoTotExent      float,
@Concepto           varchar(50),
@ConceptoS          varchar(50),
@ConceptoClave      varchar(50),
@CFDIRetClave       varchar(2),
@RetmontoTotGrav    money,
@RetmontoTotExent   money
DECLARE CrCFDIRetencionCalc CURSOR FOR
SELECT RID
FROM CFDIRetencionCalc
WHERE Empresa         = @Empresa
AND Proveedor       = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT     = @ConceptoSAT
OPEN CrCFDIRetencionCalc
FETCH NEXT FROM CrCFDIRetencionCalc INTO @RID
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Modulo         = Modulo,
@ID             = ModuloId,
@ConceptoS    = ConceptoClave
FROM CFDIRetencionD
WHERE RID     = @RID
AND Empresa = @Empresa
IF @Modulo = 'GAS'
BEGIN
SELECT @montoTotOperacion = ISNULL(SUM(GD.Importe),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
JOIN CFDIRetencionD CR ON GD.ID = CR.ModuloID
WHERE G.ID = @ID
and GD.Concepto IN (@ConceptoS)
GROUP BY CR.ConceptoSAT
SELECT @Concepto = Concepto FROM GastoD WHERE ID = @ID GROUP BY Concepto
SELECT @CFDIRetClave = CFDIRetClave FROM CFDIRetencionConcepto WHERE Concepto = @Concepto AND Modulo = @Modulo
SELECT @RetmontoTotGrav = ISNULL(RetmontoTotGrav,0.00),
@RetmontoTotExent = ISNULL(RetmontoTotExent,0.00)
FROM CFDIRetSATRetencion
WHERE CLAVE = @CFDIRetClave
SELECT @montoTotGrav = (@montoTotOperacion*@RetmontoTotGrav)/100
SELECT @montoTotExent = (@montoTotOperacion*@RetmontoTotExent)/100
UPDATE CFDIRetencionD
SET montoTotGrav  = @montoTotGrav,
montoTotExent = @montoTotExent
WHERE RID     = @RID
AND Empresa = @Empresa
END
FETCH NEXT FROM CrCFDIRetencionCalc INTO @RID
END
CLOSE CrCFDIRetencionCalc
DEALLOCATE CrCFDIRetencionCalc
END

