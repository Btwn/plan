SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT - 1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO

-- ========================================================================================================================================
-- NOMBRE    	: sp_AuxNotVtasCredMAVI
-- AUTOR			: ¿?
-- FECHA CREACION	: ¿?
-- DESARROLLO		: RM0741 VENTAS AUXILIAR NOTAS CREDILANA
-- MODULO			: CONT
-- DESCRIPCION		: exec sp_AuxNotVtasCredMAVI '20150401','20150430', null, 'CONCLUIDO', 'Credilanas'
-- ========================================================================================================================================
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:     26/10/2010      Por: ANDRES VELAZQUEZ, SE LE AÑADIO LOS REFINANCIAMIENTOS DE CXC
-- FECHA Y AUTOR MODIFICACION:     11/07/2019      Por: Israel García. Se quitó la Union para hacer las inserciones por separado.
--													Se cambió para obtener la categoria del canal de "VentasCanalMavi" y no de la
--													tabla de "Canales de venta del Cliente"
--													Se agregó los impuestos en el apartado de Facturas porque erroneamente no se incluyeron
--													Se quitasron las variables tipo tabla y se reemplazaron por tablas temporales
--													Por el cambio de la consulta tampoco ya no son necesarios los Group by
-- ========================================================================================================================================

ALTER PROC [dbo].[sp_AuxNotVtasCredMAVI] @FechaD datetime, @FechaA datetime, @sucu int, @Estatus varchar(20), @movi varchar(20)

