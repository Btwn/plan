SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraValidarPresupuesto
@Empresa		char(5),
@ID				int,
@FechaEmision	datetime,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Mes					int,
@Ano					int,
@Dias					int,
@CfgValidarPresupuesto	varchar(20),
@CfgCompraValidarPresupuestoMov	varchar(15), 
@CfgCompraValidarPresupuestoCC	bit,
@CfgCompraValidarPresupuestoCant	bit,
@CfgValidarFR			bit,
@ArtValidarPresupuesto	varchar(20),
@FechaRequerida			datetime,
@ValidarFecha			datetime,
@Articulo				char(20),
@Aplica					varchar(20),
@AplicaID				varchar(20),
@ContUso				char(50),
@Importe				money,
@ImporteInv				money,
@Cantidad				float,
@Presupuesto			money,
@PresupuestoInv			money,
@PresupuestoCantidad	float,
@Acumulado				money,
@AcumuladoInv			money,
@AcumuladoCantidad		float,
@Acumulado2				money,
@AcumuladoInv2			money,
@AcumuladoCantidad2		float,
@Devoluciones			money,
@DevolucionesInv		money,
@DevolucionesCantidad	float,
@Diferencia				money,
@DiferenciaInv			money,
@DiferenciaCantidad		float,
@FechaD					datetime,
@FechaA					datetime,
@MovTipo				varchar(20),
@FiltroOrigen			varchar(255),
@Directo				bit,
@SQL					varchar(8000)
SELECT @CfgValidarPresupuesto          = UPPER(ISNULL(CompraValidarPresupuesto, 'NO')),
@CfgValidarFR                   = ISNULL(CompraValidarPresupuestoFR, 0),
@CfgCompraValidarPresupuestoMov = UPPER(ISNULL(CompraValidarPresupuestoMov, 'ENTRADA COMPRA')),
@CfgCompraValidarPresupuestoCC	 = ISNULL(CompraValidarPresupuestoCC, 0),
@CfgCompraValidarPresupuestoCant = ISNULL(CompraValidarPresupuestoCant, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @CfgValidarPresupuesto = 'NO' RETURN
EXEC spMovInfo @ID, 'COMS', @MovTipo = @MovTipo OUTPUT
SELECT @Directo = Directo FROM Compra WHERE ID = @ID
IF @MovTipo = 'COMS.O' AND @CfgCompraValidarPresupuestoMov IN ('Requisicion') AND @Directo = 0
BEGIN
SELECT @FiltroOrigen = "AND (ISNULL(d.Aplica, '') = '' OR ISNULL(d.AplicaID, '') = '')"
END
ELSE
IF @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.CA', 'COMS.GX') AND @CfgCompraValidarPresupuestoMov IN ('REQUISICION', 'ORDEN COMPRA') AND @Directo = 0
SELECT @FiltroOrigen = "AND (ISNULL(d.Aplica, '') = '' OR ISNULL(d.AplicaID, '') = '')"
ELSE
SELECT @FiltroOrigen = " "
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @CfgCompraValidarPresupuestoCC = 1
SELECT @ContUso = "ISNULL(RTRIM(d.ContUso), '')"
ELSE
SELECT @ContUso = 'CONVERT(varchar(20), "'+'")'
CREATE TABLE #CompraMov(
Fecha						datetime	NULL,
Articulo					varchar(20)	COLLATE Database_Default NULL,
ContUso					varchar(20)	COLLATE Database_Default NULL,
ArtValidarPresupuesto		varchar(20)	COLLATE Database_Default NULL,
Importe					money		NULL,
ImporteInv				money		NULL,
Cantidad					float		NULL)
IF @CfgValidarFR = 1
SELECT @SQL = ' INSERT INTO #CompraMov(Fecha, Articulo, ContUso, ArtValidarPresupuesto, Importe, ImporteInv, Cantidad)
SELECT ISNULL(d.FechaRequerida, e.FechaEmision), d.Articulo, ' + RTRIM(@ContUso) + ', UPPER(a.ValidarPresupuestoCompra), SUM(d.SubTotal*e.TipoCambio), SUM(d.SubTotalInv*e.TipoCambio), SUM(d.Cantidad)
FROM CompraTCalc d, Compra e, Art a
WHERE d.ID = ' + RTRIM(@ID)  + ' AND d.ID = e.ID AND d.Articulo = a.Articulo
AND UPPER(a.ValidarPresupuestoCompra) <> "NO"
AND e.Empresa = "' + RTRIM(@Empresa) + '"
' + RTRIM(@FiltroOrigen) + '
GROUP BY ISNULL(d.FechaRequerida, e.FechaEmision), d.Articulo, ' + CASE RTRIM(@ContUso) WHEN 'CONVERT(varchar(20), "")' THEN ' ' ELSE RTRIM(@ContUso)+ ',' END + ' a.ValidarPresupuestoCompra'
ELSE
SELECT @SQL = ' INSERT INTO #CompraMov(Articulo, ContUso, ArtValidarPresupuesto, Importe, ImporteInv, Cantidad)
SELECT d.Articulo, ' + RTRIM(@ContUso) + ', UPPER(a.ValidarPresupuestoCompra), SUM(d.SubTotal*e.TipoCambio), SUM(d.SubTotalInv*e.TipoCambio), SUM(d.Cantidad)
FROM CompraTCalc d, Compra e, Art a
WHERE d.ID = ' + RTRIM(@ID)  + ' AND d.ID = e.ID AND d.Articulo = a.Articulo
AND UPPER(a.ValidarPresupuestoCompra) <> "NO"
AND e.Empresa = "' + RTRIM(@Empresa) + '"
' + RTRIM(@FiltroOrigen) + '
GROUP BY d.Articulo, ' + CASE RTRIM(@ContUso) WHEN 'CONVERT(varchar(20), "")' THEN ' ' ELSE RTRIM(@ContUso)+ ',' END + ' a.ValidarPresupuestoCompra'
EXEC(@SQL)
IF @CfgValidarFR = 0
UPDATE #CompraMov SET Fecha = @FechaEmision
DECLARE crCompra CURSOR FOR
SELECT Fecha, Articulo, ContUso, ArtValidarPresupuesto, cm.Importe, cm.ImporteInv, cm.Cantidad
FROM #CompraMov cm
OPEN crCompra
FETCH NEXT FROM crCompra INTO @ValidarFecha, @Articulo, @ContUso, @ArtValidarPresupuesto, @Importe, @ImporteInv, @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spExtraerFecha @ValidarFecha OUTPUT
SELECT @Mes = DATEPART(month, @ValidarFecha),
@Ano = DATEPART(year, @ValidarFecha)
EXEC spDiasMes @Mes, @Ano, @Dias OUTPUT
SELECT @Presupuesto = 0.0, @Acumulado = 0.0, @Devoluciones = 0.0, @Acumulado2 = 0.0,
@AcumuladoCantidad = 0.0, @AcumuladoCantidad2 = 0.0
IF @ArtValidarPresupuesto = 'MENSUAL'
BEGIN
EXEC spIntToDateTime 1,     @Mes, @Ano, @FechaD OUTPUT
EXEC spIntToDateTime @Dias, @Mes, @Ano, @FechaA OUTPUT
END ELSE
IF @ArtValidarPresupuesto = 'ACUMULADO'
BEGIN
EXEC spIntToDateTime 1,     1,    @Ano, @FechaD OUTPUT
EXEC spIntToDateTime @Dias, @Mes, @Ano, @FechaA OUTPUT
END ELSE
IF @ArtValidarPresupuesto = 'ANUAL'
BEGIN
EXEC spIntToDateTime 1,   1, @Ano, @FechaD OUTPUT
EXEC spIntToDateTime 31, 12, @Ano, @FechaA OUTPUT
END
IF @CfgValidarFR = 1
BEGIN
IF @CfgCompraValidarPresupuestoCC = 1
BEGIN
SELECT @Presupuesto = ISNULL(SUM(d.SubTotal*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoInv = ISNULL(SUM(d.SubTotalInv*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoCantidad = ISNULL(SUM(d.Cantidad*mt.Factor), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.PR')
AND ISNULL(d.ContUso, '') = @ContUso
SELECT @Acumulado = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoInv = ISNULL(SUM(d.SubTotalInv*e.TipoCambio), 0.0),
@AcumuladoCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'CONCLUIDO' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
AND ISNULL(d.ContUso, '') = @ContUso
SELECT @Devoluciones = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesInv = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus = 'CONCLUIDO' AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.D', 'COMS.B')
AND ISNULL(d.ContUso, '') = @ContUso
IF @CfgCompraValidarPresupuestoMov = 'Orden Compra'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O')
AND ISNULL(d.ContUso, '') = @ContUso
ELSE
IF @CfgCompraValidarPresupuestoMov = 'Requisicion'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.R')
AND ISNULL(d.ContUso, '') = @ContUso
END 
ELSE
BEGIN
SELECT @Presupuesto = ISNULL(SUM(d.SubTotal*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoInv = ISNULL(SUM(d.SubTotalInv*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoCantidad = ISNULL(SUM(d.Cantidad*mt.Factor), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.PR')
SELECT @Acumulado = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoInv = ISNULL(SUM(d.SubTotalInv*e.TipoCambio), 0.0),
@AcumuladoCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'CONCLUIDO' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
SELECT @Devoluciones = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesInv = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus = 'CONCLUIDO' AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.D', 'COMS.B')
IF @CfgCompraValidarPresupuestoMov = 'Orden Compra'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O')
ELSE
IF @CfgCompraValidarPresupuestoMov = 'Requisicion'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND d.FechaRequerida BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.R')
END 
END 
ELSE
BEGIN
IF @CfgCompraValidarPresupuestoCC = 1
BEGIN
SELECT @Presupuesto = ISNULL(SUM(d.SubTotal*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoInv = ISNULL(SUM(d.SubTotalInv*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoCantidad = ISNULL(SUM(d.Cantidad*mt.Factor), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.PR')
AND ISNULL(d.ContUso, '') = @ContUso
SELECT @Acumulado = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoInv = ISNULL(SUM(d.SubTotalInv*e.TipoCambio), 0.0),
@AcumuladoCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'CONCLUIDO' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
AND ISNULL(d.ContUso, '') = @ContUso
SELECT @Devoluciones = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesInv = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus = 'CONCLUIDO' AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.D', 'COMS.B')
AND ISNULL(d.ContUso, '') = @ContUso
IF @CfgCompraValidarPresupuestoMov = 'Orden Compra'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O')
AND ISNULL(d.ContUso, '') = @ContUso
ELSE
IF @CfgCompraValidarPresupuestoMov = 'Requisicion'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.R')
AND ISNULL(d.ContUso, '') = @ContUso
END 
ELSE
BEGIN
SELECT @Presupuesto = ISNULL(SUM(d.SubTotal*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoInv = ISNULL(SUM(d.SubTotalInv*mt.Factor*e.TipoCambio), 0.0),
@PresupuestoCantidad = ISNULL(SUM(d.Cantidad*mt.Factor), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.PR')
SELECT @Acumulado = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoInv = ISNULL(SUM(d.SubTotalInv*e.TipoCambio), 0.0),
@AcumuladoCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'CONCLUIDO' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
SELECT @Devoluciones = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesInv = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@DevolucionesCantidad = ISNULL(SUM(d.Cantidad), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus = 'CONCLUIDO' AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.D', 'COMS.B')
IF @CfgCompraValidarPresupuestoMov = 'Orden Compra'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O')
ELSE
IF @CfgCompraValidarPresupuestoMov = 'Requisicion'
SELECT @Acumulado2 = ISNULL(SUM(d.SubTotal*e.TipoCambio), 0.0),
@AcumuladoCantidad2 = ISNULL(SUM(d.CantidadPendiente), 0.0)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND e.Empresa = @Empresa
AND d.Articulo = @Articulo
AND mt.Modulo = 'COMS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.R')
END 
END 
SELECT @Acumulado = @Acumulado + @Acumulado2 - @Devoluciones,
@AcumuladoInv = @AcumuladoInv + @AcumuladoInv2 - @DevolucionesInv,
@AcumuladoCantidad = @AcumuladoCantidad + @AcumuladoCantidad2 - @DevolucionesCantidad
SELECT @Diferencia = @Presupuesto - @Acumulado - @Importe,
@DiferenciaInv = @PresupuestoInv - @AcumuladoInv - @ImporteInv,
@DiferenciaCantidad = @PresupuestoCantidad - @AcumuladoCantidad - @Cantidad
IF @Diferencia < 0.0    SELECT @Ok = 20900, @OkRef = RTRIM(@Articulo)+'<BR><BR>Presupuesto: '+LTRIM(CONVERT(char, @Presupuesto))   +'<BR>Acumulado: '+LTRIM(CONVERT(char, @Acumulado))   +'<BR>Excedente: '+LTRIM(CONVERT(char, -@Diferencia)) ELSE
IF @DiferenciaInv < 0.0 SELECT @Ok = 20901, @OkRef = RTRIM(@Articulo)+'<BR><BR>Presupuesto: '+LTRIM(CONVERT(char, @PresupuestoInv))+'<BR>Acumulado: '+LTRIM(CONVERT(char, @AcumuladoInv))+'<BR>Excedente: '+LTRIM(CONVERT(char, -@DiferenciaInv)) ELSE
IF @CfgCompraValidarPresupuestoCant = 1 AND @DiferenciaCantidad < 0.0
SELECT @Ok = 20265, @OkRef = RTRIM(@Articulo)+'<BR><BR>Presupuesto: '+LTRIM(CONVERT(char, @PresupuestoCantidad))+'<BR>Acumulado: '+LTRIM(CONVERT(char, @AcumuladoCantidad))+'<BR>Excedente: '+LTRIM(CONVERT(char, -@DiferenciaCantidad))
IF @Ok IS NOT NULL AND @CfgCompraValidarPresupuestoCC = 1
SELECT @OkRef = RTRIM(@OkRef) + '<BR><BR>Centro de Costos ' + RTRIM(@ContUso)
END
FETCH NEXT FROM crCompra INTO @ValidarFecha, @Articulo, @ContUso, @ArtValidarPresupuesto, @Importe, @ImporteInv, @Cantidad
END
CLOSE crCompra
DEALLOCATE crCompra
END

