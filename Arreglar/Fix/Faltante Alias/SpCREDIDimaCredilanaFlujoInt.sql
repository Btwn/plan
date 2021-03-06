SET DATEFIRST 7
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT - 1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
--========================================================================================================================================
-- NOMBRE      : SpCREDIDimaCredilanaFlujoInt
-- AUTOR      : César Omar Loza Martinez :)
-- FECHA CREACION	: 12/02/2018
-- DESARROLLO		: FLUJO INTELISIS APP DIMA ELITE
-- MODULO			: CREDITO
-- DESCRIPCION		: Crea una Solicitud de Credito con cada uno de los Registros de Android con Estatus 2. 
-- EJEMPLO			: EXEC SpCREDIDimaCredilanaFlujoInt
--========================================================================================================================================
--MODIFICACION: 16/06/2018 Alejandra García , se agregó el campo ServicioTipoOperacion en 1 a la tabla venta para que los movimientos no sean visibles para ventas mientras se realiza el proceso
--========================================================================================================================================
--========================================================================================================================================
-- MODIFICACION: 10/08/2018 Adrian Hernandez  
-- Se optimiza codigo ya que hacia consultas redundantes y lectura de columnas inncesarias, 
-- se quito codigo hardcoded de la tabla VentaD
-- se adapto codigo para mercancia
--========================================================================================================================================
-- MODIFICACION: 18/06/2019 Adrian Hernandez  
-- Se hardcodea el usuario VENTR00053 que corresponde a la sucursal 30 de reactivacion para poder afectar las solicitudes de credito
--========================================================================================================================================
-- MODIFICACION: 26/06/2019 Jonathan Sampayo
-- Se añadió SerieMonedero y usuario genérico para facturas
--========================================================================================================================================
-- MODIFICACION: 13/07/2019 Fernando Romero Robles 
-- Se crea la variable usuario para que afecte con ella en vez del valor usuario incorrecto
--========================================================================================================================================

