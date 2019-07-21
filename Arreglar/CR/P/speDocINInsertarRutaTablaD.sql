SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocINInsertarRutaTablaD
@eDocIn          varchar(50),
@Ruta            varchar(50),
@Tablas          varchar(50),
@Campo           varchar(50),
@TipoDatos       varchar(50),
@DetalleDe       varchar(50),
@Nodo            varchar(8000),
@NodoNombre      varchar(8000),
@Modulo          varchar(20),
@Ok              int OUTPUT,
@OkRef           varchar(255) OUTPUT

AS BEGIN
DECLARE
@TablaPrincipal       bit,
@SubDetalleDe         varchar(50)
SELECT @TablaPrincipal = CASE WHEN @Tablas = dbo.fnMovTabla(@Modulo) THEN 1 ELSE 0 END
SELECT @TablaPrincipal = ISNULL(@TablaPrincipal,0)
IF @DetalleDe IS NOT NULL
BEGIN
SELECT @SubDetalleDe = @DetalleDe
WHILE EXISTS(SELECT * FROM  SysCampoExt  WHERE  Tabla = @SubDetalleDe AND Campo = @Campo)
BEGIN
SELECT @NodoNombre = NodoNombre, @SubDetalleDe = DetalleDe FROM eDocInRutaTabla WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND Tablas = @SubDetalleDe
END
END
IF @Campo = 'ID'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML, ExpresionXML, CampoTabla, CampoXMLTipo,  CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'ID',     '{ID}',       'ID',       @TipoDatos,    NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @@ERROR <> 0 SET @Ok = 1
IF @Campo = 'Renglon' AND @TablaPrincipal = 0
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,               ExpresionXML,           CampoTabla, CampoXMLTipo,  CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, @NodoNombre+'_renglon', @NodoNombre+'_renglon', 'Renglon',  @TipoDatos,    @Nodo,        'Renglon',        'ATRIBUTO',      0,               1,             'Renglon',         2048.0,             2048.0,                0,        NULL)
IF @@ERROR <> 0 SET @Ok = 1
IF @Campo = 'RenglonID' AND @TablaPrincipal = 0
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,                 ExpresionXML,             CampoTabla,  CampoXMLTipo,  CampoXMLRuta, CampoXMLAtributo,   CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, @NodoNombre+'_renglonId', @NodoNombre+'_renglonid', 'RenglonID', @TipoDatos,    @Nodo,        'RenglonID',        'ATRIBUTO',      0,               1,             'RenglonID',       1,                  1,                     0,        NULL)
IF @@ERROR <> 0 SET @Ok = 1
IF @Campo = 'RenglonSub' AND @TablaPrincipal = 0
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,     ExpresionXML, CampoTabla,    CampoXMLTipo,  CampoXMLRuta, CampoXMLAtributo,   CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'RenglonSub', '0',          'RenglonSub',  @TipoDatos,    @Nodo,        NULL,               NULL,            1,               0,             NULL,               NULL,              NULL,                     0,        NULL)
IF @@ERROR <> 0 SET @Ok = 1
IF @Campo = 'Sucursal'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,   ExpresionXML, CampoTabla, CampoXMLTipo,  CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Sucursal', '{Sucursal}', 'Sucursal', @TipoDatos,    NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @@ERROR <> 0 SET @Ok = 1
IF @Campo = 'SucursalOrigen'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,         ExpresionXML, CampoTabla,       CampoXMLTipo,  CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'SucursalOrigen', '{Sucursal}', 'SucursalOrigen', @TipoDatos,    NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @@ERROR <> 0 SET @Ok = 1
IF @Campo = 'Mov'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,     ExpresionXML,   CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Movimiento', '{Movimiento}', 'Mov',      @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'Modulo'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,     ExpresionXML,   CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Modulo', '{Modulo}', 'Modulo',      @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'Moneda'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML, ExpresionXML,   CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Moneda', '{Moneda}',     'Moneda',   @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'Usuario'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,  ExpresionXML,   CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Usuario', '{Usuario}',    'Usuario',  @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'Estatus'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,   ExpresionXML,          CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Estatus', '{EstatusSinAfectar}',  'Estatus',  @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'FechaEmision'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,       ExpresionXML, CampoTabla,     CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'FechaEmision', '{Hoy}',      'FechaEmision', @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'Almacen'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,  ExpresionXML,   CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'Almacen', '{Almacen}',    'Almacen',  @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'TipoCambio'
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,     ExpresionXML,   CampoTabla,    CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'TipoCambio', '{TipoCambio}', 'TipoCambio',  @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo = 'RenglonTipo' AND @TablaPrincipal = 0
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML,      ExpresionXML, CampoTabla,     CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
VALUES (                 @eDocIn,  @Ruta, @Tablas, 'RenglonTipo', '''N''',      'RenglonTipo',  @TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL)
IF @Campo NOT IN('ID','Renglon', 'RenglonID', 'RenglonSub', 'Sucursal', 'SucursalOrigen', 'Mov', 'Moneda', 'Usuario', 'Estatus', 'FechaEmision', 'Almacen', 'TipoCambio', 'RenglonTipo', 'Modulo')
INSERT   eDocInRutaTablaD(eDocIn,   Ruta,  Tablas,  CampoTabla)
VALUES (                  @eDocIn,  @Ruta, @Tablas, @Campo)
END