AS
  DECLARE @sucu1 int,
          @Estatus1 varchar(20),
          @Sum112 float,
          @Sum13 float

  IF EXISTS (SELECT
      NAME
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('TEMPDB.DBO.#AuxNotVen')
    AND Type = 'U')
    DROP TABLE #AuxNotVen

  IF EXISTS (SELECT
      NAME
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('TEMPDB.DBO.#AuxNotVenT')
    AND Type = 'U')
    DROP TABLE #AuxNotVenT

	CREATE TABLE #AuxNotVen
	(ID int,
    Sucursal int,
    Mov varchar(20),
    MovID varchar(10),
    FechaEmision datetime,
    Cliente varchar(20),
    Categoria varchar(20),
    Plazo int,
    Vencimiento datetime,
    ImporteTotal float,
    Capital float,
    MesesGarantia int,
    TipoVenta int
  ) ON [PRIMARY]


  CREATE TABLE #AuxNotVent (
    TipoVentat int,
    Suma112 float,
    Suma13 float
  ) ON [PRIMARY]

  SET @Sucu1 = @sucu
  SET @estatus1 = @estatus
  SET @Sum112 = 0
  SET @Sum13 = 0

  IF (@sucu = ''
    OR @sucu IS NULL)
  BEGIN
    SELECT
      @sucu1 = MIN(Sucursal),
      @Sucu = MAX(Sucursal)
    FROM Sucursal WITH (NOLOCK)
  END

  IF (@estatus = ''
    OR @estatus IS NULL)
  BEGIN
    SET @estatus1 = 'CANCELADO'
    SET @estatus = 'CONCLUIDO'
  END

  ----------------Credilanas
  IF (@movi = 'Credilanas')
  BEGIN
    INSERT INTO #AuxNotVen (ID, Sucursal, Mov, MovID, FechaEmision, Cliente, ENV.CATEGORIA, Plazo, Vencimiento, ImporteTotal, Capital, MesesGarantia, TipoVenta)
      SELECT
        a.ID,
        a.Sucursal,
        a.Mov,
        a.MovID,
        a.FechaEmision,
        a.Cliente,
        ENV.CATEGORIA,
        Plazo = ISNULL(c.DANumeroDocumentos, 0),
        a.Vencimiento,
        ImporteTotal = ISNULL(a.Importe, 0),
        Capital = ISNULL(a.Importe, 0) - ISNULL(b.Financiamiento, 0.00),
        MesesGarantia = (DATEDIFF(m, a.FechaEmision, a.Vencimiento) - 1),
        a.Mayor12meses
      FROM Venta a WITH (NOLOCK)
      INNER JOIN CXC b WITH (NOLOCK)
        ON a.Cliente = b.CLiente
        AND a.mov = b.mov
        AND a.movid = b.movid
      LEFT OUTER JOIN Condicion c WITH (NOLOCK)
        ON a.Condicion = c.condicion
      LEFT JOIN VentasCanalMAVI ENV WITH (NOLOCK)
        ON A.ENVIARA = ENV.ID
      WHERE a.Mov IN ('CREDILANA', 'PRESTAMO PERSONAL')
      AND a.FechaEmision BETWEEN @FechaD AND @FechaA
      AND a.Sucursal BETWEEN @sucu1 AND @Sucu
      AND (a.Estatus = @Estatus
      OR a.Estatus = @Estatus1)
      AND a.Importe <> 0


    INSERT INTO #AuxNotVen (ID, Sucursal, Mov, MovID, FechaEmision, Cliente, ENV.CATEGORIA, Plazo, Vencimiento, ImporteTotal, Capital, MesesGarantia, TipoVenta)
      SELECT
        C.ID,
        C.SUCURSAL,
        C.MOV,
        C.MOVID,
        C.FECHAEMISION,
        C.CLIENTE,
        ENV.CATEGORIA,
        Plazo = ISNULL(LEFT(C.CONDICION, 2), 0),
        C.VENCIMIENTO,
        ImporteTotal = (ISNULL(C.IMPORTE + C.IMPUESTOS, 0)),
        Capital = (ISNULL(C.IMPORTE + C.IMPUESTOS, 0) - ISNULL(C.FINANCIAMIENTO, 0)),
        MesesGarantia = (DATEDIFF(M, C.FECHAEMISION, C.VENCIMIENTO) - 1),
        C.MAYOR12MESES
      FROM CXC C WITH (NOLOCK) --INNER JOIN CXCD D ON C.ID = D.ID
      -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
      LEFT JOIN VentasCanalMAVI ENV WITH (NOLOCK)
        ON C.CLIENTEENVIARA = ENV.ID
      -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

      WHERE C.Mov IN ('Refinanciamiento')
      AND C.FechaEmision BETWEEN @FechaD AND @FechaA
      AND C.Sucursal BETWEEN @sucu1 AND @Sucu
      AND (C.Estatus = @Estatus
      OR C.Estatus = @Estatus1)
      AND C.Importe <> 0


    SET @Sum112 = (SELECT
      SUM(ImporteTotal)
    FROM #AuxNotVen
    WHERE TipoVenta = 0)

    SET @Sum13 = (SELECT
      SUM(ImporteTotal)
    FROM #AuxNotVen
    WHERE TipoVenta = 1)

    INSERT INTO #AuxNotVenT (TipoVentat, Suma112, Suma13)
      SELECT
        0,
        @Sum112,
        @Sum13

  END

  IF (@movi = 'Facturas')

  BEGIN
    ----------------Facturas 
    INSERT INTO #AuxNotVen (ID, Sucursal, Mov, MovID, FechaEmision, Cliente, CATEGORIA, Plazo, Vencimiento, ImporteTotal, Capital, MesesGarantia, TipoVenta)
      SELECT
        a.ID,
        a.Sucursal,
        a.Mov,
        a.MovID,
        a.FechaEmision,
        a.Cliente,
        ENV.CATEGORIA,
        Plazo = ISNULL(c.DANumeroDocumentos, 0),
        a.Vencimiento,
        ImporteTotal = ISNULL(a.Importe, 0) + ISNULL(a.Impuestos, 0),
        Capital = ISNULL(a.Importe, 0) + ISNULL(a.Impuestos, 0),
        MesesGarantia = (DATEDIFF(m, a.FechaEmision, a.Vencimiento) - 1),
        a.Mayor12meses
      FROM Venta a WITH (NOLOCK)
      LEFT OUTER JOIN Condicion c WITH (NOLOCK)
        ON a.Condicion = c.condicion
      -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
      LEFT JOIN VentasCanalMAVI ENV WITH (NOLOCK)
        ON A.ENVIARA = ENV.ID
      -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
      WHERE a.Mov IN ('FACTURA', 'FACTURA MAYOREO', 'FACTURA VIU')
      AND a.Mayor12meses IS NOT NULL
      AND a.FechaEmision BETWEEN @FechaD AND @FechaA
      AND a.Sucursal BETWEEN @sucu1 AND @Sucu
      AND (a.Estatus = @Estatus
      OR a.Estatus = @Estatus1)


    SET @Sum112 = (SELECT
      SUM(ImporteTotal)
    FROM #AuxNotVen
    WHERE TipoVenta = 0)

    SET @Sum13 = (SELECT
      SUM(ImporteTotal)
    FROM #AuxNotVen
    WHERE TipoVenta = 1)

    INSERT INTO #AuxNotVenT (TipoVentat, Suma112, Suma13)
      SELECT 
        1,
        @Sum112,
        @Sum13


  END

  SELECT
    *
  FROM #AuxNotVen,
       #AuxNotVenT
  ORDER BY TipoVenta, mov, movid, fechaemision, sucursal

  IF EXISTS (SELECT
      NAME
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('TEMPDB.DBO.#AuxNotVen')
    AND Type = 'U')
    DROP TABLE #AuxNotVen

  IF EXISTS (SELECT
      NAME
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('TEMPDB.DBO.#AuxNotVenT')
    AND Type = 'U')
    DROP TABLE #AuxNotVenT

-- exec sp_AuxNotVtasCredMAVI '2010-08-01','2010-08-31',NULL,'CONCLUIDO','Credilanas'

GO
