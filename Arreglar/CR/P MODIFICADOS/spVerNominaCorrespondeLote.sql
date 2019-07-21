SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerNominaCorrespondeLote
@Personal	char(10),
@Empresa	char(5),
@Fecha		datetime

AS BEGIN
DECLARE
@Suma				money,
@Condicion			varchar(50),
@Importe			money,
@Cantidad			money,
@Porcentaje			money,
@Monto				money,
@FechaD				datetime,
@FechaA				datetime,
@CantidadPendiente	money,
@PersonalTipoCambio	float,
@Saldo				money,
@Mov				varchar(20),
@Concepto			varchar(50),
@RedondeoMonetarios	int,
@ID					int,
@IDNomina			int,
@MovNomina			varchar(20),
@MovTipoNomina		varchar(20),
@MovTipo			varchar(20),
@Renglon	        float, 
@NomProcesarIncidencias	bit
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
CREATE TABLE #Corresponde (IDNomina Int, ID Int, Comando char(10) COLLATE Database_Default NULL, Mov varchar(20) COLLATE Database_Default NULL, Concepto varchar(50) COLLATE Database_Default NULL, Monto float NULL, Personal varchar(10) COLLATE Database_Default NULL, DRenglon float NULL)
SELECT @IDNomina = Numerico FROM SPIDTemp WITH(NOLOCK) WHERE SPID = @@SPID
SELECT @MovNomina = Mov FROM Nomina WITH(NOLOCK) WHERE ID = @IDNomina
SELECT @MovTipoNomina = Clave, @NomProcesarIncidencias = NomProcesarIncidencias FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'NOM' AND Mov = @MovNomina
SELECT @MovTipo = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'NOM' AND Mov = @Mov
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @PersonalTipoCambio = NULL
SELECT @PersonalTipoCambio = NULLIF(m.TipoCambio, 0.0)
FROM Personal p WITH(NOLOCK), Mon m WITH(NOLOCK)
WHERE p.Personal = @Personal AND p.Moneda = m.Moneda
INSERT #Corresponde (IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon) 
SELECT @IDNomina, n.ID, 'PRESTAMO', n.Mov, n.Concepto, d.Importe*m.TipoCambio, d.Personal, d.Renglon 
FROM Nomina n WITH(NOLOCK), NominaD d WITH(NOLOCK), MovTipo mt WITH(NOLOCK), Mon m WITH(NOLOCK)
WHERE n.ID = d.ID
AND n.Estatus IN ('PROCESAR', 'VIGENTE')
AND n.Empresa = @Empresa
AND n.FechaEmision <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @Fecha)
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND mt.Clave = 'NOM.PD'
AND d.Personal = @Personal
AND d.Activo = 1
AND d.Importe = d.Saldo
AND n.Moneda = m.Moneda
INSERT #Corresponde (IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon) 
SELECT @IDNomina, n.ID, 'PRESTAMOI', n.Mov, n.Concepto, d.Importe*m.TipoCambio, d.Personal, d.Renglon 
FROM Nomina n WITH(NOLOCK), NominaD d WITH(NOLOCK), MovTipo mt WITH(NOLOCK), Mon m WITH(NOLOCK)
WHERE n.ID = d.ID
AND n.Estatus IN ('PROCESAR', 'VIGENTE')
AND n.Empresa = @Empresa
AND n.FechaEmision <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @Fecha)
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND mt.Clave = 'NOM.PI'
AND d.Personal = @Personal
AND d.Activo = 1
AND d.Importe = d.Saldo
AND n.Moneda = m.Moneda
INSERT #Corresponde (IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon) 
SELECT @IDNomina, n.ID, 'CANTIDAD', n.Mov, n.Concepto, d.CantidadPendiente, d.Personal, d.Renglon 
FROM Nomina n WITH(NOLOCK), NominaD d WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE n.ID = d.ID
AND n.Estatus = 'PROCESAR'
AND n.Empresa = @Empresa
AND d.FechaD <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @Fecha)
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND mt.Clave IN ('NOM.C', 'NOM.CH', 'NOM.CD', 'NOM.CDH', 'NOM.VT')
AND d.Personal = @Personal
AND d.Activo = 1
AND d.CantidadPendiente <> 0
DECLARE crNomSaldo CURSOR FOR
SELECT n.ID, d.Renglon, n.Mov, n.Concepto, NULLIF(RTRIM(UPPER(n.Condicion)), ''), ISNULL(d.Importe*m.TipoCambio, 0.0), ISNULL(d.Cantidad, 0.0), ISNULL(d.Porcentaje, 0.0), ISNULL(d.Monto*m.TipoCambio, 0.0), d.FechaD, d.FechaA, ISNULL(d.CantidadPendiente, 0.0), ISNULL(d.Saldo*m.TipoCambio, 0.0) 
FROM Nomina n WITH(NOLOCK), NominaD d WITH(NOLOCK), MovTipo mt WITH(NOLOCK), Mon m WITH(NOLOCK)
WHERE n.ID = d.ID
AND n.Estatus IN ('PROCESAR', 'VIGENTE')
AND n.Empresa = @Empresa
AND d.FechaD <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @Fecha)
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND mt.Clave IN ('NOM.P', 'NOM.D', 'NOM.PD', 'NOM.PI')
AND d.Personal = @Personal
AND d.Activo = 1
AND n.Moneda = m.Moneda
OPEN crNomSaldo
FETCH NEXT FROM crNomSaldo INTO @ID, @Renglon, @Mov, @Concepto, @Condicion, @Importe, @Cantidad, @Porcentaje, @Monto, @FechaD, @FechaA, @CantidadPendiente, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Suma = 0.0
IF @Condicion IS NULL OR @Condicion = 'UNA VEZ' SELECT @Suma = @Suma + @Saldo ELSE
IF @Condicion = 'REPETIR SIEMPRE' SELECT @Suma = @Suma + @Importe ELSE
IF @Condicion = 'REPETIR' AND @CantidadPendiente > 0 SELECT @Suma = @Suma + @Importe ELSE
IF @Condicion = 'REPETIR FECHAS' AND @Fecha BETWEEN @FechaD AND @FechaA SELECT @Suma = @Suma + @Importe ELSE
IF @Condicion IN ('PRORRATEAR', 'PRORRATEAR %', 'PRORRATEAR $', 'CON ENGANCHE')
BEGIN
IF @Condicion = 'CON ENGANCHE' AND @Saldo = @Importe SELECT @Monto = @Cantidad ELSE
IF @Condicion = 'PRORRATEAR' AND @CantidadPendiente > 0 SELECT @Monto = ROUND(@Importe / @Cantidad, @RedondeoMonetarios) ELSE
IF @Condicion = 'PRORRATEAR %' SELECT @Monto = ROUND(@Importe * (@Porcentaje / 100), @RedondeoMonetarios)
IF @MovTipoNomina = 'NOM.NE' AND @MovTipo IN ('NOM.PD', 'NOM.PI') SELECT @Monto = @Saldo
IF ROUND(@Saldo - @Monto, 0) <= 0 SELECT @Monto = @Monto + (@Saldo - @Monto) - ROUND(@Saldo - @Monto, 0)
IF @Monto > @Saldo SELECT @Suma = @Suma + @Saldo ELSE SELECT @Suma = @Suma + @Monto
END
INSERT #Corresponde (IDNomina, ID, Comando, Mov,  Concepto,  Monto, Personal, DRenglon)   
VALUES (@IDNomina, @ID, 'SALDO', @Mov, @Concepto, ROUND(@Suma/ISNULL(@PersonalTipoCambio, 1.0), @RedondeoMonetarios), @Personal, @Renglon) 
END
FETCH NEXT FROM crNomSaldo INTO @ID, @Renglon, @Mov, @Concepto, @Condicion, @Importe, @Cantidad, @Porcentaje, @Monto, @FechaD, @FechaA, @CantidadPendiente, @Saldo 
END
CLOSE crNomSaldo
DEALLOCATE crNomSaldo
IF ISNULL(@NomProcesarIncidencias,0) = 0
INSERT INTO NominaCorrespondeLote (IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon) SELECT IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon FROM #Corresponde WHERE Mov IN (SELECT Incidencia FROM MovTipoIncidencias WITH(NOLOCK) WHERE Mov = @MovNomina)
ELSE
INSERT INTO NominaCorrespondeLote (IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon) SELECT IDNomina, ID, Comando, Mov, Concepto, Monto, Personal, DRenglon FROM #Corresponde
SELECT Comando, Mov, Concepto, "Monto" = SUM(Monto), IDNomina
FROM #Corresponde
GROUP BY Comando, Mov, Concepto, IDNomina
ORDER BY Comando, Mov, Concepto
RETURN
END

