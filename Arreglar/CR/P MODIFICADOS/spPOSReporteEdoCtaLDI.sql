SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReporteEdoCtaLDI
@ID        int

AS
BEGIN
DECLARE
@Estacion  int
SELECT @Estacion = @@SPID
DELETE POSLDIEdoCtaTemp WHERE Estacion = @@SPID
DECLARE @TablaFecha table(
ID		int IDENTITY,
Fecha	varchar(50))
DECLARE @TablaMonto table(
ID		int IDENTITY,
Monto	float)
DECLARE @TablaMov table(
ID		int IDENTITY,
Mov		varchar(50))
DECLARE @TablaConcepto table(
ID			int IDENTITY,
Concepto	varchar(50))
DECLARE @TablaReferencia table(
ID			int IDENTITY,
Referencia	varchar(50))
INSERT @TablaFecha(Fecha)
SELECT Campo from dbo.fnPOSGenerarTicket((SELECT ListaFechas FROM POSLDILog WITH (NOLOCK) where ID = @ID),',')
INSERT @TablaMonto(Monto)
SELECT Campo from dbo.fnPOSGenerarTicket((SELECT ListaMontos FROM POSLDILog WITH (NOLOCK) where ID = @ID),',')
INSERT @TablaMov(Mov)
SELECT Campo from dbo.fnPOSGenerarTicket((SELECT ListaMovimientos FROM POSLDILog WITH (NOLOCK) where ID = @ID),',')
INSERT @TablaConcepto(Concepto)
SELECT Campo from dbo.fnPOSGenerarTicket((SELECT ListaConceptos FROM POSLDILog WITH (NOLOCK) where ID = @ID),',')
INSERT @TablaReferencia(Referencia)
SELECT Campo from dbo.fnPOSGenerarTicket((SELECT ListaReferencias FROM POSLDILog WITH (NOLOCK) where ID = @ID),',')
INSERT POSLDIEdoCtaTemp(Estacion, Fecha, Monto, Mov, Concepto, Referencia)
SELECT @@SPID,
dbo.fnPOSLDIFormatearFecha(f.Fecha) Fecha,
NULLIF(m.Monto,''),NULLIF(NULLIF(v.Mov,''),'null') Mov ,
NULLIF(NULLIF(c.Concepto,''),'null')Concepto,
NULLIF(NULLIF(r.Referencia,''),'null')Referencia
FROM @TablaFecha f JOIN @TablaMonto m ON f.ID = m.ID JOIN @TablaMov v ON v.ID = f.ID
JOIN @TablaConcepto c ON f.ID = c.ID
JOIN @TablaReferencia r ON f.ID = r.ID
END

