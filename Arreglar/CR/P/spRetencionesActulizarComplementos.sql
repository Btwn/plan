SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRetencionesActulizarComplementos
@Modulo     varchar(5),
@ID         int,
@Bandera    int

AS
BEGIN
DECLARE @Concepto           varchar(50),
@CFDIRetClave       varchar(2),
@RetmontoTotGrav    money,
@RetmontoTotExent   money,
@montoTotOperacion  money,
@RetencionISR       money,
@RetencionIVA       money,
@montoTotGrav       float,
@montoTotExent      float,
@Version            varchar(5),
@importe            money,
@Clave              varchar(2)
IF @Bandera = 1
BEGIN
IF @Modulo = 'GAS'
BEGIN
SELECT @montoTotOperacion = ISNULL(SUM(GD.Importe),0.00),
@RetencionISR      = ISNULL(SUM(GD.Retencion),0.00),
@RetencionIVA      = ISNULL(SUM(GD.Retencion2),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
WHERE G.ID = @ID
GROUP BY GD.Concepto
IF (SELECT COUNT(Concepto) FROM GastoD WHERE ID = @ID GROUP BY Concepto) > 1
RETURN
SELECT @Concepto = Concepto FROM GastoD WHERE ID = @ID GROUP BY Concepto
SELECT @CFDIRetClave = CFDIRetClave FROM CFDIRetencionConcepto WHERE Concepto = @Concepto
SELECT @RetmontoTotGrav = ISNULL(RetmontoTotGrav,0.00),
@RetmontoTotExent = ISNULL(RetmontoTotExent,0.00)
FROM CFDIRetSATRetencion
WHERE CLAVE = @CFDIRetClave
SELECT @montoTotGrav = (@montoTotOperacion*@RetmontoTotGrav)/100
SELECT @montoTotExent = (@montoTotOperacion*@RetmontoTotExent)/100
SELECT @Version = Version FROM CFDIRetencionCompXMLPlantilla WHERE Complemento = 'Intereses'
IF NOT EXISTS (SELECT * FROM CFDIRetSATIntereses WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
INSERT CFDIRetSATIntereses (ID, Version, SistFinanciero, RetiroAORESRetInt, OperFinancDerivad, MontIntNominal,     MontIntReal,                                    Perdida, Gravado,       Exento)
SELECT @ID, @Version, 'SI',          'SI',              'SI',              @montoTotOperacion, @montoTotOperacion-@RetencionISR-@RetencionIVA, 0.00,    @montoTotGrav, @montoTotExent
IF EXISTS (SELECT * FROM CFDIRetSATIntereses WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
UPDATE CFDIRetSATIntereses
SET MontIntNominal = @montoTotOperacion,
MontIntReal    = @montoTotOperacion-@RetencionISR-@RetencionIVA,
Gravado        = @montoTotGrav,
Exento         = @montoTotExent
WHERE ID = @ID
END
END
IF @Bandera = 2
BEGIN
IF @Modulo = 'GAS'
BEGIN
SELECT @montoTotOperacion = ISNULL(SUM(GD.Importe),0.00),
@RetencionISR      = ISNULL(SUM(GD.Retencion),0.00),
@RetencionIVA      = ISNULL(SUM(GD.Retencion2),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
WHERE G.ID = @ID
GROUP BY GD.Concepto
IF (SELECT COUNT(Concepto) FROM GastoD WHERE ID = @ID GROUP BY Concepto) > 1
RETURN
SELECT @Concepto = Concepto FROM GastoD WHERE ID = @ID GROUP BY Concepto
SELECT @CFDIRetClave = CFDIRetClave FROM CFDIRetencionConcepto WHERE Concepto = @Concepto
SELECT @RetmontoTotGrav = ISNULL(RetmontoTotGrav,0.00),
@RetmontoTotExent = ISNULL(RetmontoTotExent,0.00)
FROM CFDIRetSATRetencion
WHERE CLAVE = @CFDIRetClave
SELECT @montoTotGrav = (@montoTotOperacion*@RetmontoTotGrav)/100
SELECT @montoTotExent = (@montoTotOperacion*@RetmontoTotExent)/100
SELECT @Version = Version FROM CFDIRetencionCompXMLPlantilla WHERE Complemento = 'EnajenacionAcciones'
IF NOT EXISTS (SELECT * FROM CFDIEnajenacionGastoComplemento WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
INSERT CFDIEnajenacionGastoComplemento (ID, Clave,         VersionXSD, Descripcion, Ganancia, Perdida, Gravado,       Exento)
SELECT @ID, @CFDIRetClave, @Version,   '',          0.00,      0.00,   @montoTotGrav, @montoTotExent
IF EXISTS (SELECT * FROM CFDIEnajenacionGastoComplemento WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
UPDATE CFDIEnajenacionGastoComplemento
SET Gravado        = @montoTotGrav,
Exento         = @montoTotExent
WHERE ID = @ID
END
END
IF @Bandera = 3
BEGIN
IF @Modulo = 'GAS'
BEGIN
SELECT @montoTotOperacion = ISNULL(SUM(GD.Importe),0.00),
@RetencionISR      = ISNULL(SUM(GD.Retencion),0.00),
@RetencionIVA      = ISNULL(SUM(GD.Retencion2),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
WHERE G.ID = @ID
GROUP BY GD.Concepto
IF (SELECT COUNT(Concepto) FROM GastoD WHERE ID = @ID GROUP BY Concepto) > 1
RETURN
SELECT @Concepto = Concepto FROM GastoD WHERE ID = @ID GROUP BY Concepto
SELECT @CFDIRetClave = CFDIRetClave FROM CFDIRetencionConcepto WHERE Concepto = @Concepto
SELECT @RetmontoTotGrav = ISNULL(RetmontoTotGrav,0.00),
@RetmontoTotExent = ISNULL(RetmontoTotExent,0.00)
FROM CFDIRetSATRetencion
WHERE CLAVE = @CFDIRetClave
SELECT @montoTotGrav = (@montoTotOperacion*@RetmontoTotGrav)/100
SELECT @montoTotExent = (@montoTotOperacion*@RetmontoTotExent)/100
SELECT @Version = Version FROM CFDIRetencionCompXMLPlantilla WHERE Complemento = 'Dividendos'
SELECT @Clave = Clave FROM CFDIRetSATDividendo ORDER BY Clave DESC
IF NOT EXISTS (SELECT * FROM CFDIRetGastoComplemento WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
INSERT CFDIRetGastoComplemento (ID, CveTipDivOUtil, TipoSocDistrDiv, ProporcionRem, Gravado,       Exento)
SELECT @ID, @Clave, 'Sociedad Nacional',  0.00,     @montoTotGrav, @montoTotExent
IF EXISTS (SELECT * FROM CFDIRetGastoComplemento WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
UPDATE CFDIRetGastoComplemento
SET Gravado        = @montoTotGrav,
Exento         = @montoTotExent
WHERE ID = @ID
END
END
IF @Bandera = 4
BEGIN
IF @Modulo = 'GAS'
BEGIN
SELECT @montoTotOperacion = ISNULL(SUM(GD.Importe),0.00),
@RetencionISR      = ISNULL(SUM(GD.Retencion),0.00),
@RetencionIVA      = ISNULL(SUM(GD.Retencion2),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
WHERE G.ID = @ID
GROUP BY GD.Concepto
IF (SELECT COUNT(Concepto) FROM GastoD WHERE ID = @ID GROUP BY Concepto) > 1
RETURN
SELECT @Concepto = Concepto FROM GastoD WHERE ID = @ID GROUP BY Concepto
SELECT @CFDIRetClave = CFDIRetClave FROM CFDIRetencionConcepto WHERE Concepto = @Concepto
SELECT @RetmontoTotGrav = ISNULL(RetmontoTotGrav,0.00),
@RetmontoTotExent = ISNULL(RetmontoTotExent,0.00)
FROM CFDIRetSATRetencion
WHERE CLAVE = @CFDIRetClave
SELECT @montoTotGrav = (@montoTotOperacion*@RetmontoTotGrav)/100
SELECT @montoTotExent = (@montoTotOperacion*@RetmontoTotExent)/100
SELECT @Version = Version FROM CFDIRetencionCompXMLPlantilla WHERE Complemento = 'Dividendos'
SELECT @Clave = Clave FROM CFDIRetSATDividendo ORDER BY Clave DESC
IF NOT EXISTS (SELECT * FROM CFDIRetGastoComplemento WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
INSERT CFDIRetGastoComplemento (ID, CveTipDivOUtil, TipoSocDistrDiv, ProporcionRem, Gravado,       Exento,         MontISRAcredRetMexico, MontISRAcredRetExtranjero, MontRetExtDivExt, MontISRAcredNal, MontDivAcumNal, MontDivAcumExt)
SELECT @ID, @Clave, 'Sociedad Nacional',  0.00,     @montoTotGrav, @montoTotExent, 0.00,                  0.00,                      0.00,             0.00,            0.00,           0.00
IF EXISTS (SELECT * FROM CFDIRetGastoComplemento WHERE ID = @ID) AND (SELECT Estatus FROM Gasto WHERE ID = @ID) NOT IN ('CONCLUIDO','CANCELADO')
UPDATE CFDIRetGastoComplemento
SET Gravado        = @montoTotGrav,
Exento         = @montoTotExent
WHERE ID = @ID
END
END
END

