SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaAguinaldoComplementoIncidencia
@Empresa                                char(5),
@Personal                               char(10),
@NomTipo                                varchar(50),
@TipoCambio                             float,
@RedondeoMonetarios                     float,
@FechaA                                 datetime,
@FechaD                                 datetime,
@Ok                                     int             OUTPUT,
@OkRef                                  varchar(255)    OUTPUT

AS BEGIN
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE NULLIF(d.SALDO, 0.0) IS NOT NULL
AND nc.NominaConcepto in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina In ('Aguinaldo Conf','AguinaldoComplemento'))
AND d.FechaAplicacion <= @FechaA
END

