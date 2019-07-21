SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISEliminarEnviadosSucursal
(
@SucursalDestino			int,
@Fecha						datetime
)

AS BEGIN
DECLARE
@UltimoRegistroEnviado			int,
@IDPenultimaSincronizacion		int
SELECT @UltimoRegistroEnviado = MAX(ID)
FROM IntelisisService
WHERE Estatus = 'ENVIADO'
AND SubReferencia = 'SincroFinal'
AND SucursalDestino = @SucursalDestino
AND dbo.fnFechaSinHora(FechaEstatus) <= @Fecha
AND Referencia = 'SincroIS'
SELECT @IDPenultimaSincronizacion = MAX(ID)
FROM IntelisisService
WHERE Estatus = 'ENVIADO'
AND SubReferencia = 'SincroFinal'
AND SucursalDestino = @SucursalDestino
AND dbo.fnFechaSinHora(FechaEstatus) <= @Fecha
AND ID < @UltimoRegistroEnviado
AND Referencia = 'SincroIS'
DELETE FROM IntelisisService
WHERE Estatus = 'ENVIADO'
AND SucursalDestino = @SucursalDestino
AND ID <= @IDPenultimaSincronizacion
AND dbo.fnFechaSinHora(FechaEstatus) <= @Fecha
AND Referencia = 'SincroIS'
END

