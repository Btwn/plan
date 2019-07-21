SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaAcumuladoFechas
@Empresa	char(5),
@Personal	char(10),
@Concepto	varchar(50),
@FechaD		datetime,
@FechaA		datetime,
@Movimiento	varchar(50),
@Importe	money	OUTPUT,
@Cantidad	float	OUTPUT,
@NoEnMov  	char(20)	= NULL,
@Estatus 	varchar(15)	= NULL

AS BEGIN
IF NOT EXISTS(SELECT * FROM EmpresaCfgNominaAcum WHERE Empresa = @Empresa)
INSERT EmpresaCfgNominaAcum (Empresa, EmpresaAcum) VALUES (@Empresa, @Empresa)
SELECT @Personal   = NULLIF(RTRIM(@Personal), ''),
@Concepto   = NULLIF(RTRIM(@Concepto), ''),
@Movimiento = NULLIF(RTRIM(@Movimiento), '')
SELECT @Importe = 0.0, @Cantidad = 0.0
SELECT @Importe = @Importe + ISNULL(SUM(ISNULL(d.Importe,0)), 0.0), @Cantidad = @Cantidad + ISNULL(SUM(ISNULL(d.Cantidad,0)), 0.0)
FROM Nomina n, NominaD d, MovTipo mt
WHERE n.ID = d.ID
AND n.Estatus in('CONCLUIDO',Case WHEN @Estatus = 'BORRADOR' then 'BORRADOR' else 'CONCLUIDO' END)
AND n.Empresa IN (SELECT EmpresaAcum FROM EmpresaCfgNominaAcum WHERE Empresa = @Empresa)
AND n.FechaA BETWEEN @FechaD AND @FechaA AND mt.Clave IN ('NOM.N', 'NOM.NE')
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND d.Personal = @Personal
AND d.Concepto = @Concepto
AND d.Movimiento = ISNULL(@Movimiento, d.Movimiento)
AND n.Mov not in(@NoEnMov)
SELECT @Importe = @Importe + ISNULL(SUM(ISNULL(d.Importe,0)), 0.0), @Cantidad = @Cantidad + ISNULL(SUM(ISNULL(d.Cantidad,0)), 0.0)
FROM Nomina n, NominaD d, MovTipo mt
WHERE n.ID = d.ID
AND n.Estatus in('CONCLUIDO',Case WHEN @Estatus = 'BORRADOR' then 'BORRADOR' else 'CONCLUIDO' END)
AND n.Empresa IN (SELECT EmpresaAcum FROM EmpresaCfgNominaAcum WHERE Empresa = @Empresa)
AND n.FechaEmision BETWEEN @FechaD AND @FechaA AND mt.Clave IN ('NOM.NA', 'NOM.NC')
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND d.Personal = @Personal
AND d.Concepto = @Concepto
AND d.Movimiento = ISNULL(@Movimiento, d.Movimiento)
AND n.Mov not in(@NoEnMov)
RETURN
END

