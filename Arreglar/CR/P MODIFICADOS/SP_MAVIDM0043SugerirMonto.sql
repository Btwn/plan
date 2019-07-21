SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[SP_MAVIDM0043SugerirMonto] 
 
	@IDFac INT ,@Estacion int , @idcobro int ,  @ImporteTotal MONEY
 
AS 
BEGIN
	SET ARITHABORT ON;
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Factura')
		AND TYPE = 'U')
		DROP TABLE #Factura

	CREATE TABLE #Factura (
		IdFact int,
		Padremavi varchar(50),
		padreidmavi varchar(50),
		FechaEmisionFact datetime,
		MaxDiasAtrazo int,
		Importefact money,
		Condicion varchar(100) NULL,
		numdocs int,
		Monedero money,
		CobxPol varchar(5),
		uen int NULL,
		sucursal int
	)

	INSERT INTO #Factura
		SELECT
			a.id IdFact,
			a.Padremavi,
			a.padreidmavi,
			FechaEmisionFact = a.FechaEmision,
			MaxDiasAtrazo = ISNULL(cm.MaxDiasVencidosMAVI, 0),
			a.importe + a.impuestos Importefact,
			a.Condicion,
			ISNULL(DANumeroDocumentos, 0) numdocs,
			0.00 Monedero,
			'',
			uen,
			sucursal
		FROM (SELECT
			id,
			Padremavi,
			padreidmavi,
			FechaEmision,
			ISNULL(Condicion, '') Condicion,
			importe,
			impuestos,
			ISNULL(uen, '') uen,
			sucursal
		FROM Cxc WITH (NOLOCK)
		WHERE id = @IDFac) a
		LEFT JOIN Condicion cn WITH (NOLOCK)
			ON cn.Condicion = a.Condicion
		LEFT JOIN CXCMAVI cm WITH (NOLOCK)
			ON a.ID = cm.ID

	-- Si se activa la opcion para que el calculo se haga en el cobro se ejecuta el sp para calcular
	IF (SELECT
			ISNULL(valor, '')
		FROM tablastD WITH (NOLOCK)
		WHERE TablaSt = 'CALCULA BONIF EN COBRO'
		AND Nombre = 'ACTIVAR')
		= '1'
	BEGIN
		IF (SELECT
				COUNT(iD)
			FROM #Factura F
			JOIN CXC Docs WITH (NOLOCK)
				ON Docs.PadreMAVI = F.Padremavi
				AND Docs.PadreIDMAVI = F.padreidmavi
			WHERE Docs.Estatus IN ('Pendiente', 'Concluido')
			AND Docs.id != F.IdFact
			AND Docs.IDBonifAP IS NULL
			AND Docs.IDBonifCC IS NULL
			AND Docs.IDBonifPP IS NULL)
			> 0
		BEGIN
			DECLARE @MOV varchar(30),
							@MOVID varchar(30)
			SELECT
				@MOV = Padremavi,
				@MOVID = padreidmavi
			FROM #Factura
			EXEC SP_MAVIDM0279CalcularBonif @MOV,
																			@MOVID,
																			NULL,
																			NULL,
																			@clave = 'COBRO'

		END
	END


	-- Se borran los registros de calculos anteriores de la venta

	DELETE m
		FROM MaviBonificacionTest m WITH(ROWLOCK)
		JOIN #Factura f
			ON OrigenId = padreidmavi
			AND Origen = padreMavi

	-- Se toman los movimientos hijo  de la factura
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Docs')
		AND TYPE = 'U')
		DROP TABLE #Docs --Pendientes

	SELECT
		Docs.cliente,
		Docs.id,
		Docs.Mov,
		Docs.MovID,
		Docs.PadreMAVI,
		Docs.PadreidMAVI,
		importe + impuestos Importedoc,
		Saldo,
		Docs.Vencimiento,
		ISNULL(Docs.IDBonifAP, 0) IDBonifAP,
		ISNULL(Docs.IDBonifCC, 0) IDBonifCC,
		ISNULL(Docs.BonifCC, 0) BonifCC,
		ISNULL(Docs.IDBonifPP, 0) IDBonifPP,
		ISNULL(Docs.BonifPP, 0) BonifPP,
		ISNULL(Docs.BonifPPExt, 0) BonifPPExt,
		Docs.Estatus,
		Docs.Concepto,
		DVN = DATEDIFF(dd, Vencimiento, CONVERT(datetime, CONVERT(varchar(10), GETDATE(), 10))),
		Docs.FechaEmision,
		Docs.Condicion,
		CASE
			WHEN ISNULL(ReferenciaMAvi, Referencia) LIKE '%/%' THEN SUBSTRING(ISNULL(ReferenciaMAvi, Referencia), 1, CHARINDEX('/', ISNULL(ReferenciaMAvi, Referencia)) - 1)
		END Referencia,
		CAST(0.00 AS float) Moratorios INTO #Docs --Pendientes
	FROM #Factura F
	JOIN CXC Docs WITH (NOLOCK)
		ON Docs.PadreMAVI = F.Padremavi
		AND Docs.PadreIDMAVI = F.padreidmavi
	WHERE Docs.Estatus IN ('Pendiente', 'Concluido')
	AND Docs.id != F.IdFact


	-- Se toma el dato del Monedero y el cobro por politica

	UPDATE F
	SET Monedero = ISNULL(Mon.Abono, 0.00)
	FROM #Factura F
	JOIN auxiliarp Mon WITH (NOLOCK)
		ON Mon.Mov = F.Padremavi
		AND Mon.MovID = F.padreidmavi


	UPDATE F
	SET CobxPol = DBO.FN_MAVIRM0906CobxPol(F.IDFact)
	FROM #Factura F


	UPDATE dcs
	SET moratorios = dbo.fnInteresMoratorioMAVI(dcs.id)
	FROM #docs dcs
	LEFT JOIN #Factura F
		ON F.padremavi = dcs.padremavi
		AND F.padreidmavi = dcs.padreidmavi
	WHERE dcs.estatus = 'pendiente'


	-- Se verifica que cumpla con los requrimientos para las bonificiciones 

	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Bonifaplica')
		AND TYPE = 'U')
		DROP TABLE #Bonifaplica


	SELECT
		Padremavi,
		PadreidMavi,
		id,
		AplicaA,
		Bonificacion,
		PorcBon1,
		Bonif_Ext,
		MaxDVppext,
		VencimientoAntes,
		VencimientoDesp,
		DiasAtrazo,
		DiasMenoresA,
		DiasMayoresA,
		Financiamiento,
		Factor,
		PlazoEjeFin INTO #Bonifaplica
	FROM ( -- F
	SELECT
		Padremavi,
		PadreidMavi,
		B.id,
		B.AplicaA,
		B.Bonificacion,
		B.VencimientoAntes,
		B.VencimientoDesp,
		B.DiasAtrazo,
		B.DiasMenoresA,
		B.DiasMayoresA,
		b.Financiamiento,
		b.Factor,
		b.PlazoEjeFin,
		CASE
			WHEN B.Bonificacion LIKE '%Contado Comercial%' THEN CASE
					WHEN MaxDiasAtrazo > B.DiasAtrazo AND
						B.DiasAtrazo <> 0 THEN 'no aplica'
					WHEN B.VencimientoAntes <> 0 AND
						D.vencyapaso >= B.VencimientoAntes THEN 'no aplica'
					WHEN B.DiasMenoresA <> 0 AND
						B.DiasMenoresA < DATEDIFF(DAY, FechaEmisionFact, GETDATE()) THEN 'no aplica'
					WHEN DiasMayoresA <> 0 AND
						DiasMayoresA >= DATEDIFF(dd, FechaEmisionFact, primervenc) THEN 'no aplica'
					ELSE 'Aplica'
				END
		END BonifCC,
		CASE
			WHEN B.Bonificacion LIKE '%Adelanto en Pagos%' THEN CASE
					WHEN B.VencimientoAntes <> 0 AND
						D.vencyapaso >= B.VencimientoAntes THEN 'no aplica'
					WHEN B.VencimientoDesp <> 0 AND
						D.vencyapaso < B.VencimientoDesp THEN 'no aplica'
					WHEN B.DiasMayoresA <> 0 AND
						B.DiasMayoresA > D.vencyapaso THEN 'no aplica'
					WHEN B.DiasMenoresA <> 0 AND
						B.DiasMenoresA < D.vencyapaso THEN 'no aplica'
					ELSE 'Aplica'
				END
		END BonifAP,
		CASE
			WHEN B.Bonificacion LIKE '%Pago Puntual%' AND
				D.IDBonifPP IS NOT NULL THEN 'aplica'
			ELSE ''
		END BonifPP,
		CASE
			WHEN B.Bonificacion LIKE '%Adelanto en Pagos%' AND
				B.PorcBon1 = 0 THEN B.linea
			ELSE B.PorcBon1
		END PorcBon1,
		ISNULL(bc.PorcBon, 0) Bonif_Ext,
		ISNULL(bc.MaxDV, 0) MaxDVppext,
		FechaEmisionFact
	FROM ( -- D
	SELECT
		Padremavi,
		PadreidMavi,
		IDBonifCC,
		IDBonifPP,
		IDBonifAP,
		MIN(vencimiento) primervenc,
		ISNULL(MAX(CASE
			WHEN vencyapaso = 'S' THEN ordenvenc
		END), 0) vencyapaso,
		ISNULL(MAX(CASE
			WHEN vencyapaso = 'S' THEN dvn
		END), 0) MAxDVN,
		FechaEmisionFact,
		MaxDiasAtrazo
	FROM ( -- B
	SELECT
		D.Padremavi,
		D.PadreidMavi,
		ISNULL(D.IDBonifCC, 0) IDBonifCC,
		ISNULL(D.IDBonifPP, 0) IDBonifPP,
		ISNULL(D.IDBonifAP, 0) IDBonifAP,
		D.mov,
		D.movid,
		F.FechaEmisionFact,
		ROW_NUMBER() OVER (ORDER BY D.Vencimiento) ordenvenc,
		D.dvn,
		CASE
			WHEN D.dvn > 0 THEN 'S'
			ELSE ''
		END vencyapaso,
		D.vencimiento,
		F.MaxDiasAtrazo
	FROM #Docs d
	LEFT JOIN #Factura F
		ON f.PadreMAVI = d.PadreMAVI
		AND f.PadreIDMAVI = d.PadreIDMAVI
	WHERE D.Mov = 'Documento') B
	GROUP BY Padremavi,
					 PadreidMavi,
					 IDBonifCC,
					 IDBonifPP,
					 IDBonifAP,
					 FechaEmisionFact,
					 MaxDiasAtrazo) D
	LEFT JOIN MaviBonificacionConf B WITH (NOLOCK)
		ON B.id IN (D.IDBonifCC, D.IDBonifPP, D.IDBonifAP)
	LEFT JOIN MaviBonificacionConVencimiento bc WITH (NOLOCK)
		ON bc.IdBonificacion = B.ID) F
	WHERE ISNULL(BonifCC, '') = 'aplica'
	OR ISNULL(BonifPP, '') = 'aplica'
	OR ISNULL(BonifAP, '') = 'aplica'



	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Bonficaciones')
		AND TYPE = 'U')
		DROP TABLE #Bonficaciones

	SELECT
		R.cliente,
		R.id,
		IdBonificacion,
		R.Bonificacion,
		@Estacion Estacion,
		R.Mov,
		R.Movid,
		R.PadreMAVI,
		R.PadreIDMAVI,
		ROUND(F.Importefact - F.Monedero, 2) ImporteFactFin,
		ROUND((F.Importefact - F.Monedero) / (F.numdocs), 2) Importedoc,
		R.PorcBonPP,
		R.PorcBonCC,
		CASE
			WHEN R.Bonificacion = 'Bonificacion Pago Puntual' THEN BonifPPFinal
			WHEN R.Bonificacion = 'Bonificacion Contado Comercial' THEN Bonifcc
		END MontoBonif,
		Financiamiento,
		Factor,
		PlazoEjeFin,
		Documento1de,
		F.sucursal Sucursal1,
		'' TipoSucursal,
		'' LineaVta,
		R.DiasMenoresA,
		R.DiasMayoresA,
		0 Idventa,
		F.uen,
		F.Condicion,
		'' Ok,
		'' Okref,
		F.FechaEmisionFact,
		R.Vencimiento,
		@idcobro idcrobo,
		'' LineaCelulares,
		'' LineaCredilanas,
		F.IdFact,
		0 BaseParaAPlicar,
		F.numdocs,
		F.monedero,
		CASE
			WHEN R.Bonificacion = 'Bonificacion Contado Comercial' THEN ((F.numdocs - R.PlazoEjeFin) * (R.Financiamiento / 100) + 1)
			ELSE 0
		END Factorconversion_cc INTO #Bonficaciones
	FROM (SELECT
		D.Cliente,
		D.id,
		B.ID IdBonificacion,
		B.Bonificacion,
		D.Mov,
		D.Movid,
		D.PadreMAVI,
		D.PadreIDMAVI,
		CASE
			WHEN B.bonificacion LIKE '%Pago Puntual%' AND
				dvn <= 0 THEN B.PorcBon1
			ELSE CASE
					WHEN B.bonificacion LIKE '%Pago Puntual%' AND
						dvn <= MaxDVppext THEN B.Bonif_Ext
					ELSE 0
				END
		END PorcBonPP,
		CASE
			WHEN B.bonificacion LIKE '%Contado Comercial%' THEN B.PorcBon1
			ELSE 0
		END PorcBonCC,
		CASE
			WHEN dvn <= 0 THEN D.BonifPP
			ELSE CASE
					WHEN dvn <= MaxDVppext THEN D.BonifPPExt
					ELSE 0
				END
		END BonifPPFinal,
		D.Bonifcc,
		B.Factor,
		B.Financiamiento,
		b.PlazoEjeFin,
		CASE
			WHEN Referencia LIKE '%(%' THEN SUBSTRING(Referencia, CHARINDEX('(', Referencia) + 1, 5)
			ELSE ''
		END Documento1de,
		B.DiasMenoresA,
		B.DiasMayoresA,
		D.Vencimiento
	FROM #Docs D
	JOIN #Bonifaplica B
		ON b.PadreMAVI = D.PadreMAVI
		AND b.PadreIDMAVI = D.PadreIDMAVI
	WHERE estatus = 'pendiente') R
	LEFT JOIN #Factura F
		ON f.PadreMAVI = R.PadreMAVI
		AND f.PadreIDMAVI = R.PadreIDMAVI



	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#temp')
		AND TYPE = 'U')
		DROP TABLE #temp

	CREATE TABLE #temp (
		Docto int NULL,
		IdBonificacion int NULL,
		Bonificacion varchar(40) NULL,
		Estacion int NULL,
		Mov varchar(50) NULL,
		Movid varchar(50) NULL,
		PadreMAVI varchar(50) NULL,
		PadreIDMAVI varchar(50) NULL,
		ImporteFact money NULL,
		Importedoc money NULL,
		PorcBon money NULL,
		MontoBonif money NULL,
		Financiamiento money NULL,
		Factor money NULL,
		PlazoEjeFin int,
		Documento1de int NULL,
		DocumentoTotal int NULL,
		Sucursal1 int NULL,
		TipoSucursal varchar(50) NULL,
		LineaVta varchar(100) NULL,
		DiasMenoresA int NULL,
		DiasMayoresA int NULL,
		Idventa int NULL,
		UEN int,
		Condicion varchar(100) NULL,
		Ok int NULL,
		Okref varchar(50) NULL,
		FechaEmisionFact datetime,
		Vencimiento datetime,
		idcrobo int,
		LineaCelulares varchar(100) NULL,
		LineaCredilanas varchar(100) NULL,
		BaseParaAPlicar money
	)


	--- Bonificacion Contado Comercial
	INSERT INTO #temp (Docto, IdBonificacion, Bonificacion, Estacion, Mov, Movid, PadreMAVI, PadreIDMAVI, ImporteFact, Importedoc
	, PorcBon, MontoBonif, Financiamiento, Factor, PlazoEjeFin, Documento1de, DocumentoTotal, Sucursal1, TipoSucursal, LineaVta, DiasMenoresA, DiasMayoresA, Idventa
	, UEN, Condicion, Ok, Okref, FechaEmisionFact, Vencimiento, idcrobo, LineaCelulares, LineaCredilanas, BaseParaAPlicar)
		SELECT
			B.IdFact,
			B.IdBonificacion,
			B.Bonificacion,
			B.Estacion,
			B.PadreMAVI Mov,
			B.PadreIDMAVI Movid,
			B.PadreMAVI,
			B.PadreIDMAVI,
			B.ImporteFactfin,
			B.ImporteFactfin Importedoc,
			B.PorcBonCC,
			B.MontoBonif - SUM(ISNULL(dt.Importe, 0))
			MontoBonif,
			B.Financiamiento,
			B.Factorconversion_cc,
			B.PlazoEjeFin,
			1 Documento1de,
			b.numdocs DocumentoTotal,
			Sucursal1,
			'' TipoSucursal,
			'' LineaVta,
			B.DiasMenoresA,
			B.DiasMayoresA,
			B.Idventa,
			B.UEN,
			B.Condicion,
			B.Ok,
			B.Okref,
			B.FechaEmisionFact,
			B.Vencimiento,
			B.idcrobo,
			B.LineaCelulares,
			B.LineaCredilanas,
			B.BaseParaAPlicar
		FROM (SELECT
			Cliente,
			IdFact,
			IdBonificacion,
			Bonificacion,
			Estacion,
			PadreMAVI,
			PadreIDMAVI,
			ImporteFactfin,
			PorcBonCC,
			COUNT(id) totpendientes,
			numdocs * MAX(MontoBonif) MontoBonif,
			Financiamiento,
			Factor,
			PlazoEjeFin,
			DiasMenoresA,
			DiasMayoresA,
			Idventa,
			UEN,
			Condicion,
			Ok,
			Okref,
			FechaEmisionFact,
			MIN(Vencimiento) Vencimiento,
			idcrobo,
			LineaCelulares,
			LineaCredilanas,
			BaseParaAPlicar,
			numdocs,
			Factorconversion_cc,
			Sucursal1
		FROM #Bonficaciones
		WHERE ISNULL(Bonificacion, '') = 'Bonificacion Contado Comercial'
		GROUP BY Cliente,
						 IdFact,
						 IdBonificacion,
						 Bonificacion,
						 Estacion,
						 PadreMAVI,
						 PadreIDMAVI,
						 ImporteFactfin,
						 PorcBonCC,
						 Financiamiento,
						 Factor,
						 PlazoEjeFin,
						 DiasMenoresA,
						 DiasMayoresA,
						 Idventa,
						 UEN,
						 Condicion,
						 Ok,
						 Okref,
						 FechaEmisionFact,
						 idcrobo,
						 LineaCelulares,
						 LineaCredilanas,
						 BaseParaAPlicar,
						 numdocs,
						 Factorconversion_cc,
						 UEN,
						 Sucursal1) B
		LEFT JOIN cxc nc WITH (NOLOCK)
			ON nc.Cliente = b.cliente
			AND nc.Mov LIKE 'Nota Credito%'
			AND nc.Concepto LIKE '%PAGO PUNTUAL%'
			AND nc.Estatus = 'CONCLUIDO'
		LEFT JOIN #Docs D
			ON B.padremavi = D.padremavi
			AND B.padreidmavi = D.padreidmavi
			AND D.estatus = 'concluido'
		LEFT JOIN cxcd dt WITH (NOLOCK)
			ON nc.id = dt.id
			AND dt.Aplica = D.Mov
			AND dt.AplicaID = D.MovID
		GROUP BY B.IdFact,
						 B.IdBonificacion,
						 B.Bonificacion,
						 B.Estacion,
						 B.PadreMAVI,
						 B.PadreIDMAVI,
						 B.ImporteFactfin,
						 B.PorcBonCC,
						 B.MontoBonif,
						 B.Financiamiento,
						 Factor,
						 PlazoEjeFin,
						 numdocs,
						 B.DiasMenoresA,
						 B.DiasMayoresA,
						 B.Idventa,
						 B.UEN,
						 B.Condicion,
						 B.Ok,
						 B.Okref,
						 B.FechaEmisionFact,
						 B.Vencimiento,
						 B.idcrobo,
						 B.LineaCelulares,
						 B.LineaCredilanas,
						 B.BaseParaAPlicar,
						 Factorconversion_cc,
						 B.Sucursal1


	--- Bonificacion de PAgo Puntual.
	INSERT INTO #temp (Docto, IdBonificacion, Bonificacion, Estacion, Mov, Movid, PadreMAVI, PadreIDMAVI, ImporteFact, Importedoc
	, PorcBon, MontoBonif, Financiamiento, Factor, PlazoEjeFin, Documento1de, DocumentoTotal, Sucursal1, TipoSucursal, LineaVta, DiasMenoresA, DiasMayoresA, Idventa
	, UEN, Condicion, Ok, Okref, FechaEmisionFact, Vencimiento, idcrobo, LineaCelulares, LineaCredilanas, BaseParaAPlicar)
		SELECT
			b.id,
			b.IdBonificacion,
			b.Bonificacion,
			b.Estacion,
			b.Mov,
			b.Movid,
			b.PadreMAVI,
			b.PadreIDMAVI,
			b.ImporteFactfin,
			ROUND(b.Importedoc, 2) Importedoc,
			b.PorcBonPP,
			ROUND(b.MontoBonif, 2) MontoBonif,
			b.Financiamiento,
			b.Factor,
			b.PlazoEjeFin,
			b.Documento1de,
			b.numdocs DocumentoTotal,
			b.Sucursal1,
			b.TipoSucursal,
			b.LineaVta,
			b.DiasMenoresA,
			b.DiasMayoresA,
			b.Idventa,
			b.UEN,
			b.Condicion,
			b.Ok,
			b.Okref,
			b.FechaEmisionFact,
			b.Vencimiento,
			b.idcrobo,
			b.LineaCelulares,
			b.LineaCredilanas,
			b.BaseParaAPlicar
		FROM #Bonficaciones b
		WHERE b.Bonificacion = 'Bonificacion Pago Puntual'

	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#BonifapliPP')
		AND TYPE = 'U')
		DROP TABLE #BonifapliPP

	-- bonificaciones aplicadas de PP				   
	SELECT
		Ds.padremavi,
		Ds.padreidmavi,
		SUM(ISNULL(dt.Importe, 0)) BonifapliPP INTO #BonifapliPP
	FROM #Docs Ds
	JOIN cxcd dt WITH (NOLOCK)
		ON dt.Aplica = Ds.Mov
		AND dt.AplicaID = Ds.MovID
	JOIN cxc nc WITH (NOLOCK)
		ON nc.id = dt.id
		AND nc.Mov LIKE 'Nota Credito%'
		AND nc.Concepto LIKE '%PAGO PUNTUAL%'
		AND nc.Estatus = 'CONCLUIDO'
	WHERE Ds.estatus = 'concluido'
	GROUP BY Ds.padremavi,
					 Ds.padreidmavi

	--------------- Para calular Adelanto en pago

	IF EXISTS (SELECT TOP 1
			id
		FROM #Bonifaplica
		WHERE Bonificacion NOT IN ('Bonificacion Pago Puntual', 'Bonificacion Contado Comercial'))
	BEGIN
		---- Cancelacions hecahas a la factura.
		IF EXISTS (SELECT
				NAME
			FROM TEMPDB.SYS.SYSOBJECTS
			WHERE ID = OBJECT_ID('Tempdb.dbo.#ArtCanc')
			AND TYPE = 'U')
			DROP TABLE #ArtCanc

		CREATE TABLE #ArtCanc (
			Padremavi varchar(50),
			Padreidmavi varchar(50),
			artcancelado varchar(50),
			impocanc money
		)

		INSERT INTO #ArtCanc (Padremavi, Padreidmavi, artcancelado, impocanc)
			SELECT
				d.Padremavi,
				d.Padreidmavi,
				t.articulo,
				SUM(t.Cantidad * t.Precio) importeart
			FROM ( -- d
			SELECT
				a.Padremavi,
				a.Padreidmavi,
				dv.id
			FROM (-- a
			SELECT
				F.Padremavi,
				F.Padreidmavi,
				sv.Mov,
				sv.movid
			FROM #Factura F
			JOIN Venta sv WITH (NOLOCK)
				ON sv.referencia = F.Padremavi + ' ' + F.Padreidmavi --v2
			) a
			JOIN VENTA dv WITH (NOLOCK)
				ON dv.Origen = a.Mov
				AND dv.OrigenID = a.MovID
			WHERE dv.MOV LIKE '%DEVOLUCION%'
			AND dv.estatus = 'Concluido') d
			JOIN ventad t WITH (NOLOCK)
				ON t.id = d.id
				AND precio > 0
			GROUP BY d.Padremavi,
							 d.Padreidmavi,
							 t.articulo

		IF EXISTS (SELECT
				NAME
			FROM TEMPDB.SYS.SYSOBJECTS
			WHERE ID = OBJECT_ID('Tempdb.dbo.#detalle')
			AND TYPE = 'U')
			DROP TABLE #detalle

		SELECT
			Ar.PadreMAVI,
			Ar.PadreIDMAVI,
			Ar.Articulo,
			Ar.impoart - ISNULL(ac.impocanc, 0.00) impoart,
			Ar.Linea INTO #detalle
		FROM (SELECT
			b.PadreMAVI,
			b.PadreIDMAVI,
			CASE
				WHEN PadreMAVI != 'Refinanciamiento' THEN vd.Articulo
				ELSE 'Refinanciamiento'
			END Articulo,
			CASE
				WHEN PadreMAVI != 'Refinanciamiento' THEN (vd.Precio * cantidad)
				ELSE b.importefact
			END impoart,
			a.Linea
		FROM #Factura b
		LEFT JOIN Venta V WITH (NOLOCK)
			ON v.mov = b.PadreMAVI
			AND v.movid = b.padreidMavi
			AND v.estatus = 'concluido'
		LEFT JOIN Ventad vd WITH (NOLOCK)
			ON vd.id = v.id
		LEFT JOIN art a WITH (NOLOCK)
			ON a.Articulo = vd.Articulo) Ar
		LEFT JOIN #ArtCanc ac
			ON ac.Padremavi = Ar.PadreMAVI
			AND ac.Padreidmavi = Ar.PadreIDMAVI
			AND ac.artcancelado = Ar.Articulo

		IF EXISTS (SELECT TOP 1
				id
			FROM #Bonifaplica
			WHERE Bonificacion = 'Bonificacion Adelanto en Pagos')
		BEGIN

			--Bonificaciones PP ya aplicadas
			IF EXISTS (SELECT
					NAME
				FROM TEMPDB.SYS.SYSOBJECTS
				WHERE ID = OBJECT_ID('Tempdb.dbo.#otrosdatos')
				AND TYPE = 'U')
				DROP TABLE #otrosdatos

			SELECT
				d.*,
				bc.MontoBonif Boncc,
				ISNULL(BonifapliPP, 0.00) BonifapliPP INTO #otrosdatos
			FROM (SELECT
				d.PAdremavi,
				d.PAdreidMavi,
				SUM(Saldo) totSaldo,
				SUM(Moratorios) totMoratorios,
				SUM(ISNULL(MontoBonif, 0)) BonPP
			FROM #docs d
			LEFT JOIN #temp b
				ON d.Mov = b.Mov
				AND d.MovID = b.MovID
				AND b.Bonificacion LIKE '%Pago Puntual%'
			GROUP BY d.padremavi,
							 d.padreidmavi) D
			LEFT JOIN #temp bc
				ON d.PAdremavi = bc.Mov
				AND d.PAdreidMavi = bc.MovID
				AND bc.Bonificacion LIKE '%Contado Comercial%'
			LEFT JOIN #BonifapliPP ppa
				ON ppa.PadreMAVI = D.PadreMAVI
				AND ppa.PadreIDMAVI = D.PadreIDMAVI



			INSERT INTO #temp (Docto, IdBonificacion, Bonificacion, Estacion, Mov, Movid, PadreMAVI, PadreIDMAVI, ImporteFact, Importedoc
			, PorcBon, MontoBonif, Financiamiento, Factor, PlazoEjeFin, Documento1de, DocumentoTotal, Sucursal1, TipoSucursal, LineaVta, DiasMenoresA, DiasMayoresA, Idventa
			, UEN, Condicion, Ok, Okref, FechaEmisionFact, Vencimiento, idcrobo, LineaCelulares, LineaCredilanas, BaseParaAPlicar)

				SELECT
					dc.id Docto,
					B.idbonif,
					B.Bonificacion,
					dc.Estacion,
					dc.Mov,
					dc.movid,
					dc.PadreMAvi,
					dc.PadreIDMAVI,
					dc.ImportefactFin,
					dc.ImportefactFin / B.numdocs Importedoc,
					CASE
						WHEN dc.Vencimiento > CONVERT(datetime, CONVERT(varchar(10), GETDATE(), 10)) THEN B.Porcdescto
						ELSE 0.00
					END Porcdescto,
					CASE
						WHEN dc.Vencimiento > CONVERT(datetime, CONVERT(varchar(10), GETDATE(), 10)) THEN B.BonifAP
						ELSE 0.00
					END BonifAP,
					dc.Financiamiento,
					dc.Factor,
					dc.PlazoEjeFin,
					dc.Documento1de,
					B.numdocs,
					Dc.Sucursal1,
					Dc.TipoSucursal,
					dc.LineaVta,
					dc.DiasMenoresA,
					dc.DiasMayoresA,
					dc.Idventa,
					dc.UEN,
					dc.Condicion,
					dc.Ok,
					dc.Okref,
					dc.FechaEmisionFact,
					dc.Vencimiento,
					dc.idcrobo,
					dc.LineaCelulares,
					dc.LineaCredilanas,
					0 BAseparaaplicar --este ultimo me falta
				FROM (-- B
				SELECT
					idbonif,
					Bonificacion,
					PadreMAVI,
					PadreIDMAVI,
					CASE
						WHEN (totSaldo - BonifAPCC) <= @ImporteTotal THEN ROUND(BonifAPCC / numdocspend, 2)
						ELSE ROUND(BonifAPPP / numdocspend, 2)
					END BonifAP,
					numdocs,
					Porcdescto,
					totSaldo
				FROM (-- G
				SELECT
					F.idbonif,
					F.Bonificacion,
					F.PadreMAVI,
					F.PadreIDMAVI,
					ROUND(SUM(importe_apcc * (Porcdescto / 100)), 2) BonifAPCC,
					ROUND(SUM(importe_appp * (Porcdescto / 100)), 2) BonifAPPP,
					F.numdocs,
					Porcdescto,
					totSaldo,
					F.numdocspend
				FROM ( -- F
				SELECT
					Bf.*,
					((vd.impoart - otrasbonifccxart - (F.Monedero * (vd.impoart / F.Importefact))) / F.numdocs) * numdocsadel importe_apcc,
					((vd.impoart - otrasbonifppxart - (F.Monedero * (vd.impoart / F.Importefact))) / F.numdocs) * numdocsadel importe_appp,
					Porcdescto = numdocsadel * CASE
						WHEN ISNULL(ml.PorcLin, 0) > 0 THEN ml.PorcLin
						ELSE Porcbon1
					END,
					vd.articulo,
					vd.impoart,
					F.importefact,
					F.numdocs
				FROM ( --Bf
				SELECT
					a.*,
					SUM(CASE
						WHEN D.mov = 'Documento' AND
							D.vencimiento > CONVERT(datetime, CONVERT(varchar(10), GETDATE(), 10)) THEN 1
						ELSE 0
					END) numdocsadel,
					SUM(CASE
						WHEN estatus = 'Pendiente' THEN 1
						ELSE 0
					END) numdocspend,
					otrasBonifPP / a.totart otrasbonifppxart,
					otrasBonifcc / a.totart otrasbonifccxart
				FROM (-- a
				SELECT
					b.idbonif,
					b.Bonificacion,
					b.PadreMAVI,
					b.PadreIDMAVI,
					ba.BonPP + ba.BonifapliPP otrasBonifPP,
					ba.Boncc + ba.BonifapliPP otrasBonifcc,
					ba.totSaldo,
					b.factor,
					b.totart,
					b.Porcbon1
				FROM ( -- b
				SELECT
					bn.id idbonif,
					bn.Bonificacion,
					bn.PadreMAVI,
					bn.PadreIDMAVI,
					bn.factor,
					COUNT(d.articulo) totart,
					bn.Porcbon1
				FROM #Bonifaplica bn
				LEFT JOIN #detalle d
					ON d.PadreMAVI = bn.PadreMAVI
					AND d.PadreIDMAVI = bn.PadreIDMAVI
				WHERE bn.Bonificacion = 'Bonificacion Adelanto en Pagos'
				GROUP BY bn.padremavi,
								 bn.Bonificacion,
								 bn.padreidmavi,
								 bn.factor,
								 bn.id,
								 bn.Porcbon1) b
				LEFT JOIN #otrosdatos ba
					ON ba.PadreMAVI = b.PadreMAVI
					AND ba.PadreIDMAVI = b.PadreIDMAVI
				GROUP BY b.idbonif,
								 b.Bonificacion,
								 b.PadreMAVI,
								 b.PadreIDMAVI,
								 b.factor,
								 b.totart,
								 ba.BonPP,
								 ba.BonifapliPP,
								 ba.Boncc,
								 ba.totSaldo,
								 b.Porcbon1) a
				LEFT JOIN #Docs D
					ON a.PadreMAVI = D.PadreMAVI
					AND a.PadreIDMAVI = D.PadreIDMAVI
					AND D.Mov != D.PadreMAVI
				WHERE D.mov = 'Documento'
				AND D.vencimiento > CONVERT(datetime, CONVERT(varchar(10), GETDATE(), 10))
				GROUP BY a.idbonif,
								 a.Bonificacion,
								 a.PadreMAVI,
								 a.PadreIDMAVI,
								 a.factor,
								 a.totart,
								 a.otrasBonifPP,
								 a.otrasBonifcc,
								 a.totSaldo,
								 a.porcbon1) Bf
				LEFT JOIN #Factura F
					ON F.PadreMAVI = Bf.PadreMAVI
					AND F.PadreIDMAVI = Bf.PadreIDMAVI
				LEFT JOIN #detalle vd
					ON vd.PadreMAVI = Bf.PadreMAVI
					AND vd.PadreIDMAVI = Bf.PadreIDMAVI
				LEFT JOIN MaviBonificacionLinea ml WITH (NOLOCK)
					ON bf.idbonif = ml.IdBonificacion
					AND vd.linea = ml.Linea) F
				GROUP BY F.idbonif,
								 F.Bonificacion,
								 F.PadreMAVI,
								 F.PadreIDMAVI,
								 F.numdocspend,
								 F.numdocs,
								 F.Porcdescto,
								 F.totSaldo) G) B
				LEFT JOIN #Bonficaciones dc
					ON dc.PadreMAVI = B.PadreMAVI
					AND dc.PadreIDMAVI = B.PadreIDMAVI

		END -- bonif AP

	END -- Fin si hay bonificaiones distinta a PP y  CC


	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#totpend')
		AND TYPE = 'U')
		DROP TABLE #totpend

	SELECT
		Padremavi,
		PadreidMavi,
		COUNT(id) totpendientes INTO #totpend
	FROM #docs
	WHERE estatus = 'pendiente'
	GROUP BY Padremavi,
					 PadreidMavi


	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Final')
		AND TYPE = 'U')
		DROP TABLE #Final

	SELECT
		ROW_NUMBER() OVER (ORDER BY vencimiento) enum,
		id,
		PAdremavi,
		padreidmavi,
		ROUND(MAX(Saldo), 4) Saldo,
		ROUND(MAX(moratorios), 4) Moratorios,
		ROUND(MAX(Saldo) - (MAX(BCC) / COUNT(id)) - MAX(BAP), 2) + CASE
			WHEN CobxPol = 'NO' THEN ROUND(MAX(moratorios), 4)
			ELSE 0.00
		END PagoTotal,
		ROUND(MAX(Saldo) - MAX(BPP), 2) + CASE
			WHEN CobxPol = 'NO' THEN ROUND(MAX(moratorios), 4)
			ELSE 0.00
		END CubrePP,
		ROUND(MAX(BPP), 2) BonifPP,
		ROUND(MAX(BAP), 2) BonifAP INTO #Final
	FROM (SELECT
		d.id,
		d.PAdremavi,
		d.padreidmavi,
		d.saldo,
		d.moratorios,
		d.Vencimiento,
		ISNULL(t.MontoBonif / totpendientes, 0.00) BCC,
		CASE
			WHEN td.Bonificacion LIKE '%Pago Puntual%' THEN ISNULL(td.MontoBonif, 0.00)
			ELSE 0.00
		END BPP,
		CASE
			WHEN td.Bonificacion LIKE '%Adelanto%' THEN ISNULL(td.MontoBonif, 0.00)
			ELSE 0.00
		END BAP,
		d.CobxPol
	FROM (--d
	SELECT
		dcs.id,
		dcs.padremavi,
		dcs.padreidmavi,
		dcs.Saldo,
		moratorios,
		t.totpendientes,
		Vencimiento,
		CobxPol
	FROM #docs dcs
	LEFT JOIN #Factura F
		ON F.padremavi = dcs.padremavi
		AND F.padreidmavi = dcs.padreidmavi
	LEFT JOIN #totpend t
		ON t.padremavi = F.padremavi
		AND t.padreidmavi = F.padreidmavi
	WHERE dcs.estatus = 'pendiente') d
	LEFT JOIN #temp t
		ON t.padremavi = d.padremavi
		AND t.padreidmavi = d.padreidmavi
		AND t.Bonificacion LIKE '%Bonificacion Contado Comercial%'
	LEFT JOIN #temp td
		ON d.id = td.Docto
		AND td.Bonificacion NOT LIKE '%Bonificacion Contado Comercial%') dc
	GROUP BY PAdremavi,
					 padreidmavi,
					 id,
					 vencimiento,
					 CobxPol


	--- Quitar las Bonificaciones que no se incluyen
	IF EXISTS (SELECT
			COUNT(idbonificacion)
		FROM #temp
		WHERE Bonificacion LIKE '%Adelanto en Pagos%')
	BEGIN
		IF (SELECT
				COUNT(idbonificacion)
			FROM #temp
			WHERE Bonificacion LIKE '%Contado Comercial%')
			= 1
			AND (SELECT
				SUM(PagoTotal + Moratorios)
			FROM #Final)
			<= @ImporteTotal
		BEGIN
			IF NOT EXISTS (SELECT
					t.idbonificacion
				FROM #temp t
				JOIN MaviBonificacionIncluye i WITH (NOLOCK)
					ON i.IdBonificacion = t.IdBonificacion
					AND i.BonificacionNo = 'Bonificacion Adelanto en Pagos'
					AND i.EnCascada != 'no'
				WHERE t.Bonificacion LIKE '%Contado Comercial%')
				DELETE FROM #Bonifaplica
				WHERE bonificacion = 'Bonificacion Adelanto en Pagos'
		END

		IF (SELECT
				COUNT(idbonificacion)
			FROM #temp
			WHERE Bonificacion LIKE '%Pago Puntual%')
			= 1
			AND (SELECT
				SUM(Saldo + Moratorios) - SUM(BonifPP) - SUM(BonifAP)
			FROM #Final)
			<= @ImporteTotal
		BEGIN
			IF NOT EXISTS (SELECT
					t.IdBonificacion
				FROM #temp t
				JOIN MaviBonificacionIncluye i WITH (NOLOCK)
					ON i.IdBonificacion = t.IdBonificacion
					AND i.BonificacionNo = 'Bonificacion Adelanto en Pagos'
					AND i.EnCascada != 'no'
				WHERE t.Bonificacion LIKE '%Adelanto en Pagos%')
				DELETE FROM #Bonifaplica
				WHERE bonificacion = 'Bonificacion Adelanto en Pagos'
		END

	END -- fIN SI EXISTE  Adelanto en Pagos 


	DECLARE @Ini int,
					@Fin int

	SELECT
		@Ini = MIN(enum) + 1,
		@Fin = MAX(enum)
	FROM #Final

	WHILE @Ini <= @Fin
	BEGIN
		UPDATE #Final
		SET CubrePP = CubrePP + (SELECT
			CubrePP
		FROM #Final
		WHERE enum = @Ini - 1)
		WHERE enum = @Ini

		SET @Ini = @Ini + 1
	END

	-- pagototal es el saldo menos CC y menosd AP
	IF (SELECT
			COUNT(idbonificacion)
		FROM #temp
		WHERE Bonificacion LIKE '%Contado Comercial%')
		= 1
		AND (SELECT
			SUM(PagoTotal + Moratorios)
		FROM #Final)
		<= @ImporteTotal
		INSERT INTO MaviBonificacionTest (Docto, IdBonificacion, Bonificacion, Estacion, Mov, Movid, Origen, OrigenId, ImporteVenta, ImporteDocto
		, PorcBon1, MontoBonif, Financiamiento, Factor, PlazoEjeFin, Documento1de, DocumentoTotal, Sucursal1, TipoSucursal, LineaVta, DiasMenoresA, DiasMayoresA, Idventa
		, UEN, Condicion, Ok, Okref, FechaEmision, Vencimiento, idcobro, LineaCelulares, LineaCredilanas, BaseParaAPlicar)

			SELECT
				Docto,
				IdBonificacion,
				Bonificacion,
				Estacion,
				Mov,
				Movid,
				PadreMAVI,
				PadreIDMAVI,
				ImporteFact,
				Importedoc,
				PorcBon,
				MontoBonif,
				Financiamiento,
				Factor,
				PlazoEjeFin,
				Documento1de,
				DocumentoTotal,
				Sucursal1,
				TipoSucursal,
				LineaVta,
				DiasMenoresA,
				DiasMayoresA,
				Idventa,
				UEN,
				Condicion,
				Ok,
				Okref,
				FechaEmisionFact,
				Vencimiento,
				idcrobo,
				LineaCelulares,
				LineaCredilanas,
				BaseParaAPlicar
			FROM #temp
			WHERE Bonificacion NOT LIKE '%Pago Puntual%'

	ELSE
	IF (SELECT
			SUM(Saldo + Moratorios) - SUM(BonifPP) - SUM(BonifAP)
		FROM #Final)
		<= @ImporteTotal
		INSERT INTO MaviBonificacionTest (Docto, IdBonificacion, Bonificacion, Estacion, Mov, Movid, Origen, OrigenId, ImporteVenta, ImporteDocto
		, PorcBon1, MontoBonif, Financiamiento, Factor, PlazoEjeFin, Documento1de, DocumentoTotal, Sucursal1, TipoSucursal, LineaVta, DiasMenoresA, DiasMayoresA, Idventa
		, UEN, Condicion, Ok, Okref, FechaEmision, Vencimiento, idcobro, LineaCelulares, LineaCredilanas, BaseParaAPlicar)
			SELECT
				Docto,
				IdBonificacion,
				Bonificacion,
				Estacion,
				Mov,
				Movid,
				PadreMAVI,
				PadreIDMAVI,
				ImporteFact,
				Importedoc,
				PorcBon,
				MontoBonif,
				Financiamiento,
				Factor,
				PlazoEjeFin,
				Documento1de,
				DocumentoTotal,
				Sucursal1,
				TipoSucursal,
				LineaVta,
				DiasMenoresA,
				DiasMayoresA,
				Idventa,
				UEN,
				Condicion,
				Ok,
				Okref,
				FechaEmisionFact,
				Vencimiento,
				idcrobo,
				LineaCelulares,
				LineaCredilanas,
				BaseParaAPlicar
			FROM #temp
			WHERE Bonificacion NOT LIKE '%Contado Comercial%'
	ELSE
		INSERT INTO MaviBonificacionTest (Docto, IdBonificacion, Bonificacion, Estacion, Mov, Movid, Origen, OrigenId, ImporteVenta, ImporteDocto
		, PorcBon1, MontoBonif, Financiamiento, Factor, PlazoEjeFin, Documento1de, DocumentoTotal, Sucursal1, TipoSucursal, LineaVta, DiasMenoresA, DiasMayoresA, Idventa
		, UEN, Condicion, Ok, Okref, FechaEmision, Vencimiento, idcobro, LineaCelulares, LineaCredilanas, BaseParaAPlicar)
			SELECT
				Docto,
				IdBonificacion,
				Bonificacion,
				Estacion,
				Mov,
				Movid,
				PadreMAVI,
				PadreIDMAVI,
				ImporteFact,
				Importedoc,
				PorcBon,
				MontoBonif,
				Financiamiento,
				Factor,
				PlazoEjeFin,
				Documento1de,
				DocumentoTotal,
				Sucursal1,
				TipoSucursal,
				LineaVta,
				DiasMenoresA,
				DiasMayoresA,
				Idventa,
				UEN,
				Condicion,
				Ok,
				Okref,
				FechaEmisionFact,
				Vencimiento,
				idcrobo,
				LineaCelulares,
				LineaCredilanas,
				BaseParaAPlicar
			FROM #temp
			WHERE Bonificacion LIKE '%Pago Puntual%'

	IF @ImporteTotal >= (SELECT
			SUM(PagoTotal)
		FROM #Final)
		SELECT
			@ImporteTotal = SUM(Saldo) + SUM(Moratorios)
		FROM #Final
	ELSE
	IF @ImporteTotal >= (SELECT
			SUM(Saldo + Moratorios) - SUM(BonifPP) - SUM(BonifAP)
		FROM #Final)
		SELECT
			@ImporteTotal = SUM(Saldo) + SUM(Moratorios)
		FROM #Final
	ELSE
	IF @ImporteTotal < (SELECT
			SUM(PagoTotal)
		FROM #Final)
		SELECT
			@ImporteTotal = ISNULL(SUM(BonifPP), 0) + @ImporteTotal  -- Nota: Se realiza ajuste para cuando la bonificacion sea mayor al saldo del doc ponga el saldo 
		FROM (SELECT
			CASE
				WHEN BonifPP > saldo THEN saldo
				ELSE BonifPP
			END AS BonifPP
		FROM #Final
		WHERE CubrePP <= @ImporteTotal) F

	SELECT
		@ImporteTotal


	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Factura')
		AND TYPE = 'U')
		DROP TABLE #Factura
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Docs')
		AND TYPE = 'U')
		DROP TABLE #Docs
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Bonifaplica')
		AND TYPE = 'U')
		DROP TABLE #Bonifaplica
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Bonficaciones')
		AND TYPE = 'U')
		DROP TABLE #Bonficaciones
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#temp')
		AND TYPE = 'U')
		DROP TABLE #temp
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#BonifapliPP')
		AND TYPE = 'U')
		DROP TABLE #BonifapliPP
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#ArtCanc')
		AND TYPE = 'U')
		DROP TABLE #ArtCanc
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#detalle')
		AND TYPE = 'U')
		DROP TABLE #detalle
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#otrosdatos')
		AND TYPE = 'U')
		DROP TABLE #otrosdatos
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#totpend')
		AND TYPE = 'U')
		DROP TABLE #totpend
	IF EXISTS (SELECT
			NAME
		FROM TEMPDB.SYS.SYSOBJECTS
		WHERE ID = OBJECT_ID('Tempdb.dbo.#Final')
		AND TYPE = 'U')
		DROP TABLE #Final

END -- Fin del SP
