SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTLayout
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
DECLARE @Proveedor		varchar(20),
@ProveedorAnt		varchar(20),
@Rubro1			float,
@Rubro1IVA		float,
@Rubro2			float,
@Rubro2IVA		float,
@Rubro3			float,
@Rubro3IVA		float,
@Rubro4			float,
@Rubro4IVA		float,
@Rubro5			float,
@Rubro6			float,
@Rubro7			float,
@Retencion2		float,
@Rubro10IVA		float
SELECT @ProveedorAnt = ''
WHILE(1=1)
BEGIN
SELECT @Proveedor = MIN(Proveedor)
FROM DIOTD
WHERE EstacionTrabajo = @Estacion
AND Proveedor > @ProveedorAnt
IF @Proveedor IS NULL BREAK
SELECT @ProveedorAnt = @Proveedor
SELECT @Rubro1 = NULL, @Rubro1IVA = NULL, @Rubro2 = NULL, @Rubro2IVA = NULL, @Rubro3 = NULL, @Rubro3IVA = NULL, @Rubro4 = NULL, @Rubro4IVA = NULL, @Rubro5 = NULL,
@Rubro6 = NULL, @Rubro7 = NULL, @Retencion2 = NULL, @Rubro10IVA = NULL
SELECT @Rubro1     = ISNULL(SUM(Importe), 0)   FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 1
SELECT @Rubro1IVA  = ISNULL(SUM(IVA),0) FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 1
SELECT @Rubro3     = ISNULL(SUM(Importe*((100-PorcentajeDeducible)/100.0) ), 0) FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 2
SELECT @Rubro3IVA  = ISNULL(SUM(IVA*((100-PorcentajeDeducible)/100.0) ), 0) FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 2
SELECT @Rubro5     = ISNULL(SUM(Importe), 0)   FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 3
SELECT @Rubro6     = ISNULL(SUM(Importe), 0)   FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 4
SELECT @Rubro7     = ISNULL(SUM(Importe), 0)   FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 5
SELECT @Retencion2 = ISNULL(SUM(Retencion2), 0)FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor
SELECT @Rubro10IVA = ISNULL(SUM(IVA), 0)       FROM DIOTD WHERE EstacionTrabajo = @Estacion AND Proveedor = @Proveedor AND TipoOperacion = 7
INSERT INTO	DIOTLayout(
EstacionTrabajo,
TipoTercero,
TipoOperacion,
RFC, IDFiscal, NombreExtranjero,
Pais,
Nacionalidad,  Rubro1,  Rubro1IVA,  /*Rubro2,  Rubro2IVA,  */Rubro3 , Rubro3IVA,  /*Rubro4,  Rubro4IVA,  */Rubro5,  Rubro6,  Rubro7,  Retencion2,  Rubro10IVA)
SELECT @Estacion,
CASE d.TipoTercero WHEN 'Nacional' THEN '04' WHEN 'Extranjero' THEN '05' ELSE '04' END,
CASE ISNULL(o.TipoOperacion, 'Otros') WHEN 'Prestacion Servicios' THEN '03' WHEN 'Arrendamiento Inmuebles' THEN '06' WHEN 'Otros' THEN '85' END,
ISNULL(d.RFC, ''), ISNULL(d.ImportadorRegistro, ''), ISNULL(d.Nombre, ''),
ISNULL(p.Clave, ''),
ISNULL(d.Nacionalidad, ''), @Rubro1, @Rubro1IVA, /*@Rubro2, @Rubro2IVA, */@Rubro3, @Rubro3IVA, /*@Rubro4, @Rubro4IVA, */@Rubro5, @Rubro6, @Rubro7, @Retencion2, @Rubro10IVA
FROM DIOTD d
LEFT OUTER JOIN DIOTProvTipoOperacion o ON d.Proveedor = o.Proveedor
LEFT OUTER JOIN DIOTPais p ON d.Pais = p.Pais
WHERE EstacionTrabajo = @Estacion
AND d.Proveedor = @Proveedor
GROUP BY d.TipoTercero, o.TipoOperacion, d.RFC, d.ImportadorRegistro, d.Nombre, p.Clave, d.Nacionalidad
END
UPDATE DIOTLayout
SET Cadena = ISNULL(TipoTercero, '') + '|' +
ISNULL(TipoOperacion, '') + '|'+
CASE ISNULL(TipoTercero, '') WHEN '04' THEN ISNULL(RFC, '') ELSE '' END + '|' +
CASE ISNULL(TipoTercero, '') WHEN '05' THEN ISNULL(IDFiscal, '') ELSE '' END + '|' +
CASE ISNULL(TipoTercero, '') WHEN '05' THEN ISNULL(NombreExtranjero, '') ELSE '' END + '|' +
CASE ISNULL(TipoTercero, '') WHEN '05' THEN ISNULL(Pais, '') ELSE '' END + '|' +
CASE ISNULL(TipoTercero, '') WHEN '05' THEN ISNULL(Nacionalidad, '') ELSE '' END + '|' +
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro1)), 0)), '') + '|' +		
'|' +																										
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro1IVA)), 0)), '') + '|' +	
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro2)), 0)), '') + '|' +		
'|' +																										
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro2IVA)), 0)), '') + '|' +	
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro3)), 0)), '') + '|' +		
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro3IVA)), 0)), '') + '|' +	
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro4)), 0)), '') + '|' +		
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro4IVA)), 0)), '') + '|' +	
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro5)), 0)), '') + '|' +		
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro6)), 0)), '') + '|' +		
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro7)), 0)), '') + '|' +		
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Retencion2)), 0)), '') + '|' +	
ISNULL(CONVERT(varchar(max), NULLIF(CONVERT(int, dbo.fnDIOTLayoutImporte(Rubro10IVA)), 0)), '') + '|'		
FROM DIOTLayout
WHERE EstacionTrabajo = @Estacion
END

