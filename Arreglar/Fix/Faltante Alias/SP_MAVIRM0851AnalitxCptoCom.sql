USE [IntelisisTmp]
GO
/****** Object:  StoredProcedure [dbo].[SP_MAVIRM0851AnalitxCptoCom]    Script Date: 26/04/2019 01:05:38 p. m. ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- ========================================================================================================================================
-- NOMBRE			: SP_MAVIRM0851AnalitxCptoCom
-- AUTOR			: Faustino Lopez Raygoza
-- FECHA CREACION	: 20-DIC-2009	
-- DESARROLLO		: RM0851 Analítico de Importes Por Concepto Comercial
-- MODULO			: CXC
-- DESCRIPCION		: Consulta que obtiene Movimientos de CXC de todos los movimientos que
--					involucren Facturas, Prestamos, Cobros, Notas de Credito, Cheques, Seguros,
--					Notas de Cargo y mas movimientos que interfieren con los clientes.
--					Ejemplo: SP_MAVIRM0851AnalitxCptoCom '2009-05-01', '2009-05-30'
-- ========================================================================================================================================
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:     06-Mayo-2010      Por: Faustino Lopez Raygoza.
-- ========================================================================================================================================
ALTER PROCEDURE [dbo].[SP_MAVIRM0851AnalitxCptoCom] @FechaD DATETIME, @FechaA DATETIME 
AS
BEGIN
-- INICIO DEL PROCEDIMIENTO

/*	Crear tabla temporal para insertar los movimientos que se requieren de cada caso especial	*/
IF EXISTS(SELECT * FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#MovsRM851') AND type='U')
DROP TABLE #MovsRM851
CREATE TABLE #MovsRM851(
OrigenTipo		VARCHAR(20) NULL,
Mov				VARCHAR(20) NULL,
MovID			VARCHAR(20) NULL,
FechaEmision	DATETIME NULL,
Conceptos		VARCHAR(100) NULL,
TipoConcepto	VARCHAR(15) NULL,
Modulo			VARCHAR(8) NULL,
Can				TINYINT NULL,
Importe			MONEY NULL,
Impuestos		MONEY NULL,
Total			MONEY NULL,
Financiamiento	MONEY NULL,
Capital			MONEY NULL,
Condicion		VARCHAR(50) NULL,
Meses			TINYINT NULL
)

/* Para la Parte de Facturas, Prestamos y Seguros de la tabla Venta y CXC */
/*	03-Marzo-2010 --> excluir los articulos de Tiempo Aire, Productos Diversos y Seguros de Entrega		*/
INSERT INTO #MovsRM851
SELECT OrigenTipo, Mov, MovID, FechaEmision, Conceptos, TipoConcepto, Modulo, Can,
	Importe=SUM(Importe), Impuestos=SUM(Impuestos), Total=SUM(Importe)+SUM(Impuestos), Financiamiento, Capital, Condicion, Meses
FROM
(
	SELECT OrigenTipo=V.SubModulo,V.Mov,V.Movid,V.FechaEmision,
	Conceptos= CASE WHEN VCM.Categoria IN('CREDITO MENUDEO','ASOCIADOS','INSTITUCIONES') AND V.Mov NOT IN ('Devolucion Mayoreo','Devolucion Venta','Devolucion VIU') THEN 'CREDITO MENUDEO E INST'
					WHEN VCM.Categoria = 'CREDITO EXTERNO' AND V.Mov NOT IN ('Devolucion Mayoreo','Devolucion Venta','Devolucion VIU') THEN 'VTAS CREDITO EXTERNO'
					WHEN VCM.Categoria = 'MAYOREO' AND V.Mov NOT IN ('Devolucion Mayoreo','Devolucion Venta','Devolucion VIU') THEN 'VTAS MAYOREO'
					WHEN VCM.Categoria = 'CONTADO' AND V.Mov NOT IN ('Devolucion Mayoreo','Devolucion Venta','Devolucion VIU') THEN 'VTAS CONTADO'
					WHEN V.Mov IN ('Devolucion Venta','Devolucion VIU') AND ISNULL(V.Mayor12Meses,0) = 0 AND VCM.CATEGORIA IN ('CREDITO MENUDEO','ASOCIADOS','INSTITUCIONES') THEN 'DEVOLUCION DE 1 A 12 MESES'
					WHEN V.Mov IN ('Devolucion Venta','Devolucion VIU') AND ISNULL(V.Mayor12Meses,0) = 1 AND VCM.CATEGORIA IN ('CREDITO MENUDEO','ASOCIADOS','INSTITUCIONES') THEN 'DEVOLUCION DE + DE 12 MESES'
					WHEN V.Mov IN ('Devolucion Venta','Devolucion VIU') AND VCM.CATEGORIA='CONTADO' THEN 'DEVOLUCION CONTADO'
					WHEN V.Mov IN ('Devolucion Venta','Devolucion VIU') AND VCM.CATEGORIA='CREDITO EXTERNO' THEN 'DEVOLUCION CREDITO EXTERNO'
					WHEN V.Mov ='Devolucion Mayoreo' THEN UPPER(V.Mov)
					END,
	TipoConcepto=CASE WHEN V.Mov IN ('Devolucion Mayoreo','Devolucion Venta','Devolucion VIU') THEN 'ACREEDOR' ELSE 'DEUDOR' END,
	Modulo = 'VTAS', V.EnviarA AS Can,
	Importe = CASE WHEN A.Grupo = 'PRODUCTOS DIVERSOS' THEN 0.0
				WHEN A.Linea = 'TIEMPO AIRE' THEN 0.0
				WHEN A.Articulo LIKE 'SEGU%' THEN 0.0
				WHEN D.Impuesto1 <= 0 THEN C.Importe
			ELSE ROUND(((D.Precio*D.Cantidad)-ISNULL(D.DescuentoImporte,0.0))/(1+(D.Impuesto1/100)),4) END,
	Impuestos=CASE WHEN V.Mov IN ('Credilana','Prestamo Personal') THEN CA.Impuestos
				WHEN A.Grupo = 'PRODUCTOS DIVERSOS' THEN 0.0
				WHEN A.Articulo LIKE 'SEGU%' THEN 0.0
				WHEN D.Impuesto1 <= 0 THEN V.Impuestos
			  ELSE ROUND((((D.Precio*D.Cantidad)-ISNULL(D.DescuentoImporte,0.0))/(1+(D.Impuesto1/100)))*(D.Impuesto1/100),4) END,
	D.Financiamiento,
	Capital = CASE WHEN D.Financiamiento IS NULL OR D.Financiamiento = 0.0 THEN C.Importe ELSE V.Importe-D.Financiamiento END,
	V.Condicion,
	Meses = ISNULL(V.Mayor12Meses,0)
	FROM CXC C WITH (NOLOCK)
	LEFT JOIN dbo.CxcAplica CA WITH (NOLOCK) ON C.ID=CA.ID
	INNER JOIN Venta V WITH (NOLOCK) ON c.Origen=v.mov AND c.OrigenID=v.movid
	INNER JOIN Cte WITH (NOLOCK) ON V.cliente=Cte.Cliente
	INNER JOIN VentasCanalMavi VCM WITH (NOLOCK) ON V.EnviarA=VCM.ID
	INNER JOIN Ventad D WITH (NOLOCK) ON V.ID = D.ID
	INNER JOIN Art A WITH (NOLOCK) ON D.Articulo = A.Articulo
	WHERE ( (C.Mov IN ('Factura','Factura Mayoreo','Factura VIU','Credilana','Prestamo Personal','Seguro Vida','Seguro Auto') AND C.Estatus = 'CONCLUIDO')
	OR (C.Origen IN ('Devolucion Mayoreo','Devolucion Venta','Devolucion VIU') AND C.Estatus IN ('PENDIENTE','CONCLUIDO')) )
	AND C.FechaEmision BETWEEN @FechaD AND @FechaA
) AS C
GROUP BY OrigenTipo, Mov, MovID, FechaEmision, Conceptos, TipoConcepto, Modulo, Can, Financiamiento, Capital, Condicion, Meses

/*	Para los Refinanciamientos que se son los que se generan en CXC	*/
/*  14-Abril-2010 FLR	*/
INSERT INTO #MovsRM851
SELECT SubModulo = 'CXC', Mov, MovID, FechaEmision, Concepto, TipoConcepto= 'DEUDOR', Modulo='CXC', ClienteEnviarA,
Importe=Importe, Impuestos=Impuestos, Total=Importe+Impuestos, 
Financiamiento = Financiamiento, Capital=(Importe+Impuestos)-Financiamiento, C.Condicion, 
Meses = CASE WHEN ISNULL(CON.DANumeroDocumentos,0) > 12 THEN 1 ELSE 0 END
FROM dbo.Cxc C WITH (NOLOCK)
INNER JOIN dbo.Condicion CON WITH (NOLOCK) ON C.Condicion = CON.Condicion
WHERE Mov = 'Refinanciamiento'
AND C.Estatus = 'CONCLUIDO'
AND C.FechaEmision BETWEEN @FechaD AND @FechaA
GROUP BY Mov, MovID, FechaEmision, Concepto, ClienteEnviarA, Importe, Impuestos, Financiamiento, C.Condicion, DANumeroDocumentos

