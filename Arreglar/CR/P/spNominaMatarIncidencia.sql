SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaMatarIncidencia
@Empresa	char(5),
@Sucursal	int,
@Modulo		char(5),
@ID		int,
@Mov		varchar(20),
@MovID		varchar(20),
@MovTipo	varchar(20),
@Accion		varchar(20),
@Cantidad	float,
@Importe	money,
@MovTipoCambio	float,
@RID		int,
@NomAutoTipo	varchar(50),
@Ok 		int 		OUTPUT,
@OkRef 		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@EsCancelacion 		bit,
@IncidenciaID		int,
@IncidenciaMov		varchar(20),
@IncidenciaMovID		varchar(20),
@Numero			int,
@Estatus			varchar(15),
@Saldo			money,
@TipoCambio			float,
@Tolerancia			float
IF @MovTipo = 'NOM.NC' OR @Accion = 'CANCELAR' SELECT @EsCancelacion = 1 ELSE SELECT @EsCancelacion = 0
IF @MovTipo = 'NOM.NC' SELECT @Cantidad = -@Cantidad
SELECT @IncidenciaID = i.ID, @Estatus = i.Estatus, @IncidenciaMov = i.Mov, @IncidenciaMovID = i.MovID, @TipoCambio = i.TipoCambio,
@Saldo = ISNULL(d.Saldo, 0.0), @Numero = d.Numero
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE d.RID = @RID
IF @EsCancelacion = 0
BEGIN
IF @Estatus <> 'PENDIENTE' OR (ROUND(@Importe*@MovTipoCambio, 2) > ROUND(@Saldo*@TipoCambio, 2))
SELECT @Ok = 30680, @OkRef = 'Incidencia id=' + Convert(varchar, @IncidenciaID) + 'Importe'+ convert(varchar,ROUND(@Importe*@MovTipoCambio, 2))+'saldo'+convert(varchar,ROUND(@Saldo, 2))+'-'+convert(varchar,@RID  )
ELSE
BEGIN
UPDATE IncidenciaD
SET CantidadPendiente = NULLIF(CantidadPendiente - @Cantidad, 0.0),
Saldo = NULLIF(Saldo - ((@Importe*@MovTipoCambio)/@TipoCambio), 0.0)
WHERE RID = @RID
UPDATE IncidenciaD
SET CantidadPendiente = CASE WHEN ABS(CantidadPendiente) < .05 THEN 0.0 ELSE CantidadPendiente END,
Saldo = CASE WHEN ABS(Saldo) < .05 THEN 0.0 ELSE Saldo END
WHERE RID = @RID
IF NOT EXISTS(SELECT * FROM IncidenciaD WHERE ID = @IncidenciaID AND (NULLIF(ROUND(CantidadPendiente, 4), 0.0) IS NOT NULL OR NULLIF(ROUND(Saldo, 1), 0.0) IS NOT NULL))
UPDATE Incidencia SET Estatus = 'CONCLUIDO', FechaConclusion = GETDATE() WHERE ID = @IncidenciaID
END
END ELSE
BEGIN
IF @Estatus = 'CANCELADO'
SELECT @Ok = 30690
ELSE
BEGIN
UPDATE IncidenciaD
SET CantidadPendiente = ISNULL(CantidadPendiente, 0.0) + @Cantidad,
Saldo = ISNULL(Saldo, 0.0) + ((CASE WHEN @MovTipo ='NOM.NC' THEN -@Importe ELSE @Importe END * @MovTipoCambio)/@TipoCambio)
WHERE RID = @RID
UPDATE IncidenciaD
SET CantidadPendiente = CASE WHEN ABS(CantidadPendiente) < .05 THEN 0.0 ELSE CantidadPendiente END,
Saldo = CASE WHEN ABS(Saldo) < .05 THEN 0.0 ELSE Saldo END
WHERE RID = @RID
IF @Estatus = 'CONCLUIDO' AND EXISTS(SELECT * FROM IncidenciaD WHERE ID = @IncidenciaID AND (NULLIF(ROUND(Cantidad, 4), 0.0) IS NOT NULL OR NULLIF(ROUND(Saldo, 1), 0.0) IS NOT NULL))
UPDATE Incidencia SET Estatus = 'PENDIENTE', FechaConclusion = NULL WHERE ID = @IncidenciaID
END
END
IF @Ok IS NOT NULL
SELECT @OkRef = @IncidenciaMov+' '+@IncidenciaMovID + ', Importe '+ convert(varchar,ROUND(@Importe*@MovTipoCambio, 2))+', Saldo '+convert(varchar,ROUND(@Saldo*@MovTipoCambio, 2))+' ('+convert(varchar, @Numero)+')'
ELSE
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INC', @IncidenciaID, @IncidenciaMov, @IncidenciaMovID, @Ok OUTPUT
RETURN
END

