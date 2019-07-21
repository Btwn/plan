SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4Incidencias
@Estacion      INT,
@Empresa       VARCHAR(5),
@TipoNominaG4  VARCHAR(50)

AS
BEGIN
DECLARE
@Personal VARCHAR(10),
@Valor    VARCHAR(100),
@Importe  MONEY,
@Cantidad MONEY,
@TipoDato VARCHAR(20),
@Clave    VARCHAR(100),
@Concepto VARCHAR(100),
@MovTipo  VARCHAR(20)
DECLARE crDatos CURSOR LOCAL FOR 
SELECT ni.Clave
FROM ListaSt ni
WHERE ni.Estacion = @Estacion
OPEN crDatos
FETCH NEXT FROM crDatos INTO @Personal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
DECLARE crDatos2 CURSOR LOCAL FOR 
SELECT nc.Clave, nc.Concepto, nc.TipoDato, mt.Clave
FROM NominaConceptoEx nc
LEFT join MovTipo mt ON mt.Mov = nc.Concepto AND mt.Modulo = 'NOM'
WHERE nc.Tipo = 'Incidencia' AND isnull(Concepto, '') <> ''
OPEN crDatos2
FETCH NEXT FROM crDatos2 INTO @Clave, @Concepto, @TipoDato, @MovTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Valor = ''
IF @TipoNominaG4 = 'Nomina Normal'
IF @MovTipo <> 'NOM.PD'
SELECT  @Importe = sum(nd.Importe), @Cantidad = sum(nd.Cantidad)
FROM Nomina n
LEFT JOIN NominaD nd ON n.ID = nd.ID
LEFT join MovTipo mt ON mt.Mov = n.Mov AND mt.Modulo = 'NOM'
WHERE n.Estatus IN ('PROCESAR', 'PORPROCESAR') AND n.Mov = @Concepto AND nd.Personal = @Personal
ELSE
SELECT  @Importe = SUM(nd.Monto), @Cantidad = SUM(nd.Cantidad)
FROM Nomina n
LEFT JOIN NominaD nd ON n.ID = nd.ID
LEFT join MovTipo mt ON mt.Mov = n.Mov AND mt.Modulo = 'NOM'
WHERE n.Estatus IN ('VIGENTE') AND n.Mov = @Concepto AND nd.Personal = @Personal
ELSE
IF @TipoNominaG4 IN('Nomina Finiquito', 'Nomina Liquidacion')
BEGIN
IF @MovTipo <> 'NOM.PD'
SELECT  @Importe = sum(nd.Importe), @Cantidad = sum(nd.Cantidad)
FROM Nomina n
LEFT JOIN NominaD nd ON n.ID = nd.ID
LEFT join MovTipo mt ON mt.Mov = n.Mov AND mt.Modulo = 'NOM'
WHERE n.Estatus IN ('PROCESAR', 'PORPROCESAR') AND n.Mov = @Concepto AND nd.Personal = @Personal
ELSE
SELECT  @Importe = sum(nd.Saldo), @Cantidad = sum(nd.Cantidad)
FROM Nomina n
LEFT JOIN NominaD nd ON n.ID = nd.ID
LEFT join MovTipo mt ON mt.Mov = n.Mov AND mt.Modulo = 'NOM'
WHERE n.Estatus IN ('VIGENTE') AND n.Mov = @Concepto AND nd.Personal = @Personal
END
IF @TipoDato = 'Importe'
SELECT @Valor = CONVERT( VARCHAR(100), @Importe )
ELSE
IF @TipoDato = 'Cantidad'
SELECT @Valor = CONVERT( VARCHAR(100), @Cantidad )
ELSE
SELECT @Valor = ''
IF LTRIM(@Valor) <> ''
BEGIN
INSERT NominaIncidenciaG4 (Estacion,  element1,  element2, value)
VALUES                    (@Estacion, @Personal, @Clave,   @Valor)
END
FETCH NEXT FROM crDatos2 INTO @Clave, @Concepto, @TipoDato, @MovTipo
END
END
CLOSE crDatos2
DEALLOCATE crDatos2  
FETCH NEXT FROM crDatos INTO @Personal
END
END
CLOSE crDatos
DEALLOCATE crDatos 
RETURN
END

