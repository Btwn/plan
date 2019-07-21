SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDReporteMensual
@Empresa	char(5),
@Ejercicio	int,
@Periodo	int

AS BEGIN
SET CONCAT_NULL_YIELDS_NULL Off
DELETE CFDReporteMensual
CREATE TABLE #CFDReporteMensual (
ID			int   NOT NULL IDENTITY(1,1) PRIMARY KEY,
Dato			varchar(8000)  NULL)
CREATE TABLE #CFDReporteMensualValida (
ID			int   NOT NULL IDENTITY(1,1) PRIMARY KEY,
Empresa		varchar(20) NULL,
Mov			varchar(20) NULL,
MovID		varchar(20) NULL,
rfc			VARCHAR(20) null,
Serie		varchar(20) NULL,
Folio		varchar(20) NULL,
NoAprobacion varchar(20) NULL,
FechaEmision varchar(20) NULL,
Total		varchar(20) NULL,
Impuestos	varchar(20) NULL,
tipo			varchar(10) NULL)
CREATE TABLE #CFDReporteMensualPedimento (
ID				int   NOT NULL IDENTITY(1,1) PRIMARY KEY,
Empresa			varchar(20) NULL,
Mov				varchar(20) NULL,
MovID			varchar(20) NULL,
Pedimento		varchar(8000) NULL,
FechaPedimento	varchar(8000) NULL,
Aduana			varchar(8000) NULL)
INSERT #CFDReporteMensualValida (Empresa, MovID, RFC, Serie, Folio, NoAprobacion, FechaEmision, Total, Impuestos, Tipo)
SELECT Empresa, MovID, dbo.fnLimpiarRFC(RFC), Serie, CONVERT(varchar, Folio), CONVERT(varchar, Aprobacion), CONVERT(varchar, Fecha, 103),
CONVERT(varchar, CONVERT(DECIMAL(20,2),ISNULL(Importe,0.0)+ISNULL(Impuesto1,0.0)+ISNULL(Impuesto2,0.0)-ISNULL(Retencion1,0.0)-ISNULL(Retencion2,0.0))),
CONVERT(varchar, CONVERT(DECIMAL(20,2),Impuesto1)),
ISNULL(dbo.fnCFDtipoComprobante(Modulo, ModuloID),'')
FROM CFD WITH (NOLOCK)
WHERE Empresa = @Empresa AND YEAR(Fecha) = @Ejercicio AND MONTH(Fecha) = @Periodo AND
(dbo.fnLimpiarRFC(RFC) IS NULL OR Serie IS NULL OR Folio IS NULL OR Aprobacion Is NULL OR Fecha IS NULL OR Importe IS NULL OR Impuesto1 IS NULL OR NULLIF(dbo.fnCFDtipoComprobante(Modulo, ModuloID),'') IS NULL )
INSERT #CFDReporteMensualPedimento (Empresa, MovID, Pedimento, FechaPedimento, Aduana)
SELECT Empresa, MovID, ISNULL(dbo.fnCFDDatosPedimento(Modulo, ModuloID, 'PEDIMENTO'),''), ISNULL(dbo.fnCFDDatosPedimento(Modulo, ModuloID, 'PEDIMENTOFECHA'),''), ISNULL(dbo.fnCFDDatosPedimento(Modulo, ModuloID, 'ADUANA'),'')
FROM CFD WITH (NOLOCK)
WHERE Empresa = @Empresa AND YEAR(Fecha) = @Ejercicio AND MONTH(Fecha) = @Periodo  AND
NULLIF(dbo.fnCFDDatosPedimento(Modulo, ModuloID, 'PEDIMENTO'),'') IS NOT NULL AND
(NULLIF(dbo.fnCFDDatosPedimento(Modulo, ModuloID, 'PEDIMENTOFECHA'),'') IS NULL OR
NULLIF(dbo.fnCFDDatosPedimento(Modulo, ModuloID, 'ADUANA'),'') IS NULL)
IF EXISTS (SELECT ID FROM #CFDReporteMensualValida)
INSERT INTO CFDReporteMensual
SELECT 'Faltan Datos:'+
' Empresa='+Empresa+
' MovId='+MovID+
' RFC='+ISNULL(RFC,'FALTA_ESPECIFICAR')+
' Serie='+ISNULL(Serie,'FALTA_ESPECIFICAR')+
' Folio='+ISNULL(Folio,'FALTA_ESPECIFICAR')+
' NoAprobacion='+ISNULL(NoAprobacion,'FALTA_ESPECIFICAR')+
' FechaEmision='+ISNULL(FechaEmision,'FALTA_ESPECIFICAR')+
' Total='+ISNULL(total,'FALTA_ESPECIFICAR')+
' Impuestos='+ISNULL(Impuestos,'FALTA_ESPECIFICAR')+
' Tipo='+ISNULL(Tipo,'FALTA_ESPECIFICAR')
FROM #CFDReporteMensualValida
ELSE
IF EXISTS (SELECT ID FROM #CFDReporteMensualPedimento)
INSERT INTO CFDReporteMensual
SELECT 'Faltan Datos:'+
' Empresa='+Empresa+
' MovId='+MovID+
' Pedimento='+ISNULL(Pedimento,'')+
' FechaPedimento='+ISNULL(FechaPedimento,'FALTA_ESPECIFICAR')+
' Aduana='+ISNULL(Aduana,'FALTA_ESPECIFICAR')
FROM #CFDReporteMensualPedimento
ELSE
INSERT INTO CFDReporteMensual (Dato)
SELECT 'Dato' =
'|'+RTRIM(LTRIM(RFC))+
'|'+RTRIM(LTRIM(Serie))+
'|'+CONVERT(varchar, Folio)+
'|'+CONVERT(varchar, Aprobacion)+
'|'+CONVERT(varchar, Fecha, 103)+' '+CONVERT(varchar, Fecha, 108)+
'|'+CONVERT(varchar, CONVERT(DECIMAL(20,2),(ISNULL(Importe,0.0)+ISNULL(Impuesto1,0.0)+ISNULL(Impuesto2,0.0)-ISNULL(Retencion1,0.0)-ISNULL(Retencion2,0.0))*ISNULL(TipoCambio,1)))+
'|'+CONVERT(varchar, CONVERT(DECIMAL(20,2),Impuesto1*ISNULL(TipoCambio,1)))+
'|1'+
'|'+dbo.fnCFDtipoComprobante(Modulo, ModuloID)+
'|'+dbo.fnCFDDatosPedimento(Modulo, ModuloId, 'PEDIMENTO')+
'|'+dbo.fnCFDDatosPedimento(Modulo, ModuloId, 'PEDIMENTOFECHA')+
'|'+dbo.fnCFDDatosPedimento(Modulo, ModuloId, 'ADUANA')+
'|'
FROM CFD WITH (NOLOCK)
WHERE Empresa = @Empresa AND YEAR(Fecha) = @Ejercicio AND MONTH(Fecha) = @Periodo AND Folio IS NOT NULL
UNION ALL
SELECT 'Dato' =
'|'+RTRIM(LTRIM(RFC))+
'|'+RTRIM(LTRIM(Serie))+
'|'+CONVERT(varchar, Folio)+
'|'+CONVERT(varchar, Aprobacion)+
'|'+CONVERT(varchar, Fecha, 103)+' '+CONVERT(varchar, Fecha, 108)+
'|'+CONVERT(varchar, CONVERT(DECIMAL(20,2),(ISNULL(Importe,0.0)+ISNULL(Impuesto1,0.0)+ISNULL(Impuesto2,0.0)-ISNULL(Retencion1,0.0)-ISNULL(Retencion2,0.0))*ISNULL(TipoCambio,1)))+
'|'+CONVERT(varchar, CONVERT(DECIMAL(20,2),Impuesto1*ISNULL(TipoCambio,1)))+
'|0'+
'|'+dbo.fnCFDtipoComprobante(Modulo, ModuloID)+
'|'+dbo.fnCFDDatosPedimento(Modulo, ModuloId, 'PEDIMENTO')+
'|'+dbo.fnCFDDatosPedimento(Modulo, ModuloId, 'PEDIMENTOFECHA')+
'|'+dbo.fnCFDDatosPedimento(Modulo, ModuloId, 'ADUANA')+
'|'
FROM CFD WITH (NOLOCK)
WHERE Empresa = @Empresa AND YEAR(FechaCancelacion) = @Ejercicio AND MONTH(FechaCancelacion) = @Periodo AND Folio IS NOT NULL
SET CONCAT_NULL_YIELDS_NULL OFF
RETURN
END

