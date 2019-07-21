SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spBonifMonto]
@IdCobro INT
AS
BEGIN

	IF EXISTS (SELECT NAME FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#totpendientes') AND TYPE = 'U')
		DROP TABLE #totpendientes

	SELECT N.idcobro
		  ,N.Origen
		  ,N.Origenid
		  ,COUNT(N.idcobro) Totptes
		  ,ISNULL(MontoBonif, 0.00) BCC
		  ,ISNULL(N2.Bonificacion, '') Bonificacioncc
		  ,n2.IdBonificacion
	INTO #totpendientes
	FROM NegociaMoratoriosMAVI n
	LEFT JOIN MaviBonificacionTest N2
		ON N.IDCobro = N2.IdCobro
		AND N.Origen = N2.Origen
		AND N.Origenid = N2.Origenid
	WHERE N.IDCobro = @IdCobro
	AND N2.Bonificacion LIKE '%Bonificacion Contado Comercial%'
	GROUP BY N.idcobro
			,N.Origen
			,N.Origenid
			,N2.Bonificacion
			,N2.MontoBonif
			,n2.IdBonificacion
	UPDATE Nm
	SET Nm.bonificacion = Bonificaciontot
	   ,Nm.ContadoComercial = Bf.BCC
	   ,Nm.PagoPuntual = Bf.BPP
	   ,Nm.AdelantoPagos = Bf.BAP
	   ,IdContadoComercial = IDBCC
	   ,IDPagoPuntual = IDBPP
	   ,IDAdelantoPagos = IDBAP
	FROM (
		SELECT idcobro
			  ,Mov
			  ,Movid
			  ,CASE
				   WHEN Bonificaciontot > ImporteReal THEN ImporteReal
				   ELSE Bonificaciontot
			   END Bonificaciontot
			  ,BCC
			  ,BPP
			  ,BAP
			  ,IDBCC
			  ,IDBPP
			  ,IDBAP
		FROM (
			SELECT idcobro
				  ,Mov
				  ,Movid
				  ,MAX(BCC) + MAX(BPP) + MAX(BAP) Bonificaciontot
				  ,MAX(BCC) BCC
				  ,MAX(BPP) BPP
				  ,MAX(BAP) BAP
				  ,MAX(IDBCC) IDBCC
				  ,MAX(IDBPP) IDBPP
				  ,MAX(IDBAP) IDBAP
				  ,ImporteReal
			FROM (
				SELECT N.idcobro
					  ,CASE
						   WHEN tp.Bonificacioncc LIKE '%Contado Comercial%'
							   AND ABS(ROUND(N.ImporteReal, 2) - ROUND(N.ImporteAPagar, 2)) <= 0.05 THEN ISNULL(tp.BCC, 0.00) / tp.Totptes
						   ELSE 0.00
					   END BCC
					  ,CASE
						   WHEN tp.Bonificacioncc LIKE '%Contado Comercial%'
							   AND ABS(ROUND(N.ImporteReal, 2) - ROUND(N.ImporteAPagar, 2)) <= 0.05 THEN tp.IdBonificacion
						   ELSE NULL
					   END IDBCC
					  ,CASE
						   WHEN N2.Bonificacion LIKE '%Pago Puntual%'
							   AND ABS(ROUND(N.ImporteReal, 2) - ROUND(N.ImporteAPagar, 2)) <= 0.05 THEN ISNULL(N2.MontoBonif, 0.00)
						   ELSE 0.00
					   END BPP
					  ,CASE
						   WHEN N2.Bonificacion LIKE '%Pago Puntual%'
							   AND ABS(ROUND(N.ImporteReal, 2) - ROUND(N.ImporteAPagar, 2)) <= 0.05 THEN n2.IdBonificacion
						   ELSE NULL
					   END IDBPP
					  ,CASE
						   WHEN N2.Bonificacion LIKE '%Adelanto%'
							   AND ABS(ROUND(N.ImporteReal, 2) - ROUND(N.ImporteAPagar, 2)) <= 0.05 THEN ISNULL(N2.MontoBonif, 0.00)
						   ELSE 0.00
					   END BAP
					  ,CASE
						   WHEN N2.Bonificacion LIKE '%Adelanto%'
							   AND ABS(ROUND(N.ImporteReal, 2) - ROUND(N.ImporteAPagar, 2)) <= 0.05 THEN n2.IdBonificacion
						   ELSE NULL
					   END IDBAP
					  ,N.mov
					  ,N.movid
					  ,tp.Totptes
					  ,N.ImporteReal
				FROM NegociaMoratoriosMAVI N
				LEFT JOIN #totpendientes tp
					ON tp.IDCobro = n.IDCobro
					AND tp.Origen = n.Origen
					AND tp.Origenid = n.Origenid
				LEFT JOIN MaviBonificacionTest N2
					ON N.IDCobro = N2.IdCobro
					AND N2.Mov = N.Mov
					AND N2.MovID = N.MovID
					AND N2.Bonificacion NOT LIKE '%Contado Comercial%'
				WHERE N.IDCobro = @IdCobro
			) pre
			GROUP BY idcobro
					,Mov
					,Movid
					,ImporteReal
		) rev
	) Bf
	JOIN NegociaMoratoriosMAVI Nm
		ON Nm.IDCobro = Bf.IdCobro
		AND Nm.Mov = Bf.Mov
		AND Nm.MovID = Bf.MovID
	RETURN

	IF EXISTS (SELECT NAME FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#totpendientes') AND TYPE = 'U')
		DROP TABLE #totpendientes

END