ALTER PROCEDURE [dbo].[SpCREDIDimaCredilanaFlujoInt]
AS
BEGIN
  DECLARE @IDVTA int, --------Guarda el Id que se le asigana a la venta
          @Mensaje varchar(max), -------- Muestra el mensajae de error si lo hay
          @DIMA varchar(20), --------Guarda el Cliente que se acaba de asignar a la Venta
          @Final varchar(20),-------- Guarda el Cliente Final que se acaba de asignar a la Venta
          @Articulo varchar(20),
          @QUERY varchar(max),
          @Condicion varchar(50),
          @SerieMonedero varchar(20),
          @Estatus varchar(30),
          @Usuario varchar(10)
  -------------Eliminacion de tablas temporales 
  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#RegistroPeticiones')
    AND TYPE = 'U')
    DROP TABLE #RegistroPeticiones

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#RegistrosAfectados')
    AND TYPE = 'U')
    DROP TABLE #RegistrosAfectados

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#Mensaje')
    AND TYPE = 'U')
    DROP TABLE #Mensaje

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#Estatus')
    AND TYPE = 'U')
    DROP TABLE #Estatus

  -------------Creacion de tablas temporales 
  CREATE TABLE #RegistroPeticiones (
    Indice int IDENTITY,
    Id int NULL,
    DIMA varchar(10),
    Final varchar(10),
    Articulo varchar(20),
    FechaRegistro datetime,
    IdEstatus int,
    MovIdCredilana varchar(20),
    FechaUltimoMov datetime,
    FechaExpiracion datetime,
    Calificacion int,
    Observaciones varchar(255),
    IntentosSMS int,
    FechaAutorizacion datetime,
    FechaDispersion datetime,
    FechaCobro datetime,
    FechaCancelacion datetime
  )

  CREATE TABLE #RegistrosAfectados (
    Id int NULL,
    Mov varchar(20) NULL,
    Usuario varchar(10) NULL,
    Estatus varchar(15) NULL,
    Cliente varchar(10) NULL,
    Ctefinal varchar(10) NULL,
    FolioFIADE int NULL
  )

  CREATE TABLE #Mensaje (
    Ok int NULL,
    OkDesc varchar(255) NULL,
    OkTipo varchar(50) NULL,
    OkRef varchar(255) NULL,
    IDGenerar int NULL
  )

  CREATE TABLE #Estatus (
    Estatus varchar(30) NULL
  )

  SET @Condicion = (SELECT
    Valor
  FROM MaviAndroid01.ServicioAndroid.dbo.TcAAea00030_ConfigParametros WITH (NOLOCK)
  WHERE Id = 12)

  DECLARE @DiasVencimiento int = (SELECT
    DiasVencimiento
  FROM Condicion WITH (NOLOCK)
  WHERE condicion = @Condicion)

  INSERT INTO #RegistroPeticiones (Id, DIMA, Final, Articulo, FechaRegistro, IdEstatus, MovIdCredilana, FechaUltimoMov, FechaExpiracion, Calificacion, Observaciones, IntentosSMS, FechaAutorizacion, FechaDispersion, FechaCobro, FechaCancelacion)
    SELECT
      Id,
      DIMA,
      Final,
      Articulo,
      FechaRegistro,
      IdEstatus,
      MovIdCredilana,
      FechaUltimoMov,
      FechaExpiracion,
      Calificacion,
      Observaciones,
      IntentosSMS,
      FechaAutorizacion,
      FechaDispersion,
      FechaCobro,
      FechaCancelacion
    FROM MaviAndroid01.ServicioAndroid.dbo.TrAAea00030_RegistroPeticiones WITH (NOLOCK)
    WHERE IdEstatus = 2

  DECLARE @IndexRow int = 1
  DECLARE @MaxRow int = (SELECT
    MAX(Indice)
  FROM #RegistroPeticiones)
  DECLARE @TipoArt varchar(10)
  DECLARE @IdRegistroP int


  WHILE (@IndexRow <= @MaxRow)
  BEGIN

    SELECT
      @DIMA = DIMA,
      @Final = Final,
      @IdRegistroP = Id,
      @TipoArt = Articulo
    FROM #RegistroPeticiones
    WHERE Indice = @IndexRow

    DECLARE @Capital money = (IIF(@TipoArt = 'MIXTO', (SELECT
      SUM((Precio * Cantidad))
    FROM MaviAndroid01.ServicioAndroid.dbo.CREDIDRegistroPeticiones WITH (NOLOCK)
    WHERE IdRegistroPeticiones = @IdRegistroP)
    , (SELECT
      Capital
    FROM art WITH (NOLOCK)
    WHERE Articulo = @TipoArt)
    ))


    DECLARE @Sucursal int = (SELECT TOP 1
      Sucursal
    FROM RegistroCte_final rf WITH (NOLOCK)
    JOIN #RegistroPeticiones s
      ON s.Final = rf.cte_final
    WHERE Registro IN ('alta', 'Nip')
    AND s.Indice = @IndexRow
    ORDER BY Fecha ASC)

    DECLARE @Agente varchar(10) = (SELECT
      Usuario
    FROM cte_final cf WITH (NOLOCK)
    JOIN #RegistroPeticiones s
      ON s.Final = cf.ClienteF
    WHERE s.Indice = @IndexRow)

    SET @Agente = (SELECT TOP 1
      agente
    FROM agente WITH (NOLOCK)
    WHERE categoria = 'VENTAS PISO'
    AND Tipo = 'VENDEDOR'
    AND agente = @Agente
    AND estatus = 'ALTA')

    DECLARE @AgenteG varchar(10) = (SELECT TOP 1
      Agente
    FROM agente WITH (NOLOCK)
    WHERE agente LIKE 'p%'
    AND estatus = 'alta'
    AND SucursalEmpresa = @Sucursal)

    INSERT INTO Venta (
    /*01*/Empresa, /*02*/ Mov, /*03*/ FechaEmision, /*04*/ UEN, /*05*/ Moneda, /*06*/ TipoCambio, /*07*/ Usuario,
    /*08*/ Referencia, /*09*/ Estatus, /*10*/ Directo, /*11*/ Prioridad, /*12*/ RenglonID, /*13*/ Cliente, /*14*/ EnviarA,
    /*15*/ Almacen, /*16*/ Agente, /*17*/ FechaRequerida, /*18*/ Condicion, /*19*/ Vencimiento, /*20*/ Importe, /*21*/ Impuestos,
    /*22*/ GenerarPoliza, /*23*/ Ejercicio, /*24*/ Periodo, /*25*/ FechaRegistro, /*26*/ ZonaImpuesto, /*27*/ Sucursal, /*28*/ DesglosarImpuestos,
    /*29*/ SubModulo, /*30*/ SucursalVenta, /*31*/ SucursalOrigen, /*32*/ FormaPagoTipo, /*33*/ OrigenSucursal, /*34*/ NoCtaPago, /*35*/ RedimePtos,
    /*36*/ CteFinal, /*37*/ FolioFIADE, /*38*/ ServicioTipoOperacion)

      SELECT
        /*01*/ Empresa = 'MAVI',
               /*02*/
               Mov = 'Solicitud Credito',
               /*03*/
               FechaEmision = CAST(GETDATE() AS date),
               /*04*/
               UEN = '1',
               /*05*/
               Moneda = 'Pesos',
               /*06*/
               TipoCambio = '1',
               /*07*/
               Usuario = IIF(@TipoArt = 'MIXTO', 'VENTR00053', (SELECT
                 Usuario
               FROM Usuario WITH (NOLOCK)
               WHERE ACCESO = 'VENTP_LIMA'
               AND Nombre LIKE '%VENTAS PISO SUCURSAL%'
               AND Sucursal = @Sucursal)
               ),
               /*08*/
               Referencia = 'Credilana APPDIMA',
               /*09*/
               Estatus = 'SINAFECTAR',
               /*10*/
               Directo = 1,
               /*11*/
               Prioridad = 'Normal',
               /*12*/
               RenglonId = 1,
               /*13*/
               DIMA,
               /*14*/
               EnviarA = '76',
               /*15*/
               s.AlmacenPrincipal,
               /*16*/
               Agente =
                       CASE
                         WHEN @Agente = '' OR
                           @Agente IS NULL THEN @AgenteG
                         ELSE cf.usuario
                       END,
               /*17*/
               FechaRequerida = CAST(GETDATE() AS date),
               /*18*/
               Condicion = @Condicion,
               /*19*/
               Vencimiento = (GETDATE() + (@DiasVencimiento)),
               /*20*/
               Capital = @Capital,
               /*21*/
               Impuestos = '0',
               /*22*/
               GenerarPoliza = '0',
               /*23*/
               Ejercicio = DATEPART(YEAR, GETDATE()),
               /*24*/
               Periodo = DATEPART(MONTH, GETDATE()),
               /*25*/
               FechaRegistro = GETDATE(),
               /*26*/
               s.ZonaImpuesto,
               /*27*/
               Sucursal = IIF(@TipoArt = 'MIXTO', 30, @Sucursal),
               /*28*/
               DesglosarImpuestos = '1',
               /*29*/
               SubModulo = 'VTAS',
               /*30*/
               SucursalVenta = IIF(@TipoArt = 'MIXTO', 30, @Sucursal),
               /*31*/
               SucursalOrigen = IIF(@TipoArt = 'MIXTO', 30, @Sucursal),
               /*32*/
               FormaPagoTipo = 'QUINCENAL',
               /*33*/
               OrigenSucursal = IIF(@TipoArt = 'MIXTO', 30, @Sucursal),
               /*34*/
               NoCtaPago = 'No Identificado',
               /*35*/
               RedimePtos = '0',
               /*36*/
               Final,
               /*37*/
               folioFIADE = a.Id,
               /*38*/
               ServicioTipoOperacion = 1
      FROM #RegistroPeticiones a
      JOIN Sucursal s WITH (NOLOCK)
        ON s.Sucursal = IIF(@TipoArt = 'MIXTO', 30, @Sucursal)
      JOIN Cte_Final cf WITH (NOLOCK)
        ON a.Final = cf.ClienteF
      WHERE a.indice = @IndexRow

    SET @IDVTA = @@IDENTITY


    -----------Insercion de los datos a la tabla VentaD
    IF (@TipoArt != 'MIXTO')
    BEGIN
      INSERT INTO VentaD (ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad,
      Almacen, EnviarA, Articulo, Precio, PrecioSugerido, Impuesto1, Unidad, Factor,
      FechaRequerida, Agente, Sucursal, SucursalOrigen, UEN, PropreListaID)
        SELECT
          @IDVTA,
          Renglon = '2048',
          RenglonSub = '0',
          RenglonID = '1',
          RenglonTipo = 'N',
          Cantidad = '1',
          v.Almacen,
          v.EnviarA,
          @TipoArt,
          Precio = dbo.fnProprePrecio(@IDVTA, @TipoArt, '2048', 0),
          PrecioSugerido = dbo.fnProprePrecio(@IDVTA, @TipoArt, '2048', 0),
          Impuesto1 = '0',
          ar.Unidad,
          Factor = '1',
          v.FechaRequerida,
          v.Agente,
          v.Sucursal,
          v.SucursalOrigen,
          v.UEN,
          PropreListaID = dbo.fnProprePrecioID(@IDVTA, @TipoArt, 0)
        FROM Venta v WITH (NOLOCK)
        JOIN Art ar WITH (NOLOCK)
          ON ar.Articulo = @TipoArt
        WHERE v.ID = @IDVTA
    ---------------Afectacion de Solicitud de Credito a PENDIENTE

    END
    ELSE
    BEGIN
      DECLARE @IndexRow1 int = 1
      DECLARE @MaxRow1 int = (SELECT
        COUNT(*)
      FROM MaviAndroid01.ServicioAndroid.dbo.CREDIDRegistroPeticiones WITH (NOLOCK)
      WHERE IdRegistroPeticiones = @IdRegistroP)


      WHILE (@IndexRow1 <= @MaxRow1)
      BEGIN

        DECLARE @TipoArt1 varchar(10) = (SELECT
          Articulo
        FROM MaviAndroid01.ServicioAndroid.dbo.CREDIDRegistroPeticiones WITH (NOLOCK)
        WHERE IdRegistroPeticiones = @IdRegistroP
        AND Orden = @IndexRow1)

        INSERT INTO VentaD (ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, Precio, PrecioSugerido, Impuesto1,
        Unidad, Factor, FechaRequerida, Agente, Sucursal, SucursalOrigen, UEN, PropreListaID)

          SELECT
            @IDVTA,
            Renglon = Rp.Renglon,
            RenglonSub = '0',
            RenglonID = '1',
            RenglonTipo = 'N',
            Cantidad = Rp.Cantidad,
            v.Almacen,
            v.EnviarA,
            @TipoArt1,
            Precio = dbo.fnProprePrecio(@IDVTA, @TipoArt1, Rp.Renglon, 0),
            PrecioSugerido = dbo.fnProprePrecio(@IDVTA, @TipoArt1, Rp.Renglon, 0),
            Impuesto1 = ar.Impuesto1,
            ar.Unidad,
            Factor = '1',
            v.FechaRequerida,
            v.Agente,
            v.Sucursal,
            v.SucursalOrigen,
            v.UEN,
            PropreListaID = dbo.fnProprePrecioID(@IDVTA, @TipoArt1, 0)
          FROM Venta v WITH (NOLOCK)
          JOIN Art ar WITH (NOLOCK)
            ON ar.Articulo = @TipoArt1
          JOIN MaviAndroid01.ServicioAndroid.dbo.CREDIDRegistroPeticiones RP WITH (NOLOCK)
            ON RP.Articulo = @TipoArt1
          JOIN #RegistroPeticiones R
            ON R.Id = RP.IdRegistroPeticiones
          WHERE v.ID = @IDVTA
          AND R.ID = @IdRegistroP

        SET @IndexRow1 = @IndexRow1 + 1

      END
    END

    SET @SerieMonedero = (SELECT
      SerieMonedero
    FROM CTE WITH (NOLOCK)
    WHERE CLIENTE = @DIMA)

    INSERT INTO #Estatus (Estatus)
    EXEC Sp_DM0312TarjetaSerieMovMavi @IDVTA,
                                      @SerieMonedero,
                                      @Sucursal,
                                      NULL

    EXEC spGenerarMovMonederoMAVI @IDVTA

    ---------------Afectacion de Solicitud de Credito a PENDIENTE
    SELECT
      @Usuario = Usuario
    FROM Venta WITH (NOLOCK)
    WHERE ID = @IDVTA

    INSERT INTO CREDIHLogAfectarFlujoIntelisis (Ok, OkDesc, OkTipo, OkRef, IDGenerar)
    EXEC spAfectar 'VTAS',
                   @IdVTA,
                   'AFECTAR',
                   'Todo',
                   NULL,
                   @Usuario,
                   @Estacion = 3


    DECLARE @IntAfectacion int = @@IDENTITY

    UPDATE CREDIHLogAfectarFlujoIntelisis WITH (ROWLOCK)
    SET IdRegistroPeticion = @IdRegistroP,
        IdVenta = @IDVTA,
        Descripcion = 'Afectacion de Solicitud de Credito a PENDIENTE'
    WHERE IdLogAfectarFlujoIntelisis = @IntAfectacion

    -------------Insercion de los registros ya afectados 	
    INSERT INTO #RegistrosAfectados (Id, Mov, Usuario, Estatus, Cliente, Ctefinal, FolioFIADE)
      SELECT
        v.ID,
        Mov,
        Usuario,
        Estatus,
        cliente,
        Ctefinal,
        s.Id
      FROM Venta v WITH (NOLOCK)
      JOIN #RegistroPeticiones s
        ON s.Id = v.FolioFIADE
      WHERE v.id = @IDVTA
      AND s.Indice = @IndexRow

    SET @IndexRow = @IndexRow + 1
  END

  SELECT
    *
  FROM #RegistrosAfectados

  -------------Eliminacion de tablas temporales 
  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#RegistroPeticiones')
    AND TYPE = 'U')
    DROP TABLE #RegistroPeticiones

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#RegistrosAfectados')
    AND TYPE = 'U')
    DROP TABLE #RegistrosAfectados

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#Mensaje')
    AND TYPE = 'U')
    DROP TABLE #Mensaje

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#Estatus')
    AND TYPE = 'U')
    DROP TABLE #Estatus

END