/*	03-Marzo-2010--> Para obtener solamente los productos de la Linea de Tiempo Aire*/
INSERT INTO #MovsRM851
SELECT SubModulo, Mov, MovID, FechaEmision, Conceptos, TipoConcepto, Modulo, Can, Importe=SUM(Importe), Impuestos=SUM(Impuestos), 
Total =  SUM(Importe) + SUM(Impuestos), Financiamiento, Capital, Condicion, Meses
FROM
(
	SELECT V.SubModulo, C.Mov, C.MovID, C.FechaEmision, Conceptos=A.Linea, TipoConcepto='DEUDOR', Modulo = 'VTAS', Can = V.EnviarA,
	Importe=((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0),
	Impuestos=ROUND((((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0))*(VD.Impuesto1/100),4),
	Financiamiento=0.0, Capital=0.0, C.Condicion, Meses = ISNULL(V.Mayor12Meses,0)
	FROM dbo.Cxc C WITH (NOLOCK)
	INNER JOIN dbo.Venta V WITH (NOLOCK) ON C.Origen=V.mov AND C.OrigenID=V.movid
	INNER JOIN dbo.VentaD VD WITH (NOLOCK) ON V.ID = VD.ID
	INNER JOIN dbo.Art A WITH (NOLOCK) ON VD.Articulo = A.Articulo
	WHERE C.Mov LIKE 'Factura%'
	AND A.Linea =  'TIEMPO AIRE'
	AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
	AND C.FechaEmision BETWEEN @FechaD AND @FechaA
) AS T
GROUP BY SubModulo, Mov, MovID, FechaEmision, Condicion, Conceptos, TipoConcepto, Modulo, Can, T.Financiamiento, T.Capital, Meses

/*	03-Marzo-2010--> Para obtener solamente los productos del Grupo de Productos Diversos*/
INSERT INTO #MovsRM851
SELECT SubModulo, Mov, MovID, FechaEmision, Conceptos, TipoConcepto, Modulo, Can, Importe=SUM(Importe), Impuestos=SUM(Impuestos), 
Total =  SUM(Importe) + SUM(Impuestos), Financiamiento, Capital, Condicion, Meses
FROM
(
	SELECT V.SubModulo, C.Mov, C.MovID, C.FechaEmision, Conceptos=A.Grupo, TipoConcepto='DEUDOR', Modulo = 'VTAS', Can = V.EnviarA,
	Importe=((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0),
	Impuestos=ROUND((((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0))*(VD.Impuesto1/100),4),
	Financiamiento=0.0, Capital=0.0, C.Condicion, Meses = ISNULL(V.Mayor12Meses,0)
	FROM dbo.Cxc C WITH (NOLOCK)
	INNER JOIN dbo.Venta V WITH (NOLOCK) ON C.Origen=V.mov AND C.OrigenID=V.movid
	INNER JOIN dbo.VentaD VD WITH (NOLOCK) ON V.ID = VD.ID
	INNER JOIN dbo.Art A WITH (NOLOCK) ON VD.Articulo = A.Articulo
	WHERE C.Mov LIKE 'Factura%'
	AND A.Grupo =  'PRODUCTOS DIVERSOS'
	AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
	AND C.FechaEmision BETWEEN @FechaD AND @FechaA
) AS T
GROUP BY SubModulo, Mov, MovID, FechaEmision, Condicion, Conceptos, TipoConcepto, Modulo, Can, T.Financiamiento, T.Capital, Meses

/*	03-Marzo-2010--> Para obtener solamente los productos de Seguro por entrega*/
INSERT INTO #MovsRM851
SELECT SubModulo, Mov, MovID, FechaEmision, Conceptos, TipoConcepto, Modulo, Can, Importe=SUM(Importe), Impuestos=SUM(Impuestos), 
Total =  SUM(Importe) + SUM(Impuestos), Financiamiento, Capital, Condicion, Meses
FROM
(
	SELECT V.SubModulo, C.Mov, C.MovID, C.FechaEmision, Conceptos='Seguro por entrega', TipoConcepto='DEUDOR', Modulo = 'VTAS', Can = V.EnviarA,
	Importe=((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0), 
	Impuestos=ROUND((((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0))*(VD.Impuesto1/100),4),
	Total = C.Importe + C.Impuestos,
	Financiamiento=0.0, Capital=0.0, C.Condicion, Meses = ISNULL(V.Mayor12Meses,0)
	FROM dbo.Cxc C WITH (NOLOCK)
	INNER JOIN dbo.Venta V WITH (NOLOCK) ON C.Origen=V.mov AND C.OrigenID=V.movid
	INNER JOIN dbo.VentaD VD WITH (NOLOCK) ON V.ID = VD.ID
	INNER JOIN dbo.Art A WITH (NOLOCK) ON VD.Articulo = A.Articulo
	WHERE C.Mov LIKE 'Factura%'
	AND A.Articulo LIKE 'SEGU%'
	AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
	AND C.FechaEmision BETWEEN @FechaD AND @FechaA
) AS T
GROUP BY SubModulo, Mov, MovID, FechaEmision, Condicion, Conceptos, TipoConcepto, Modulo, Can, T.Financiamiento, T.Capital, Meses

/*	03-Marzo-2010--> Para obtener solamente los productos de la Categoria de Activos Fijos	*/
INSERT INTO #MovsRM851
SELECT SubModulo, Mov, MovID, FechaEmision, Conceptos, TipoConcepto, Modulo, Can, Importe=SUM(Importe), Impuestos=SUM(Impuestos), 
Total =  SUM(Importe) + SUM(Impuestos),
Financiamiento, Capital, Condicion, Meses
FROM
(
	SELECT V.SubModulo, C.Mov, C.MovID, C.FechaEmision, Conceptos=A.Categoria, TipoConcepto='DEUDOR', Modulo = 'VTAS', Can = V.EnviarA,
	Importe=((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0),
	Impuestos=ROUND((((VD.Precio*VD.Cantidad)/(1+(VD.Impuesto1/100)))-ISNULL(VD.DescuentoLinea,0.0))*(VD.Impuesto1/100),4),
	Financiamiento=0.0, Capital=0.0, C.Condicion, Meses = ISNULL(V.Mayor12Meses,0)
	FROM dbo.Cxc C WITH (NOLOCK)
	INNER JOIN dbo.Venta V WITH (NOLOCK) ON C.Origen=V.mov AND C.OrigenID=V.movid
	INNER JOIN dbo.VentaD VD WITH (NOLOCK) ON V.ID = VD.ID
	INNER JOIN dbo.Art A WITH (NOLOCK) ON VD.Articulo = A.Articulo
	WHERE C.Mov LIKE 'Factura Mayoreo'
	AND A.Categoria = 'ACTIVOS FIJOS'
	AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
	AND C.FechaEmision BETWEEN @FechaD AND @FechaA
) AS T
GROUP BY SubModulo, Mov, MovID, FechaEmision, Condicion, Conceptos, TipoConcepto, Modulo, Can, T.Financiamiento, T.Capital, Meses

/*	Para movimietos de : Ajuste, Ajuste Redondeo, Cheque Devuelto, Notas de Cargo, Apartado		*/
INSERT INTO #MovsRM851
SELECT * FROM (
	SELECT 
	ISNULL(Cx.OrigenTipo,'CXC') AS OrigenTipo,Cx.Mov,Cx.Movid,Cx.FechaEmision,
	Concepto= CASE WHEN Cx.Mov IN('Ajuste','Ajuste Redondeo') THEN 'AJUSTE'
			   WHEN Cx.Mov in ('Nota Cargo','Nota Cargo VIU') AND Cx.Concepto = 'GTOS DE LOCALIZACION' THEN 'GASTOS LOCALIZACION'
			   WHEN Cx.Mov in ('Nota Cargo','Nota Cargo VIU') AND Cx.Concepto = 'GTOS ADJUDICACION' THEN 'GASTOS ADJUDICACION'
			   WHEN Cx.Mov in ('Nota Cargo','Nota Cargo VIU') AND Cx.Concepto = 'GTOS ADMVOS / CANCELA' THEN 'GASTOS ADMVOS/CANCELACION'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto = 'COM CHEQUE DEVUELTO' THEN 'COMIS CHEQUE DEVUELTO'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto = 'CANC BONIF MENUDEO' THEN 'CANC BONIFICACION MENUDEO'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto = 'CANC BONIF MAYOREO' THEN 'CANC BONIFICACION MAYOREO'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto = 'CANC BONIF MAYOREO 2' THEN 'CANC BONIFICACION MAYOREO 2'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto = 'INTERESES P.F. Y P.M.' THEN 'INTS P.F. Y P.M.'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto LIKE 'MORATORIOS M%' THEN 'INTERESES MORATORIOS'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto IN ('CANC COBRO FACTURA','CANC COBRO FACTURA VIU','CANC COBRO MAYOREO') THEN 'CANC COBRO FACTURAS'
			   WHEN Cx.Mov LIKE 'Nota Cargo%' AND Cx.Concepto = ('CANC COBRO CRED Y PP') THEN 'CANC COBRO CRED Y PP'
			   WHEN Cx.Mov = 'Apartado' THEN 'ANTICIPOS'
			   ELSE ISNULL(Cx.Concepto,UPPER(Cx.Mov)) END,
	Tipoconcepto=CASE WHEN Cx.Mov IN ('Nota Cargo','Nota Cargo Mayoreo','Nota Cargo VIU','Cheque Devuelto','Devolucion Apartado', 'Dev Anticipo Mayoreo') THEN 'DEUDOR'
					  WHEN Cx.Mov = 'Apartado' THEN 'ACREEDOR'
					  WHEN Cx.Mov = 'Ajuste' AND Ajuste.TipoMov = 'Saldos Rojos' THEN 'ACREEDOR'
					  WHEN Cx.Mov = 'Ajuste' AND Ajuste.TipoMov = 'Saldos Negros' THEN 'DEUDOR'
					  WHEN Cx.Mov = 'Ajuste Redondeo' AND Ajuste.TipoMov = 'Saldos Rojos' THEN 'ACREEDOR'
					  WHEN Cx.Mov = 'Ajuste Redondeo' AND Ajuste.TipoMov = 'Saldos Negros' THEN 'DEUDOR'
					  END,
	Modulo='CXC', Cx.ClienteEnviarA AS Can, 
	Importe=CASE WHEN Cx.Mov IN ('Cheque Devuelto') THEN Cx.Importe
				 WHEN Cx.Mov IN ('Ajuste','Ajuste Redondeo') THEN Ajuste.Imp ELSE ISNULL(Cx.Importe,0) END,
	Impuestos = Cx.Impuestos,
	Total = Cx.Importe + Cx.Impuestos, 
	Financiamiento=0.0, Capital = 0.0, Cx.Condicion,
	Meses = 0
	FROM CXC Cx WITH (NOLOCK)
	INNER JOIN Cte WITH (NOLOCK) ON Cx.cliente = Cte.Cliente
	LEFT JOIN (
		SELECT Mov,Movid,CASE WHEN Importe < 0 THEN 'Saldos Rojos' ELSE 'Saldos Negros' END AS TipoMov, SUM(importe)AS Imp
		FROM cxc WITH (NOLOCK) WHERE mov IN ('Ajuste','Ajuste Redondeo') 
		GROUP BY Mov,Movid,Importe 
	) AS Ajuste ON Cx.Mov = Ajuste.Mov AND Cx.MovID = Ajuste.MovID
	WHERE (Cx.Mov IN ('Ajuste','Apartado','Ajuste Redondeo','Cheque Devuelto')
	AND Cx.Estatus IN ( 'PENDIENTE','CONCLUIDO')
	OR (Cx.Mov LIKE 'Nota Cargo%' And Cx.Estatus IN ( 'PENDIENTE','CONCLUIDO') )
	) AND CX.FECHAEMISION BETWEEN @FechaD AND @FechaA
) AS Todo2

/*	Para las Notas de Credito que tienen Detalle de Documentos y aplicaciones con detalle de Movimientos	*/
INSERT INTO #MovsRM851
SELECT 
Cx.OrigenTipo, Cx.Mov, Cx.MovID, Cx.FechaEmision,
Concepto= CASE 
		WHEN Cx.Mov IN ('Nota Credito','Nota Credito VIU')
			AND (Cx.Concepto LIKE 'Bonif%' OR Cx.Concepto IN ('ADJUDICACION 1 A 12', 'OK ADJUDICACION 1 A 12', 'PUNTOS ELECTRONICOS', 'ADJUDICACION + DE 12', 'OK ADJUDICACION + DE 12') ) 
			AND NOT (Cx.Categoria = 'CONTADO' ) AND ISNULL(Cx.Mayor12Meses,0) = 0
			AND Cx.Categoria IN ('CREDITO MENUDEO','ASOCIADOS','INSTITUCIONES')
				THEN 'BONIF. S/VENTAS DE 1 A 12 MESES'
		WHEN Cx.Mov IN ('Nota Credito','Nota Credito VIU')
			AND (Cx.Concepto LIKE 'Bonif%' OR Cx.Concepto IN ('ADJUDICACION 1 A 12', 'OK ADJUDICACION 1 A 12', 'PUNTOS ELECTRONICOS', 'ADJUDICACION + DE 12', 'OK ADJUDICACION + DE 12') ) 
			AND NOT (Cx.Categoria = 'CONTADO' ) AND ISNULL(Cx.Mayor12Meses,0) = 1
			AND Cx.Categoria IN ('CREDITO MENUDEO','ASOCIADOS','INSTITUCIONES')
				THEN 'BONIF. S/VENTAS DE + DE 12 MESES'
		WHEN Cx.Mov IN ('Nota Credito','Nota Credito VIU')
			AND (Cx.Concepto LIKE 'Bonif%' OR Cx.Concepto IN ('ADJUDICACION 1 A 12', 'OK ADJUDICACION 1 A 12', 'PUNTOS ELECTRONICOS', 'ADJUDICACION + DE 12', 'OK ADJUDICACION + DE 12') )
			AND (Cx.Categoria = 'CONTADO' )
				THEN 'BONIF. CONTADO'
		WHEN Cx.Mov IN ('Nota Credito','Nota Credito VIU') 
			AND Cx.Concepto IN ('CANC GTOS ADJUDICACION','CANC GTOS LOCALIZACION','CANC COM CHEQUE DEVUELTO','CONDONACION GTOS CANC','ENDOSO FACTURA') 
				THEN Cx.Concepto
		WHEN Cx.Mov = 'Nota Credito Mayoreo' AND Cx.Concepto IN ('BONIFICACION MAYOREO','BONIFICACION MAYOREO 2') THEN Cx.Concepto
		WHEN Cx.Mov LIKE 'Nota Credito%' AND Cx.Concepto = 'INCOBRABLE 1 A 12' THEN 'INCOBRABLES DE 1 A 12 MS'
		WHEN Cx.Mov LIKE 'Nota Credito%' AND Cx.Concepto = 'INCOBRABLE + DE 12' THEN 'INCOBRABLES DE + DE 12 MS'
		WHEN Cx.Mov LIKE 'Nota Credito%' AND Cx.Concepto IN ('CANC MORATORIOS MENUDEO','CANC MORATORIOS MAYOREO') THEN 'CANC MORATORIOS'
		WHEN Cx.Mov LIKE 'Nota Credito%' AND Cx.Concepto IN ('CORR COBRO FACTURA','CORR COBRO FACTURA VIU','CORR COBRO MAYOREO') THEN 'CORREC COBROS FACTURAS'
		WHEN Cx.Mov LIKE 'Nota Credito%' AND Cx.Concepto = 'REFINANCIAMIENTO' THEN 'REFINANCIAMIENTO FACTURAS'
		ELSE ISNULL(Cx.Concepto,UPPER(Cx.Mov)) 
		END,
Tipoconcepto=CASE 
		WHEN Cx.Mov LIKE 'Nota Credito%' AND Cx.Concepto <> 'CANCELACION CREDILANA/PP' THEN 'ACREEDOR'
		END,
Modulo='CXC', Cx.ClienteEnviarA AS Can,
Importe = ISNULL(Cx.Importe,0.0),
Impuestos = ISNULL(Cx.Impuestos,0.0),
Total = Cx.Importe + Cx.Impuestos,
Financiamiento=0.0, Capital = 0.0, Cx.Condicion,
Meses = Cx.Mayor12Meses
FROM 
(
	SELECT OrigenTipo, Mov, MovID, FechaEmision, Concepto, ClienteEnviarA, Importe, Impuestos, 
	Mayor12Meses, Categoria, Condicion
	FROM
	(
		SELECT ISNULL(C.OrigenTipo,'CXC') AS OrigenTipo, C.Mov, C.MovID, C.FechaEmision, C.Concepto, C.ClienteEnviarA, 
		C.Importe, C.Impuestos, NCB.Mayor12Meses, VCM.Categoria, C.Condicion, 
		MovOrigen = ISNULL(CO.Origen,CD.Aplica)
		FROM dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
		INNER JOIN dbo.Cxc CO WITH (NOLOCK) ON CD.Aplica = CO.Mov AND CD.AplicaID = CO.MovID
		INNER JOIN Cte WITH (NOLOCK) ON C.cliente = Cte.Cliente
		LEFT JOIN dbo.VentasCanalMAVI VCM WITH (NOLOCK) ON CO.ClienteEnviarA = VCM.ID
		LEFT JOIN (
			SELECT C.ID, C.Mov, C.MovID, CO.Mayor12Meses
			FROM dbo.Cxc C WITH (NOLOCK)
			LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
			LEFT JOIN dbo.Cxc CO WITH (NOLOCK) ON CD.Aplica=CO.Mov AND CD.AplicaID=CO.MovID
			WHERE C.Mov LIKE 'Nota Credito%'
			AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
			AND (CD.Aplica LIKE 'Factura%' OR CD.Aplica = 'Documento')
			AND C.FechaEmision BETWEEN @FechaD AND @FechaA
			GROUP BY C.ID, C.Mov, C.MovID, CO.Mayor12Meses
		) AS NCB ON C.ID=NCB.ID
		WHERE (
		(C.Mov LIKE 'Nota Credito%' AND (C.OrigenTipo <> 'VTAS' OR C.OrigenTipo IS NULL) AND C.Estatus IN ( 'PENDIENTE','CONCLUIDO') )
		OR (C.Mov LIKE 'Nota Credito%' AND C.Concepto IN('BONIFICACION MAYOREO','BONIFICACION MAYOREO 2') AND C.Estatus IN ( 'PENDIENTE','CONCLUIDO') )
		)
		AND (CD.Aplica LIKE 'Factura%' OR CD.Aplica = 'Documento')
		AND ISNULL(C.OrigenTipo,'') <> 'VTAS'
		AND C.FechaEmision BETWEEN @FechaD AND @FechaA
	) AS NC
	GROUP BY OrigenTipo, Mov, MovID, FechaEmision, Concepto, ClienteEnviarA, Importe, Impuestos, 
	Mayor12Meses, Categoria, Condicion

	UNION ALL

	SELECT OrigenTipo, Origen, OrigenID, FechaEmision, Concepto, ClienteEnviarA, 
	Importe = SUM(Importe), Impuestos = SUM(Impuestos), Mayor12Meses, Categoria, Condicion
	FROM
	(
		SELECT ISNULL(CO.OrigenTipo,'CXC') AS OrigenTipo, C.Origen, C.OrigenID, C.FechaEmision, CO.Concepto, C.ClienteEnviarA,
		Importe = CD.Importe-(CD.Importe*C.IVAFiscal), 
		Impuestos = CD.Importe*C.IVAFiscal, 
		NCB.Mayor12Meses, VCM.Categoria, CO.Condicion,
		MovOrigen = ISNULL(MO.Origen,CD.Aplica)
		FROM dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
		INNER JOIN Cte WITH (NOLOCK) ON C.cliente = Cte.Cliente
		INNER JOIN dbo.Cxc CO WITH (NOLOCK) ON C.Origen = CO.Mov AND C.OrigenID = CO.MovID
		INNER JOIN dbo.Cxc MO WITH (NOLOCK) ON CD.Aplica = MO.Mov AND CD.AplicaID = MO.MovID
		LEFT JOIN dbo.VentasCanalMAVI VCM WITH (NOLOCK) ON MO.ClienteEnviarA = VCM.ID
		LEFT JOIN (
			SELECT C.ID, C.Mov, C.MovID, CO.Mayor12Meses
			FROM dbo.Cxc C WITH (NOLOCK)
			LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
			LEFT JOIN dbo.Cxc CO WITH (NOLOCK) ON CD.Aplica=CO.Mov AND CD.AplicaID=CO.MovID
			LEFT JOIN dbo.Cxc CA WITH (NOLOCK) ON C.Origen = CA.Mov AND C.OrigenID = CA.MovID
			WHERE C.Mov = 'Aplicacion'
			AND C.Origen LIKE 'Nota Credito%'
			AND (CD.Aplica LIKE 'Factura%' OR CD.Aplica = 'Documento')
			AND C.Estatus = 'CONCLUIDO'
			AND CD.AplicaID IS NOT NULL
			AND CA.FechaEmision BETWEEN @FechaD AND @FechaA
			GROUP BY C.ID, C.Mov, C.MovID, CO.Mayor12Meses
		) AS NCB ON C.ID=NCB.ID
		WHERE C.Mov = 'Aplicacion'
		AND C.Origen LIKE 'Nota Credito%'
		AND C.Estatus = 'CONCLUIDO'
		AND (CD.Aplica LIKE 'Factura%' OR CD.Aplica = 'Documento')
		AND ISNULL(CO.OrigenTipo,'') <> 'VTAS'
		AND CO.FechaEmision BETWEEN @FechaD AND @FechaA
	) AS AP
	GROUP BY OrigenTipo, Origen, OrigenID, FechaEmision, Concepto, ClienteEnviarA, Importe, 
	Impuestos, Mayor12Meses, Categoria, Condicion
) AS Cx

/*	Para Movimientos de Notas de Credito que estan pendientes y no tienen Detalle*/
INSERT INTO #MovsRM851
SELECT OrigenTipo,C.Mov, C.MovID, C.FechaEmision,
Concepto = CASE WHEN C.Mov IN ('Nota Credito','Nota Credito VIU') 
			AND C.Concepto IN ('CANC GTOS ADJUDICACION','CANC GTOS LOCALIZACION','CANC COM CHEQUE DEVUELTO','CONDONACION GTOS CANC','ENDOSO FACTURA') 
				THEN C.Concepto
		WHEN C.Mov = 'Nota Credito Mayoreo' AND C.Concepto IN ('BONIFICACION MAYOREO','BONIFICACION MAYOREO 2') THEN C.Concepto
		WHEN C.Mov LIKE 'Nota Credito%' AND C.Concepto = 'INCOBRABLE 1 A 12' THEN 'INCOBRABLES DE 1 A 12 MS'
		WHEN C.Mov LIKE 'Nota Credito%' AND C.Concepto = 'INCOBRABLE + DE 12' THEN 'INCOBRABLES DE + DE 12 MS'
		WHEN C.Mov LIKE 'Nota Credito%' AND C.Concepto IN ('CANC MORATORIOS MENUDEO','CANC MORATORIOS MAYOREO') THEN 'CANC MORATORIOS'
		WHEN C.Mov LIKE 'Nota Credito%' AND C.Concepto IN ('CORR COBRO FACTURA','CORR COBRO FACTURA VIU','CORR COBRO MAYOREO') THEN 'CORREC COBROS FACTURAS'
		ELSE C.Concepto END,
TipoConcepto = 'ACREEDOR',Modulo='CXC', Can=255,
Importe = C.Importe,
Impuesto = C.Impuestos,
Total = C.Importe + C.Impuestos,
Financiamiento=NULL,Capital=NULL,Condicion='FECHA',Meses=0
FROM dbo.Cxc C WITH (NOLOCK)
LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
WHERE ( C.Mov LIKE 'Nota Credito%' OR C.Mov LIKE 'Cancela %' )
AND c.estatus = 'PENDIENTE' 
AND ISNULL(C.OrigenTipo,'') <> 'VTAS'
AND CD.Aplica IS NULL
AND C.FechaEmision BETWEEN @FechaD AND @FechaA

/*	Para las Cancelaciones de Prestamos	que no devuleven efectivo*/
INSERT INTO #MovsRM851
SELECT
OrigenTipo, Mov, MovID, FechaEmision,
Concepto= CASE
		WHEN Concepto IN('ADJ CREDILANA/PP + DE 12','OK ADJ CREDILANA/PP + DE 12') THEN 'ADJ CREDILANA/PP'
		WHEN Concepto IN('BONIF ADELANTO EN PAGOS','BONIF PAGO PUNTUAL') THEN 'BONIF CREDILANA/PP'
		WHEN Concepto IN ('INCOBRABLE CREDILANA/PP','CANCELACION CREDILANA/PP') THEN Concepto
		WHEN Mov = 'Cancela Credilana' AND Concepto = 'CORR COBRO CRED Y PP' THEN 'CORREC COBRO CREDILANA'
		WHEN Mov = 'Cancela Prestamo' AND Concepto = 'CORR COBRO CRED Y PP' THEN 'CORREC COBRO PP'
		WHEN Concepto = 'ENDOSO CREDILANA' THEN 'ENDOSO CRED/PP'
		WHEN Concepto = 'REFINANCIAMIENTO' THEN 'REFINANCIAMIENTO CRED/PP'
		ELSE ISNULL(Concepto,UPPER(Mov)) END,
Tipoconcepto= 'ACREEDOR',
Modulo='CXC', Can,
Importe = ISNULL(NetoTotal,0),
Impuestos = IVATotal,
Total = TotalMov,
Financiamiento=ISNULL(TotalFin,0.0), Capital = ISNULL(TotalCap,0.0), Condicion,
Meses = 0
FROM 
(
	SELECT Origen, OrigenID, Mov, MovID, NetoTotal=SUM(Importe), FechaEmision, OrigenTipo, Concepto, Can, Condicion,
	TotalMov=SUM(Importe)+SUM(IVAFin), TotalFin=SUM(Financiamiento), TotalCap=SUM(Capital), IVATotal=SUM(IVAFin),
	Categoria
	FROM (
		/*	Para los movimientos de Aplicacion	*/
		SELECT
			C.Origen, C.OrigenID, CD.Aplica, CD.APlicaID, Mov=C.Origen, MovID=C.OrigenId, VCM.Categoria, C.Condicion,
			OrigenTipo=ISNULL(C.OrigenTipo,'CXC'), CO.Concepto, C.ClienteEnviarA AS Can, C.FechaEmision,
			Importe = CD.Importe-(ISNULL(CD.Importe,0.0)*C2.IVAFiscal),
			IVAFin=ISNULL(CD.Importe,0.0)*C2.IVAFiscal,
			PorcFin=(C3.Financiamiento/(C3.Importe+C3.Impuestos)) * 100,
			Financiamiento=(CD.Importe*((C3.Financiamiento/(C3.Importe+C3.Impuestos)) * 100) ) / 100,
			Capital=CD.Importe - ( (CD.Importe*((C3.Financiamiento/(C3.Importe+C3.Impuestos)) * 100) ) / 100 )
		FROM
			dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID=CD.ID
		INNER JOIN Cte WITH (NOLOCK) ON C.cliente = Cte.Cliente
		INNER JOIN dbo.Cxc CO WITH (NOLOCK) ON C.Origen = CO.Mov AND C.OrigenID = CO.MovID
		INNER JOIN dbo.Cxc C2 WITH (NOLOCK) ON CD.Aplica=C2.Mov AND CD.AplicaID=C2.MovID
		INNER JOIN dbo.Cxc C3 WITH (NOLOCK) ON C2.Origen=C3.Mov AND C2.OrigenID=C3.MovId
		INNER JOIN dbo.VentasCanalMAVI VCM ON C3.ClienteEnviarA = VCM.ID
		WHERE C.Mov='Aplicacion'
			And C.Estatus ='CONCLUIDO'
			AND C.Origen IN ('Cancela Credilana','Cancela Prestamo')
			AND CO.FechaEmision BETWEEN @FechaD AND @FechaA
		UNION ALL
		/*	Para los movimientos de Cancelaciones de Prestamos con Aplicacion Manual	*/
		SELECT 
			Origen=ISNULL(C.Origen,C.Mov), OrigenID=ISNULL(C.OrigenID,C.MovID), Aplica, AplicaID, 
			C.Mov, C.MovID, VCM.Categoria, C.Condicion,
			OrigenTipo=ISNULL(C.OrigenTipo,'CXC'), C.Concepto, C.ClienteEnviarA AS Can, C.FechaEmision,
			Importe = CD.Importe - ( ISNULL(CD.Importe,0.0)*CA.IVAFiscal ),
			IVAFin = ISNULL(CD.Importe,0.0) * CA.IVAFiscal,
			PorcFin = (CP.Financiamiento/(CP.Importe+CP.Impuestos)) * 100,
			Financiamiento = (CD.Importe*((CP.Financiamiento/(CP.Importe+CP.Impuestos)) * 100) ) / 100,
			Capital=CD.Importe - ( (CD.Importe*((CP.Financiamiento/(CP.Importe+CP.Impuestos)) * 100) ) / 100 )
		FROM
			dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
		INNER JOIN dbo.Cxc CA WITH (NOLOCK) ON CD.Aplica = CA.Mov AND CD.AplicaID = CA.MovID
		INNER JOIN dbo.Cxc CP WITH (NOLOCK) ON CA.Origen = CP.Mov AND CA.OrigenID = CP.MovID
		INNER JOIN dbo.VentasCanalMAVI VCM ON CP.ClienteEnviarA = VCM.ID
		WHERE (C.Mov IN ('Cancela Credilana','Cancela Prestamo') OR (C.Mov LIKE 'Nota Credito%' AND C.Concepto = 'Refinanciamiento') )
			AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
			AND cd.AplicaID IS NOT NULL
			AND C.FechaEmision BETWEEN @FechaD AND @FechaA
	) AS CR
	GROUP BY Origen, OrigenID, Mov, MovID, Categoria, FechaEmision, OrigenTipo, Concepto, Can, Condicion
) AS CanCred
WHERE Mov IN ('Cancela Credilana','Cancela Prestamo')

/*	Cancelacion de Seguros de Vida y Seguros de Auto.			*/
INSERT INTO #MovsRM851
SELECT
Cx.OrigenTipo, Cx.Mov, Cx.MovID, Cx.FechaEmision,
Concepto= CASE 
		WHEN Cx.Concepto IN ('CANC COBRO SEG AUTO','CANC COBRO SEG VIDA','CORR COBRO SEG VIDA','CORR COBRO SEG AUTO') THEN UPPER(Cx.Concepto)
		ELSE ISNULL(Cx.Concepto,UPPER(Cx.Mov)) 
		END,
Tipoconcepto='ACREEDOR',
Modulo='CXC', Cx.ClienteEnviarA AS Can,
Importe = ISNULL(Cx.Importe,0)+Cx.Impuestos,
Impuestos = 0.0,
Total = Cx.Importe + Cx.Impuestos,
Financiamiento=0.0, Capital = 0.0, Cx.Condicion,
Meses = 0
FROM 
( 
	SELECT OrigenTipo, Mov, MovID, FechaEmision, Concepto, ClienteEnviarA, Importe, Impuestos, 
	Mayor12Meses, Categoria, Condicion
	FROM
	(
		SELECT ISNULL(C.OrigenTipo,'CXC') AS OrigenTipo, C.Mov, C.MovID, C.FechaEmision, C.Concepto, C.ClienteEnviarA, 
		C.Importe, C.Impuestos, NCB.Mayor12Meses, NCB.Categoria, C.Condicion, 
		MovOrigen = ISNULL(CO.Origen,CD.Aplica)
		FROM dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
		INNER JOIN dbo.Cxc CO WITH (NOLOCK) ON CD.Aplica = CO.Mov AND CD.AplicaID = CO.MovID
		INNER JOIN Cte WITH (NOLOCK) ON C.cliente = Cte.Cliente
		LEFT JOIN (
			SELECT C.ID, C.Mov, C.MovID, CO.Mayor12Meses, VCM.Categoria
			FROM dbo.Cxc C WITH (NOLOCK)
			LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
			LEFT JOIN dbo.Cxc CO WITH (NOLOCK) ON CD.Aplica=CO.Mov AND CD.AplicaID=CO.MovID
			LEFT JOIN dbo.VentasCanalMAVI VCM WITH (NOLOCK) ON CO.ClienteEnviarA = VCM.ID
			WHERE C.Mov LIKE 'Cancela Seg%'
			AND C.Estatus IN ('PENDIENTE','CONCLUIDO')
			AND (CD.Aplica LIKE 'Seguro%' OR CD.Aplica = 'Documento')
			AND C.FechaEmision BETWEEN @FechaD AND @FechaA
			GROUP BY C.ID, C.Mov, C.MovID, CO.Mayor12Meses, VCM.Categoria
		) AS NCB ON C.ID=NCB.ID
		WHERE 
		C.Mov LIKE 'Cancela Seg%'
		AND (CD.Aplica LIKE 'Cancela Seg%' OR CD.Aplica = 'Documento')
		AND C.FechaEmision BETWEEN @FechaD AND @FechaA
	) AS NC
	GROUP BY OrigenTipo, Mov, MovID, FechaEmision, Concepto, ClienteEnviarA, Importe, Impuestos, 
	Mayor12Meses, Categoria, Condicion

	UNION ALL

	SELECT OrigenTipo, Origen, OrigenID, FechaEmision, Concepto, ClienteEnviarA, Importe, Impuestos, Mayor12Meses, Categoria, Condicion
	FROM
	(
		SELECT ISNULL(C.OrigenTipo,'CXC') AS OrigenTipo, C.Origen, C.OrigenID, C.FechaEmision, CO.Concepto, C.ClienteEnviarA,
		CO.Importe, CO.Impuestos, NCB.Mayor12Meses, NCB.Categoria, CO.Condicion,
		MovOrigen = ISNULL(MO.Origen,CD.Aplica)
		FROM dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
		INNER JOIN Cte WITH (NOLOCK) ON C.cliente = Cte.Cliente
		INNER JOIN dbo.Cxc CO WITH (NOLOCK) ON C.Origen = CO.Mov AND C.OrigenID = CO.MovID
		INNER JOIN dbo.Cxc MO WITH (NOLOCK) ON CD.Aplica = MO.Mov AND CD.AplicaID = MO.MovID
		LEFT JOIN (
			SELECT C.ID, C.Mov, C.MovID, CO.Mayor12Meses, VCM.Categoria
			FROM dbo.Cxc C WITH (NOLOCK)
			LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
			LEFT JOIN dbo.Cxc CA WITH (NOLOCK) ON C.Origen = CA.Mov AND C.OrigenID = CA.MovID
			LEFT JOIN dbo.Cxc CO WITH (NOLOCK) ON CD.Aplica=CO.Mov AND CD.AplicaID=CO.MovID
			LEFT JOIN dbo.Cxc CP WITH (NOLOCK) ON CO.Origen = CP.Mov AND CO.OrigenID = CP.MovID
			LEFT JOIN dbo.VentasCanalMAVI VCM ON CO.ClienteEnviarA = VCM.ID
			WHERE C.Mov = 'Aplicacion'
			AND C.Origen LIKE 'Cancela Seg%'
			AND (CD.Aplica LIKE 'Seguro%' OR CD.Aplica = 'Documento')
			AND C.Estatus = 'CONCLUIDO'
			AND CD.AplicaID IS NOT NULL
			AND CA.FechaEmision BETWEEN @FechaD AND @FechaA
			GROUP BY C.ID, C.Mov, C.MovID, CO.Mayor12Meses, VCM.Categoria, CD.Aplica, CD.AplicaID
		) AS NCB ON C.ID=NCB.ID
		WHERE C.Mov = 'Aplicacion'
		AND C.Origen LIKE 'Cancela Seg%'
		AND C.Estatus = 'CONCLUIDO'
		AND (CD.Aplica LIKE 'Seguro%' OR CD.Aplica = 'Documento')
		AND CO.FechaEmision BETWEEN @FechaD AND @FechaA
	) AS AP
	GROUP BY OrigenTipo, Origen, OrigenID, FechaEmision, Concepto, ClienteEnviarA, Importe, 
	Impuestos, Mayor12Meses, Categoria, Condicion
) AS Cx

/*	PARA LOS MOVIMIENTOS "DEVOLUCION" de Notas de Credito que juegan para DEVOLUCION DE EFECT FACTURAS	*/
INSERT INTO #MovsRM851
SELECT OrigenTipo = 'CXC',C.Mov, C.MovID, C.FechaEmision,
Concepto = 'DEVOLUCION DE EFECT FACTURAS',
TipoConcepto = 'DEUDOR',Modulo='CXC', Can=0,
Importe = CD.Importe-(CD.Importe*CA.IvaFiscal),
Impuesto = CD.Importe*CA.IvaFiscal,
Total = CD.Importe,
Financiamiento=NULL,Capital=NULL,Condicion='FECHA',Meses=0
FROM dbo.Cxc C WITH (NOLOCK)
INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
LEFT JOIN dbo.Cxc CA WITH (NOLOCK) ON CD.Aplica=CA.Mov AND CD.AplicaID=CA.MovID
WHERE C.Mov='Devolucion' AND c.estatus='CONCLUIDO' 
AND C.Origen LIKE 'Nota Credito%'
AND C.FechaEmision BETWEEN @FechaD AND @FechaA

/*	Movimientos de Cancelaciones de Seguros Auto y Vida que estan pendientes y que vienen de una devolucion de Venta solamente.	*/
INSERT INTO #MovsRM851
SELECT C.OrigenTipo, C.Mov, C.MovID, C.FechaEmision, 
Concepto = ISNULL(C.Concepto,C.Mov),
TipoConcepto = 'ACREEDOR',
Modulo = 'CXC',
Can = MPV.EnviarA, C.Importe, C.Impuestos, Total = C.Importe + C.Impuestos,
Financiamiento = NULL, Capital = NULL, C.Condicion, Meses = 0
FROM 
	dbo.Cxc C WITH (NOLOCK)
LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
LEFT JOIN dbo.Venta V WITH (NOLOCK) ON C.Origen = V.Mov AND C.OrigenID = V.MovID
INNER JOIN (
	SELECT VD.ID,
	IDCopiaMAVI = CASE WHEN Aplica = 'Sol Dev Unicaja' THEN SUBSTRING(Valor,(CHARINDEX('_',Valor,1))+1,LEN(Valor))
					ELSE IDCopiaMAVI END,
	Aplica,AplicaID
	FROM dbo.VentaD VD WITH (NOLOCK)
	LEFT JOIN MovCampoExtra MCE WITH (NOLOCK) ON VD.ID = MCE.ID
) VD ON V.ID = VD.ID
INNER JOIN dbo.Venta MPV WITH (NOLOCK) ON VD.IDCopiaMAVI = MPV.ID
WHERE C.Mov IN ( 'Cancela Seg Vida','Cancela Seg Auto' )
AND C.Estatus = 'PENDIENTE'
AND C.OrigenTipo = 'VTAS'
AND CD.Aplica IS NULL
AND VD.IDCopiaMAVI IS NOT NULL
AND C.FechaEmision BETWEEN @FechaD AND @FechaA

/*	Movimientos de Cancelaciones de Prestamos que estan pendientes y que vienen de una devolucion de Venta solamente.	*/
INSERT INTO #MovsRM851
SELECT C.OrigenTipo, C.Mov, C.MovID, C.FechaEmision, C.Concepto,
TipoConcepto = 'ACREEDOR', Modulo = 'CXC', Can = MPV.EnviarA,
C.Importe, C.Impuestos, Total = C.Importe + C.Impuestos,
Finaciamiento = ( ( C.Importe + C.Impuestos ) * ( (CP.Financiamiento/(CP.Importe+CP.Impuestos))*100 ) )/100,
Capital = ( C.Importe + C.Impuestos ) - ( ( ( C.Importe + C.Impuestos ) * ( (CP.Financiamiento/(CP.Importe+CP.Impuestos))*100 ) )/100 ),
C.Condicion, Meses = 0
FROM 
	dbo.Cxc C WITH (NOLOCK)
LEFT JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
LEFT JOIN dbo.Venta V WITH (NOLOCK) ON C.Origen = V.Mov AND C.OrigenID = V.MovID
INNER JOIN (
	SELECT VD.ID,
	IDCopiaMAVI = CASE WHEN Aplica = 'Sol Dev Unicaja' THEN SUBSTRING(Valor,(CHARINDEX('_',Valor,1))+1,LEN(Valor))
					ELSE IDCopiaMAVI END,
	Aplica,AplicaID
	FROM dbo.VentaD VD WITH (NOLOCK)
	LEFT JOIN MovCampoExtra MCE WITH (NOLOCK) ON VD.ID = MCE.ID
) VD ON V.ID = VD.ID
INNER JOIN dbo.Venta MPV WITH (NOLOCK) ON VD.IDCopiaMAVI = MPV.ID
INNER JOIN dbo.Cxc CP WITH (NOLOCK) ON MPV.Mov = CP.Mov AND MPV.MovID = CP.MovID
WHERE C.Mov IN ( 'Cancela Credilana','Cancela Prestamo' )
AND C.Estatus = 'PENDIENTE'
AND C.OrigenTipo = 'VTAS'
AND CD.Aplica IS NULL
AND VD.IDCopiaMAVI IS NOT NULL
AND C.FechaEmision BETWEEN @FechaD AND @FechaA

/*	PARA LOS MOVIMIENTOS: Enganche, Devolucion Enganche, Anticipo Contado, Dev Anticipo Contado, Anticipo Mayoreo, Dev Anticipo Contado, Dev Anticipo Mayoreo	*/
INSERT INTO #MovsRM851
SELECT
	OrigenTipo = 'CXC', Mov, Movid, FechaEmision, 
	Concepto=CASE WHEN Mov IN ('Devolucion Enganche', 'Dev Anticipo Contado', 'Dev Anticipo Mayoreo') THEN 'DEVOLUCION ANTICIPOS'
				WHEN Mov IN ('Anticipo Contado', 'Anticipo Mayoreo', 'Enganche') THEN 'ANTICIPOS'
			 ELSE UPPER(Mov) END,
	TipoConcepto = CASE WHEN mov IN ( 'Devolucion Enganche', 'Dev Anticipo Contado', 'Dev Anticipo Mayoreo' ) THEN 'DEUDOR'
						ELSE 'ACREEDOR'
				   END,
	Modulo = 'CXC', Can = 0, Importe, Impuestos, Total = Importe + Impuestos, Financiamiento = NULL, Capital = NULL, Condicion = 'FECHA',
	Meses = 0
FROM
	CXC WITH (NOLOCK)
WHERE
	mov IN ( 'Enganche', 'Devolucion Enganche', 'Anticipo Contado', 'Dev Anticipo Contado', 'Anticipo Mayoreo', 'Dev Anticipo Contado',
			 'Dev Anticipo Mayoreo' )
	AND Estatus = 'CONCLUIDO'					                                                                                     
	AND FechaEmision BETWEEN @FechaD AND @FechaA

/*	PARA LOS MOVIMIENTOS "COBRO" A FACTURAS, PRESTAMOS, SEGUROS, Cobros a Cta Incobrable NV Y DOCUMENTOS DE REFINANCIEMIENTO */
INSERT INTO #MovsRM851
SELECT OrigenTipo='CXC',Cob.Mov,Cob.MovID, Cob.FechaEmision,
Concepto= CASE WHEN Cob.Origen LIKE 'Factura%' THEN 'COBROS FACTURAS'
			 WHEN (Cob.Origen IN ('Credilana' , 'Prestamo Personal', 'Refinanciamiento' ) ) AND Cob.Aplica IN ('Documento','Cta Incobrable NV') THEN 'COBROS CRED Y PP'
			 WHEN Cob.Origen LIKE 'Seguro%' THEN 'COBROS SEGUROS'
			 WHEN UPPER(Cob.Aplica) IN ('CHEQUE POSFECHADO','CHEQUE DEVUELTO','CTA INCOBRABLE F','ENDOSO') THEN 'COBROS FACTURAS'
			 WHEN Cob.Origen IS NULL AND COB.APLICA <> 'CHEQUE POSFECHADO' THEN 'COBRO '+UPPER(Cob.aplica)
			 WHEN Cob.Origen IS NULL THEN 'COBRO '+UPPER(Cob.aplica)
			 ELSE 'COBRO ' + UPPER(Cob.Aplica)
			 END,
TipoConcepto='ACREEDOR',Modulo='CXC', Cob.ClienteEnviarA AS Can, SUM(Cob.Importe) AS Importe,
Impuesto= SUM(Cob.impuesto),
Total=SUM(Cob.Total), 
Financiamiento=CASE WHEN Cob.origen IN ('Prestamo Personal','Credilana','Refinanciamiento') THEN 
SUM(Cob.Financiamiento) ELSE NULL END,
Capital=CASE WHEN Cob.origen IN ('Prestamo Personal','Credilana','Refinanciamiento') THEN SUM(Cob.capital) ELSE NULL END,
Condicion=NULL,Meses=0
FROM(
	SELECT
	ClienteEnviarA=VCM.ID,Cx.Mov,Cx.Movid,Cx.FechaEmision,Cx.Concepto,Cx.Estatus,
	Importe=ISNULL(Apl.Importe,0),Impuesto=ISNULL(Apl.Impuesto,0),Total=ISNULL(Apl.Importe,0)+ISNULL(Apl.Impuesto,0),
	Apl.Origen,Apl.OrigenID,Apl.Aplica,apl.Aplicaid, Apl.Financiamiento,Apl.Capital, VCM.Categoria
	FROM cxc Cx WITH (NOLOCK)
	INNER JOIN Cte WITH (NOLOCK) ON Cx.Cliente=Cte.cliente
	INNER JOIN (
		SELECT D.id, D.Aplica, D.AplicaID,
		Importe=CASE WHEN APLICA IN ('DOCUMENTO' , 'Cta Incobrable NV')
					 AND ( C.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') OR CNV.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') )
							THEN D.Importe-(D.Importe*C.IVAFiscal)
						WHEN C.origen IN ('Seguro Vida','Seguro Auto')
							THEN D.Importe
					WHEN C.Mov = 'Cta Incobrable NV' THEN D.Importe - (D.Importe*CNV.IVAFiscal)
				ELSE CASE WHEN C.Importe <> 0.0 THEN D.Importe/((C.Importe+ISNULL(C.Impuestos,0.0))/C.Importe) ELSE 0.0 END
				END,
		Impuesto= CASE	WHEN APLICA IN ('DOCUMENTO' , 'Cta Incobrable NV') 
					 AND ( C.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') OR CNV.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') )
							THEN D.Importe*C.IVAFiscal
						WHEN C.Origen IN ('Seguro Vida','Seguro Auto')
							THEN 0.0
						WHEN C.Mov = 'Cta Incobrable NV' THEN D.Importe * CNV.IVAFiscal
						ELSE D.Importe- CASE WHEN C.Importe <> 0.0 THEN (D.Importe/((C.Importe+C.Impuestos)/C.Importe)) ELSE 0.0 END
						END,
		Financiamiento= CASE WHEN APLICA IN ('DOCUMENTO' , 'Cta Incobrable NV') 
					 AND ( C.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') OR CNV.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') )
								THEN ( D.Importe * ( ( CP.Financiamiento/(CP.Importe+CP.Impuestos) )*100 ) )/100
						WHEN C.Origen IN ('Seguro Vida','Seguro Auto')
								THEN 0.0
						WHEN C.Mov = 'Cta Incobrable NV' THEN (D.Importe*CNV.PorcFin)/100
						ELSE  C.Financiamiento END,
		Capital=CASE WHEN APLICA IN ('DOCUMENTO' , 'Cta Incobrable NV') 
					 AND ( C.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') OR CNV.Origen IN ('Prestamo Personal','Credilana','Refinanciamiento') )
						THEN D.Importe-( ( D.Importe * ( ( CP.Financiamiento/(CP.Importe+CP.Impuestos) )*100 ) )/100 )
					WHEN C.Mov = 'Cta Incobrable NV' THEN D.Importe - ( (D.Importe*CNV.PorcFin)/100 )
					ELSE NULL END,
		Origen = CASE WHEN C.Mov = 'Cta Incobrable NV' THEN CNV.Origen ELSE C.Origen END,
		OrigenID = CASE WHEN C.Mov = 'Cta Incobrable NV' THEN CNV.OrigenID ELSE C.OrigenID END
		FROM dbo.CxcD D  WITH (NOLOCK)
		INNER JOIN dbo.Cxc CC WITH (NOLOCK) ON d.ID = CC.ID
		LEFT JOIN dbo.Cxc C WITH (NOLOCK) ON D.Aplica = C.Mov AND D.AplicaID=C.MovID
		LEFT JOIN dbo.Cxc CP WITH (NOLOCK) ON C.Origen = CP.Mov AND C.OrigenID = CP.MovID
		LEFT JOIN (
			SELECT ID, NV.Mov, MovID, Origen, OrigenID,
			PorcFin=MAX(PorcFin), IVAFiscal=SUM(IVAFiscal)
			FROM
			(
				SELECT CA.Origen,CA.OrigenID,
				C.ID, C.Mov, C.MovID, CD.Aplica, CD.AplicaID, C.Estatus,
				PorcFin = ( CP.Financiamiento/(CP.Importe+CP.Impuestos) )*100,
				IVAFiscal=ISNULL(CA.IVAFiscal,0.0)
				FROM dbo.Cxc C WITH (NOLOCK)
				INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON CD.ID = C.ID
				INNER JOIN dbo.Cxc CA WITH (NOLOCK) ON CD.Aplica=CA.Mov AND CD.AplicaID=CA.MovID
				INNER JOIN dbo.Cxc CP WITH (NOLOCK) ON CA.Origen = CP.Mov AND CA.OrigenID = CP.MovID
				WHERE C.Mov='Cta Incobrable NV'
			) AS NV
			GROUP BY NV.ID, NV.Mov, NV.MovID, NV.Origen, NV.OrigenID
		) CNV ON C.ID = CNV.ID
		WHERE (C.Mov IN ('Documento','Cheque Devuelto','Cheque Posfechado','Cta Incobrable F','Cta Incobrable NV','Endoso') OR C.Mov LIKE 'Fact%' )
		AND CC.Mov = 'COBRO'
		AND NOT (C.Origen IS NULL AND D.Aplica <> 'Cta Incobrable F')
		AND D.Aplica NOT IN ('Capitalizacion','Aumento Capital','Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo','Redondeo','Contra Recibo Inst')
		AND ( C.Origen NOT IN ('Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo') OR C.Origen IS NULL )
	) AS Apl ON Cx.ID = Apl.ID
	LEFT JOIN dbo.Cxc CO WITH (NOLOCK) ON Apl.Origen = CO.Mov AND Apl.OrigenID = CO.MovID
	LEFT JOIN dbo.VentasCanalMAVI VCM WITH (NOLOCK) ON CO.ClienteEnviarA = VCM.ID
	WHERE Cx.Mov = 'COBRO'
	AND Cx.Estatus = 'CONCLUIDO'
	AND NOT (Apl.Origen IS NULL AND Apl.Aplica <> 'Cta Incobrable F')
	AND Cx.fechaemision BETWEEN @FechaD AND @FechaA
--	AND NOT ( ISNULL(Apl.Origen,'') LIKE 'Fact%' AND VCM.Categoria = 'INSTITUCIONES' )
--	AND NOT ( ISNULL(Apl.Origen,'') LIKE 'Seguro %' AND VCM.Categoria = 'INSTITUCIONES' )

) AS Cob
WHERE Cob.aplica NOT IN('Capitalizacion','Aumento Capital','Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo','Redondeo') 
AND (Cob.origen NOT IN ('Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo') OR Cob.origen IS NULL)
GROUP BY Cob.Origen, Cob.Mov, Cob.MovID, Cob.FechaEmision, Cob.ClienteEnviarA, Cob.Aplica, Cob.concepto

/*	PARA MOVIMIENTOS "COBRO" A NOTAS DE CARGO CON CONCEPTO "INTERESES P.F. Y P.M." SEPARADAS DE LAS DEMAS NOTAS DE CARGO	*/
INSERT INTO #MovsRM851
SELECT OrigenTipo='CXC',Cob.Mov,Cob.MovID, Cob.FechaEmision, 
Concepto= CASE 
			WHEN (Cob.Origen LIKE 'NOTA CARGO%' OR UPPER(Cob.Aplica) LIKE 'NOTA CARGO%') AND Concepto= 'INTERESES P.F. Y P.M.' THEN 'COBROS INTS P.F. Y P.M.'
			ELSE 'COBROS FACTURAS' END, 
TipoConcepto='ACREEDOR',Modulo='CXC', Cob.ClienteEnviarA AS Can, SUM(Cob.Importe) AS Importe, SUM(Cob.impuesto) AS Impuesto, 
SUM(Cob.Total) AS Total,  Financiamiento=NULL,Capital=NULL,Condicion=NULL,Meses=0
FROM(
	SELECT
		Cx.ClienteEnviarA, Cx.Mov, Cx.Movid, Cx.FechaEmision, CONCEPTO = ISNULL(Apl.Concepto, Cx.Concepto), Cx.Estatus, 
		Importe = ISNULL(Apl.Importe, 0),
		Impuesto = ISNULL(Apl.Impuesto, 0), 
		Total = ISNULL(Apl.Importe, 0)+ISNULL(Apl.Impuesto, 0), Apl.Origen, Apl.OrigenID, Apl.Aplica, Apl.AplicaID
	FROM
		cxc Cx WITH (NOLOCK)
	INNER JOIN Cte WITH (NOLOCK) ON Cx.Cliente = Cte.cliente
	INNER JOIN (
				 SELECT CA.Mov,
					d.id, d.Aplica, d.AplicaID,
					Importe = d.Importe / ( (CA.Importe+Ca.Impuestos)/CA.Importe ),
					Impuesto = d.importe - ( d.Importe / ( (CA.Importe+Ca.Impuestos)/CA.Importe ) ),
					c.origen, c.origenid, c.concepto
				 FROM
					cxcd d WITH (NOLOCK)
				 LEFT JOIN dbo.Cxc CA WITH (NOLOCK) ON d.ID = CA.ID
				 LEFT JOIN cxc c WITH (NOLOCK) ON d.aplica = c.mov AND d.aplicaid = c.movid
				 WHERE
				 C.ESTATUS IN ('PENDIENTE','CONCLUIDO')
				 AND CA.Mov='cobro'
				 AND NOT ( d.Aplica LIKE 'Fact%' AND c.Origen IS NULL )
				 AND ( c.ORIGEN LIKE 'Nota Cargo%' OR d.APLICA LIKE 'Nota Cargo%' )
			   ) Apl ON Cx.id = Apl.id
	WHERE
		Cx.Mov = 'COBRO'
		AND Cx.Estatus IN ('PENDIENTE','CONCLUIDO')
		AND Cx.fechaemision BETWEEN @FechaD AND @FechaA
	) AS Cob
WHERE Cob.aplica NOT IN('Capitalizacion','Aumento Capital') 
GROUP BY Cob.Origen,Cob.Mov,Cob.MovID, Cob.FechaEmision,Cob.ClienteEnviarA,Cob.Aplica,cob.concepto

/*	PARA LOS COBRO INSTITUCIONES QUE SE HACEN A MOVIMIENTOS "FACTURA", "SEGUROS DE AUTO Y VIDA" y "CREDILANAS"	*/
INSERT INTO #MovsRM851
SELECT 
OrigenTipo='CXC', mov,movid,FechaEmision,
Concepto= CASE WHEN OrigenCero LIKE 'Seguro%' THEN 'COBRO INST SEGUROS'
			WHEN OrigenCero='Factura' THEN 'COBRO INST FACTURAS'
			WHEN OrigenCero IN ('Credilana','Refinanciamiento') THEN 'COBRO INST CREDILANAS'
			END,
Tipoconcepto='ACREEDOR'	,Modulo='CXC', ClienteEnviarA AS Can,Importe,
Impuestos, 
Total=Importe+Impuestos,
Financiamiento, 
Capital = (Importe+Impuestos) - Financiamiento, 
Condicion=NULL, Meses = 0
FROM
(
	SELECT
		C.ID,C.Mov,C.MovID,cd.aplica,cd.aplicaid,
		nota=cd2.aplica,nota2=cd2.aplicaid,
		OrigenCero=C2.Origen,
		Importe = CASE WHEN C2.Origen = 'Credilana' THEN CD.Importe- ( CD.Importe*ISNULL(C2.IVAFiscal,0.0) ) ELSE C.Importe END, 
		Impuestos = CASE WHEN C2.Origen = 'Credilana' THEN CD.Importe*ISNULL(C2.IVAFiscal,0.0) ELSE C.Impuestos END,
		Financiamiento = ( CD.Importe * ( (CP.Financiamiento /( CP.Importe + CP.Impuestos)) *100 ) )/100,
		C.ClienteEnviarA,
		C.FechaEmision, C.Concepto,VCM.Categoria
	FROM dbo.Cxc C WITH (NOLOCK)
	INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
	LEFT JOIN dbo.Cxc C3 WITH (NOLOCK) ON CD.Aplica = C3.Mov AND CD.AplicaID = C3.MovID
	LEFT JOIN VentasCanalMavi VCM WITH (NOLOCK) ON C.ClienteEnviarA = VCM.ID
	LEFT JOIN dbo.CxcD CD2 WITH (NOLOCK) ON CD2.ID = C3.ID
	LEFT JOIN dbo.Cxc C2 WITH (NOLOCK) ON CD2.Aplica = C2.Mov AND CD2.AplicaID = C2.MovID
	LEFT JOIN dbo.Cxc CP WITH (NOLOCK) ON C2.Origen = CP.Mov AND C2.OrigenID = CP.MovID
	WHERE C.Mov = 'Cobro Instituciones'
	AND C.Estatus = 'CONCLUIDO'
	AND C2.Origen IN ('Seguro Vida','Seguro Auto','Factura','Credilana','Refinanciamiento')
	AND C.fechaemision BETWEEN @FechaD AND @FechaA
) AS CobroInst

/*	Para obtener los movimientos de React Incobrable F y React Incobrable NV	*/
INSERT INTO #MovsRM851
SELECT OrigenTipo='CXC', C.Mov, C.MovID, C.FechaEmision, C.Mov, TipoConcepto='DEUDOR',Modulo='CXC',
C.ClienteEnviarA, 
Importe = CASE WHEN C.Mov = 'React Incobrable NV' THEN CD.Importe - (CD.Importe*CNV.IVAFiscal) 
			ELSE CD.Importe - (CD.Importe*C.IVAFiscal) END,
Impuestos = CASE WHEN C.Mov = 'React Incobrable NV' THEN CD.Importe*CNV.IVAFiscal ELSE CD.Importe*C.IVAFiscal END, 
Total=C.Importe + C.Impuestos, 
Financiamiento = CASE WHEN C.Mov = 'React Incobrable NV' THEN (CD.Importe*CNV.PorcFin)/100 ELSE NULL END,
Capital = CASE WHEN C.Mov = 'React Incobrable NV' THEN CD.Importe - ( (CD.Importe*CNV.PorcFin)/100 ) ELSE NULL END,
C.Condicion, Meses=0
FROM dbo.Cxc C WITH (NOLOCK)
INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON C.ID = CD.ID
LEFT JOIN (
	SELECT ID, NV.Mov, MovID, Origen, OrigenID,
	PorcFin=MAX(PorcFin), IVAFiscal=MAX(IVAFiscal)
	FROM
	(
		SELECT CA.Origen,CA.OrigenID,
		C.ID, C.Mov, C.MovID, CD.Aplica, CD.AplicaID, C.Estatus,
		PorcFin = ( CP.Financiamiento/(CP.Importe+CP.Impuestos) )*100,
		Financiamiento = CP.Financiamiento,
		IVAFiscal=ISNULL(CA.IVAFiscal,0.0)
		FROM dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON CD.ID = C.ID
		INNER JOIN dbo.Cxc CA WITH (NOLOCK) ON CD.Aplica=CA.Mov AND CD.AplicaID=CA.MovID
		INNER JOIN dbo.Cxc CP WITH (NOLOCK) ON CA.Origen = CP.Mov AND CA.OrigenID = CP.MovID
		WHERE C.Mov='Cta Incobrable NV'
	) AS NV
	GROUP BY NV.ID, NV.Mov, NV.MovID, NV.Origen, NV.OrigenID
) CNV ON CD.Aplica = CNV.Mov AND CD.AplicaID = CNV.MovID
WHERE C.Mov IN ('React Incobrable F','React Incobrable NV')
AND C.Estatus='CONCLUIDO'
AND C.FechaEmision BETWEEN @FechaD AND @FechaA

/*	Para las Cuentas Incobrables: 'CTA INCOBRABLE NV' y 'CTA INCOBRABLE F'	*/
INSERT INTO #MovsRM851
SELECT
OrigenTipo='CXC', C.Mov, C.MovID, C.FechaEmision, C.Mov, TipoConcepto='ACREEDOR',Modulo='CXC',
C.ClienteEnviarA, 
Importe = C.Importe,
Impuestos = C.Impuestos, 
Total=C.Importe + C.Impuestos, 
Financiamiento=CASE WHEN C.Mov = 'Cta Incobrable NV' THEN ((C.Importe + C.Impuestos)*CNV.PorcFin)/100 ELSE NULL END, 
Capital=CASE WHEN C.Mov = 'Cta Incobrable NV' THEN (C.Importe + C.Impuestos) - ( ((C.Importe + C.Impuestos)*CNV.PorcFin)/100 ) ELSE NULL END, 
C.Condicion, Meses=0
FROM dbo.Cxc C WITH (NOLOCK)
LEFT JOIN (
	SELECT ID, NV.Mov, MovID, Origen, OrigenID,
	PorcFin=MAX(PorcFin), IVAFiscal=MAX(IVAFiscal)
	FROM
	(
		SELECT CA.Origen,CA.OrigenID,
		C.ID, C.Mov, C.MovID, CD.Aplica, CD.AplicaID, C.Estatus,
		PorcFin = ( CP.Financiamiento/(CP.Importe+CP.Impuestos) )*100,
		Financiamiento = CP.Financiamiento,
		IVAFiscal=ISNULL(CA.IVAFiscal,0.0)
		FROM dbo.Cxc C WITH (NOLOCK)
		INNER JOIN dbo.CxcD CD WITH (NOLOCK) ON CD.ID = C.ID
		INNER JOIN dbo.Cxc CA WITH (NOLOCK) ON CD.Aplica=CA.Mov AND CD.AplicaID=CA.MovID
		INNER JOIN dbo.Cxc CP WITH (NOLOCK) ON CA.Origen = CP.Mov AND CA.OrigenID = CP.MovID
		WHERE C.Mov='Cta Incobrable NV'
	) AS NV
	GROUP BY NV.ID, NV.Mov, NV.MovID, NV.Origen, NV.OrigenID
) CNV ON C.ID = CNV.ID
WHERE C.Mov IN ('CTA INCOBRABLE NV','CTA INCOBRABLE F')
AND Estatus IN ('PENDIENTE','CONCLUIDO')
AND C.FechaEmision BETWEEN @FechaD AND @FechaA

/*	Consulta a la Tabla Temporal y Acomodo de los Datos		*/
SELECT
    T1.Concepto, T1.Identificador, T1.ImporteVtas, T1.ImpuestosVtas, T1.CapitalCred, T1.FinanCred, T1.ImporteCXC, T1.ImpuestosCXC, T1.Orden
FROM
    (
      SELECT
        Concepto = T.Concepto, T.Identificador, SUM(T.ImporteVtas) AS ImporteVtas, SUM(T.ImpuestosVtas) AS ImpuestosVtas, SUM(T.CapitalCredi) AS CapitalCred,
        SUM(T.Financiamiento) AS FinanCred, SUM(T.ImporteCXC) AS ImporteCXC, SUM(T.ImpuestosCXC) AS ImpuestosCXC,
        Orden = CASE WHEN T.Concepto = 'VTAS MENUDEO 1 a 12 MESES' THEN 0
                     WHEN T.Concepto = 'VTAS MENUDEO + de 12 MESES' THEN 1
                     WHEN T.Concepto IN ( 'VTAS Contado', 'VTAS Credito Externo', 'VTAS Mayoreo' ) THEN 2
                     WHEN T.Concepto IN ( 'Credilana', 'Prestamo Personal' ) THEN 3
                     WHEN T.Concepto IN ( 'Seguros Auto', 'Seguros Vida' ) THEN 4
                     WHEN T.Concepto NOT IN ( 'VTAS MENUDEO 1 a 12 MESES', 'VTAS MENUDEO + de 12 MESES', 'VTAS Contado', 'VTAS Credito Externo', 'VTAS Mayoreo' ) AND T.Identificador = 'C' THEN 5
                     WHEN T.Concepto LIKE 'Cobro%' AND T.Identificador = 'A' THEN 6
                     WHEN T.Concepto = 'Apartado' AND T.Identificador = 'A' THEN 7
                     WHEN T.concepto LIKE 'Dev%'  AND T.Identificador = 'A' THEN 8
                     WHEN T.Concepto LIKE 'Bonif%' AND T.Identificador = 'A' AND T.Orden = 0 THEN 9
                     WHEN T.Concepto LIKE 'Bonif%' AND T.Identificador = 'A' AND T.Orden <> 0 THEN 12
                     WHEN T.Concepto LIKE 'Canc%' AND T.Identificador = 'A' THEN 10
                     ELSE 11
                END
      FROM
        (
		SELECT
		Concepto = CASE WHEN Con.Conceptos = 'CREDITO MENUDEO E INST' AND Con.Mov NOT IN ( 'Credilana', 'Prestamo Personal', 'Seguro Auto', 'Seguro Vida' )
							THEN  CASE WHEN Con.Meses = 1 THEN 'VTAS MENUDEO + de 12 MESES'
								ELSE 'VTAS MENUDEO 1 a 12 MESES'
							    END
						WHEN Con.Conceptos = 'CREDITO MENUDEO E INST' AND Con.Mov IN  ('Credilana', 'Prestamo Personal')
							THEN UPPER(Con.Mov)
						WHEN Con.Conceptos = 'CREDITO MENUDEO E INST' AND Con.Mov = 'Seguro Auto' 
							THEN 'SEGUROS AUTO'
						WHEN Con.Conceptos = 'CREDITO MENUDEO E INST' AND Con.Mov = 'Seguro Vida' 
							THEN 'SEGUROS VIDA'
						ELSE UPPER(Con.Conceptos)
				   END, 
		IDENTIFICADOR = CASE WHEN Con.Tpo = 'ACREEDOR' THEN 'A'
							 WHEN Con.Tpo = 'DEUDOR' THEN 'C'
							 ELSE ''
							 END, 
		ImporteVtas = CASE WHEN Con.Modulo IN ( 'VTAS', 'CXC', 'PP/RECARGO' ) AND con.Tpo = 'DEUDOR' THEN SUM(Con.Importe)
						   ELSE NULL
						   END,
		ImpuestosVtas = CASE WHEN Con.Modulo IN ( 'VTAS', 'CXC', 'PP/RECARGO' ) AND con.Tpo = 'DEUDOR' THEN SUM(Con.Impuestos)
							 ELSE NULL
						  	 END,
		CapitalCredi = CASE WHEN Con.Mov IN ( 'Credilana', 'Prestamo Personal', 'Cancela Credilana', 'Cancela Prestamo', 'Cobro', 'Refinanciamiento', 'Cta Incobrable NV', 'React Incobrable NV' ) THEN SUM(Con.Capital)
							WHEN Con.Mov IN ( 'Cobro Instituciones' )
								 AND CON.CONCEPTOS = 'COBRO INST CREDILANAS' THEN SUM(Con.Capital)
							ELSE NULL
					   END,
		Financiamiento = CASE WHEN Con.Mov IN ( 'Credilana', 'Prestamo Personal', 'Cancela Credilana', 'Cancela Prestamo', 'Cobro', 'Refinanciamiento', 'Cta Incobrable NV', 'React Incobrable NV' ) THEN SUM(Con.Financiamiento)
							  WHEN Con.Mov IN ( 'Cobro Instituciones' ) AND CON.CONCEPTOS = 'COBRO INST CREDILANAS' THEN SUM(Con.Financiamiento)
							  ELSE NULL
						 END,
		ImporteCXC = CASE WHEN CON.conceptoS = 'INCOBRABLE CREDILANA/PP' AND Con.Modulo IN ( 'CXC', 'GAS', 'VTAS' ) AND con.Tpo = 'ACREEDOR' THEN SUM(Con.IMPORTE)
						  WHEN Con.Modulo IN ( 'CXC', 'GAS', 'VTAS' ) AND con.Tpo = 'ACREEDOR' THEN SUM(Con.Importe)
						  ELSE NULL
						  END,
		ImpuestosCXC = CASE WHEN Con.Modulo IN ( 'CXC', 'GAS', 'VTAS' ) AND con.Tpo = 'ACREEDOR' THEN SUM(Con.Impuestos)
							ELSE NULL
						    END,
		Con.Mov, Con.Orden
		FROM
			(
			  SELECT
				C1.Mov, C1.Movid, C1.Fechaemision, C1.Conceptos, C1.Can, C1.Tipoconcepto AS Tpo, C1.Modulo, C1.Importe, C1.Impuestos, C1.Condicion, C1.Total,
				C1.Financiamiento, C1.Capital, C1.Meses, Orden = CASE WHEN Can = 255 AND C1.Conceptos LIKE 'Bonif%' THEN 12 ELSE 0 END
			  FROM
				#MovsRM851 C1
			  WHERE
				Modulo IN ( 'VTAS', 'CXC', 'PP/RECARGO' )
				AND Importe > 0.00 OR (C1.Mov in ( 'Ajuste', 'Ajuste Redondeo' ) and Importe < 0.00)
			) AS Con
		GROUP BY
			Con.Conceptos, Con.Condicion, Con.Tpo, Con.Modulo, Con.Mov, Con.Meses, Con.Orden
        ) AS T
      WHERE IDENTIFICADOR IN ('A','C')
      GROUP BY
        T.Identificador, T.Concepto, T.Orden
    ) AS T1
ORDER BY
    T1.Orden ASC, T1.Identificador DESC, T1.concepto ASC

-- FIN DEL PROCEDIMIENTO
END

