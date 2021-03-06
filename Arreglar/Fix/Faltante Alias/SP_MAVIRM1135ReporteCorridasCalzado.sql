USE [IntelisisTmp]
GO
/****** Object:  StoredProcedure [dbo].[SP_MAVIRM1135ReporteCorridasCalzado]    Script Date: 09/07/2019 02:35:08 p. m. ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
---- ======================================================================================================================================================== 
---- NOMBRE   : SP_MAVIRM1135ReporteCorridasCalzado
---- AUTOR   : Erika Jeanette Perez Orozco
---- FECHA CREACION : 15/06/2016
---- DESARROLLO  : RM1135 ReporteCorridasCalzado
---- DESCRIPCION  : Reporte para verificar existencias de calzado
---- EJEMPLO   : exec SP_MAVIRM1135ReporteCorridasCalzado'CALZADO','MERCANCIA DE LINEA','CALZADO UNISEX','1,2,3,4,5,6,7,8,9'
---- ========================================================================================================================================================
---- FECHA Y AUTOR MODIFICACION:     24/09/2016      Por: Hernandez Cajero Moises Adrian
---- Se consideran tambien las existencias dentro de la sucursal 96
---- ========================================================================================================================================================
---- FECHA Y AUTOR MODIFICACION:     20/02/2017      Por: Perez Orozco Erika Jeanette
---- ========================================================================================================================================================
---- FECHA Y AUTOR MODIFICACION:     10/02/2018      Por: Luis Ramon Valencia
---- Se agrega el movimiento, la fecha de emision y el codigo de articulo de la ultima corrida en que se vendio el calzado 
---- ========================================================================================================================================================   
---- FECHA Y AUTOR MODIFICACION:     10/07/2018      Por: Luis Ramon Valencia
---- Se agrega la sucursal en la tabla  #MovFinalCorrida para poder particionar por PROPIEDAD y Sucursal
---- ========================================================================================================================================================    
---- FECHA Y AUTOR MODIFICACION:     14/08/2018      Por: Luis Ramon Valencia
---- Se agregaron dos columnas al reporte para reflejar los movimientos de entrada con su respectiva fecha de los articulos calzado desabasto de las sucursales
---- ========================================================================================================================================================     

ALTER PROCEDURE [dbo].[SP_MAVIRM1135ReporteCorridasCalzado] @Familia varchar(max),
@Grupo varchar(max),
@Linea varchar(max),
@Sucursal varchar(max)
AS
BEGIN

  SET @Familia = REPLACE(@Familia, ',', ''',''')
  SET @Grupo = REPLACE(@Grupo, ',', ''',''')
  SET @Linea = REPLACE(@Linea, ',', ''',''')
  SET @Sucursal = REPLACE(@Sucursal, ',', ''',''')

  SET @Familia = CHAR(39) + @Familia + CHAR(39)
  SET @Grupo = CHAR(39) + @Grupo + CHAR(39)
  SET @Linea = CHAR(39) + @Linea + CHAR(39)
  SET @Sucursal = CHAR(39) + @Sucursal + CHAR(39)

  DECLARE @Sucursal2 varchar(max)
  SET @Sucursal2 = @Sucursal
  SET @Sucursal2 = REPLACE(@Sucursal2, '''', '')

  DECLARE @SQL varchar(max)
  SET @SQL = ('select a.linea,a.articulo, a.Descripcion1 ,p.Propiedad,suc.Sucursal,sum(disponible)EXISTENCIAS,''NO'' 
          from Art  A with(nolock) 
          Inner Join Prop P with(nolock) on A.Articulo=P.Cuenta and P.Tipo=''Corrida''
          Left Join Artdisponible AD with(nolock) on AD.Articulo=A.Articulo 
          Inner join sucursal suc with(nolock) on suc.almacenPrincipal=ad.almacen
          Where a.Familia in(' + @Familia + ') and A.GRUPO in (' + @Grupo + ') and a.linea in  (' + @linea + ')  and sucursal in (' + @Sucursal + ')
          Group by  linea,descripcion1 ,propiedad ,sucursal,a.articulo')

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#sucursalTempora'))
    DROP TABLE #sucursalTempora

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#Propie'))
    DROP TABLE #Propie

  CREATE TABLE #sucursalTempora (
    Linea varchar(100) NULL,
    Articulo varchar(20) NULL,
    Descripcion varchar(100) NULL,
    Propiedad varchar(50) NULL,
    Sucursal int NOT NULL,
    existencias int NOT NULL,
    Mostar varchar(5) NULL
  )
  INSERT INTO #sucursalTempora
  EXEC (@SQL)

  SELECT
    COUNT(ARTICULO) Cont,
    SUCURSAL,
    Propiedad INTO #Propie
  FROM #sucursalTempora WITH (NOLOCK)
  WHERE 1 = 1
  AND existencias > 0
  GROUP BY SUCURSAL,
           PROPIEDAD
  HAVING COUNT(PROPIEDAD) < 3
  ORDER BY Sucursal

  UPDATE #sucursalTempora
  SET EXISTENCIAS = 0
  WHERE MOSTAR = 'SI'

  UPDATE S
  SET Mostar = 'SI'
  FROM #sucursalTempora S
  INNER JOIN #Propie P
    ON P.Propiedad = S.Propiedad
    AND P.Sucursal = S.Sucursal

  -->>>>>>>>>>>>>>>>>>>[INICIO - Bloque de codigo agregado 10/02/2018]<<<<<<<<<<<<<<<<<<<<<
  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#FactCorrida'))
    DROP TABLE #FactCorrida

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#AjusTrasCorrida'))
    DROP TABLE #AjusTrasCorrida
  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#MovFinalCorrida'))
    DROP TABLE #MovFinalCorrida

  SELECT --Se obtiene el universo de movimientos Ajuste y Salida Traspaso donde se le dio salida al calzado de la corrida 
    A.*,
    ROW_NUMBER() OVER (PARTITION BY Propiedad, sucursal ORDER BY Propiedad ASC, FechaRegistro DESC) AS Orden INTO #AjusTrasCorrida
  FROM (SELECT DISTINCT
    I.Mov,
    I.MovID,
    I.FechaRegistro,
    ID.Articulo,
    P.Propiedad,
    I.sucursal
  FROM Prop P WITH (NOLOCK)
  JOIN #sucursalTempora S
    ON S.Propiedad = P.Propiedad
    AND s.articulo = p.cuenta
  JOIN InvD ID WITH (NOLOCK)
    ON ID.Articulo = P.Cuenta
  JOIN Inv I WITH (NOLOCK)
    ON I.ID = ID.ID
  WHERE P.Tipo = 'Corrida'
  AND S.Mostar = 'SI'
  AND S.existencias < 1
  AND I.Estatus = 'CONCLUIDO'
  AND I.Mov IN ('Salida Traspaso')) A

  DELETE #AjusTrasCorrida
  WHERE Orden > 1 --Se dejan solo los movimientos con la fecha mas reciente para cada corrida del universo de Ajustes y Salidas Traspaso

  SELECT --Se obtiene el universo de movimientos tipo Factura donde se le dio salida al calzado de la corrida
    A.*,
    ROW_NUMBER() OVER (PARTITION BY Propiedad, sucursal ORDER BY Propiedad ASC, FechaRegistro DESC) AS Orden INTO #FactCorrida
  FROM (SELECT DISTINCT
    V.Mov,
    V.MovID,
    V.FechaRegistro,
    VD.Articulo,
    P.Propiedad,
    V.sucursal
  FROM Prop P WITH (NOLOCK)
  JOIN #sucursalTempora S
    ON S.Propiedad = P.Propiedad
  JOIN VentaD VD WITH (NOLOCK)
    ON VD.Articulo = P.Cuenta
  JOIN Venta V WITH (NOLOCK)
    ON V.ID = VD.ID
  WHERE P.Tipo = 'Corrida'
  AND S.Mostar = 'SI'
  AND S.existencias < 1
  AND V.Estatus = 'CONCLUIDO'
  AND V.Mov IN ('Factura', 'Factura VIU')) A

  DELETE #FactCorrida
  WHERE Orden > 1 --Se dejan solo los movimientos con la fecha mas reciente para cada corrida del universo de Facturas

  SELECT --Se unen los 2 universos anteriores para comparar sus fechas
    A.*,
    ROW_NUMBER() OVER (PARTITION BY Propiedad, sucursal ORDER BY Propiedad ASC, FechaRegistro DESC) AS Orden INTO #MovFinalCorrida
  FROM (SELECT
    Mov,
    MovID,
    FechaRegistro,
    Articulo,
    Propiedad,
    sucursal
  FROM #AjusTrasCorrida
  UNION ALL
  SELECT
    Mov,
    MovID,
    FechaRegistro,
    Articulo,
    Propiedad,
    sucursal
  FROM #FactCorrida) A
  ORDER BY Propiedad

  DELETE #MovFinalCorrida
  WHERE Orden > 1 --Luego de comparar las fechas solo quedara el movimiento mas reciente para cada corrida

  CREATE INDEX Index_Propiedad ON #MovFinalCorrida (Propiedad) --Se agrega el indice para mejor el rendimiento de la consulta

  --------------------------------------[ C O N S U L T A  F I N A L ]------------------------------------------
  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#ConsultaFinal'))
    DROP TABLE #ConsultaFinal

  SELECT
    st.ARTICULO,
    DESCRIPCION,
    st.PROPIEDAD,
    st.SUCURSAL AS SUC,
    ISNULL(NULLIF(CAST(EXISTENCIAS AS varchar(400)), 0), '') EXISTENCIAS,
    ad.Disponible AS CD,
    MFC.FechaRegistro,
    Codigo = MFC.Articulo,
    MFC.Mov,
    MFC.MovID INTO #ConsultaFinal
  FROM #sucursalTempora st
  INNER JOIN Art A WITH (NOLOCK)
    ON A.Articulo = st.Articulo
  INNER JOIN Prop P WITH (NOLOCK)
    ON A.Articulo = P.Cuenta
    AND P.Tipo = 'Corrida'
  LEFT JOIN Artdisponible AD WITH (NOLOCK)
    ON AD.Articulo = A.Articulo
  INNER JOIN sucursal su WITH (NOLOCK)
    ON su.AlmacenPrincipal = ad.almacen
  LEFT JOIN #MovFinalCorrida MFC
    ON MFC.Propiedad = st.Propiedad
    AND MFC.Sucursal = st.sucursal
  WHERE Mostar = 'SI'
  AND existencias > 0
  AND Su.Sucursal = 96
  GROUP BY st.Articulo,
           Descripcion,
           st.Propiedad,
           st.Sucursal,
           st.existencias,
           ad.Disponible,
           MFC.FechaRegistro,
           MFC.Articulo,
           MFC.Mov,
           MFC.MovID
  ORDER BY st.SUCURSAL

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#Movimiento'))
    DROP TABLE #Movimiento

  SELECT
    * INTO #Movimiento
  FROM (SELECT --Se obtiene el universo de movimientos Ajuste y Recibo Traspaso donde se le dio la entrada al calzado de la corrida 
    A.*,
    ROW_NUMBER() OVER (PARTITION BY Propiedad, sucursal ORDER BY Propiedad ASC, FechaRegistro DESC) AS Orden
  FROM (SELECT DISTINCT
    I.Mov,
    I.MovID,
    I.FechaRegistro,
    ID.Articulo,
    P.Propiedad,
    I.sucursal
  FROM Prop P WITH (NOLOCK)
  JOIN #sucursalTempora S
    ON S.Propiedad = P.Propiedad
  JOIN InvD ID WITH (NOLOCK)
    ON ID.Articulo = P.Cuenta
  JOIN Inv I WITH (NOLOCK)
    ON I.ID = ID.ID
  WHERE P.Tipo = 'Corrida'
  AND S.Mostar = 'SI'
  AND S.existencias <> ''
  AND I.Estatus = 'CONCLUIDO'
  AND I.Mov IN ('Ajuste', 'Recibo Traspaso')) A) r
  WHERE Orden = 1

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#MovimientoFactura'))
    DROP TABLE #MovimientoFactura

  SELECT
    * INTO #MovimientoFactura
  FROM (SELECT --Se obtiene el universo de movimientos tipo Devolucion donde se le dio entrada al calzado de la corrida
    A.*,
    ROW_NUMBER() OVER (PARTITION BY Propiedad, sucursal ORDER BY Propiedad ASC, FechaRegistro DESC) AS Orden
  FROM (SELECT DISTINCT
    V.Mov,
    V.MovID,
    V.FechaRegistro,
    VD.Articulo,
    P.Propiedad,
    V.sucursal
  FROM Prop P WITH (NOLOCK)
  JOIN #sucursalTempora S
    ON S.Propiedad = P.Propiedad
  JOIN VentaD VD WITH (NOLOCK)
    ON VD.Articulo = P.Cuenta
  JOIN Venta V WITH (NOLOCK)
    ON V.ID = VD.ID
  WHERE P.Tipo = 'Corrida'
  AND S.Mostar = 'SI'
  AND S.existencias <> ''
  AND V.Estatus = 'CONCLUIDO'
  AND V.Mov IN ('Devolucion Venta', 'Devolucion VIU')) A) f
  WHERE Orden = 1

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#TablasMovimientos'))
    DROP TABLE #TablasMovimientos

  SELECT
    * INTO #TablasMovimientos
  FROM (SELECT --Se unen los 2 universos anteriores para comparar sus fechas
    A.*,
    ROW_NUMBER() OVER (PARTITION BY Propiedad, sucursal ORDER BY Propiedad ASC, FechaRegistro DESC) AS Orden
  FROM (SELECT
    Mov,
    MovID,
    FechaRegistro,
    Articulo,
    Propiedad,
    sucursal
  FROM #Movimiento
  UNION ALL
  SELECT
    Mov,
    MovID,
    FechaRegistro,
    Articulo,
    Propiedad,
    sucursal
  FROM #MovimientoFactura) A) a
  WHERE Orden = 1
  ORDER BY Propiedad

  SELECT
  DISTINCT
    ARTICULO,
    DESCRIPCION,
    PROPIEDAD,
    SUC,
    EXISTENCIAS,
    CD,
    FechaRegistro,
    Codigo,
    Mov,
    UltimoIngreso,
    MovimientoIngreso,
    MovID
  FROM (SELECT
    c.*,
    v.FechaRegistro AS 'UltimoIngreso',
    v.Mov AS 'MovimientoIngreso'
  FROM #ConsultaFinal c
  JOIN #TablasMovimientos v
    ON (c.Propiedad = v.Propiedad
    AND V.Sucursal = c.Suc)) d
  ORDER BY SUC

  /*-------------------------------------------------ELIMINAR TABLAS-------------------------------------------------*/
  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#sucursalTempora'))
    DROP TABLE #sucursalTempora

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#Propie'))
    DROP TABLE #Propie

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#AjusTrasCorrida'))
    DROP TABLE #AjusTrasCorrida

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#FactCorrida'))
    DROP TABLE #FactCorrida

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#MovFinalCorrida'))
    DROP TABLE #MovFinalCorrida

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#ConsultaFinal'))
    DROP TABLE #ConsultaFinal

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#Movimiento'))
    DROP TABLE #Movimiento

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#MovimientoFactura'))
    DROP TABLE #MovimientoFactura

  IF EXISTS (SELECT
      id
    FROM tempdb.sys.sysobjects
    WHERE id = OBJECT_ID('TempDb.Dbo.#TablasMovimientos'))
    DROP TABLE #TablasMovimientos
END