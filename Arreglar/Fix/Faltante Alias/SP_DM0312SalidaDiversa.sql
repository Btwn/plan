SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO

-- ========================================================================================================================================   
-- NOMBRE           : SP_DM0312SalidaDiversa  
-- AUTOR            : Dan Asael Palacios Gonzalez  
-- FECHA CREACION   : 08/12/2017  
-- DESARROLLO  : DM0312 PUNTO DE VENTA  
-- MODULO   : Salida diversa  
--ESTANDAR NOCOUNT : DEBE IR ENCENDIDO DESPUES DEL CREATE O ALTER DEL PROCEDURE Y APAGARLOS AL FINALIZAR SU EJECUCION  
-- DESCRIPCION  : Inserta y afecta salidas diversas cuando se genera una adjudicacion  
-- EJEMPLO   : EXEC SP_DM0312SalidaDiversa '6040212'  
-- ========================================================================================================================================   
-- Fecha Modificacione: 18/07/2019
-- Autor: Norberto Reyes C.
-- Descripcion: Se agregan los campos tarima y AsignacionUbicacion que son requeridos en la tabla SerieLoteMov
-- ========================================================================================================================================   
ALTER PROCEDURE [dbo].[SP_DM0312SalidaDiversa] @IDVenta INT = NULL,  
@Empresa VARCHAR(5) = 'MAVI',  
@Mov VARCHAR(20) = 'Salida Diversa',  
@MovID VARCHAR(20) = NULL,  
@FechaEmision DATETIME = NULL,  
@UltimoCambio DATETIME = NULL,  
@Concepto VARCHAR(50) = NULL,  
@Proyecto VARCHAR(50) = NULL,  
@Actividad VARCHAR(100) = NULL,  
@UEN INT = NULL,  
@Moneda VARCHAR(10) = 'Pesos',  
@TipoCambio VARCHAR(10) = 1,  
@Usuario VARCHAR(10) = NULL,  
@Autorizacion VARCHAR(10) = NULL,  
@Referencia VARCHAR(50) = NULL,  
@DocFuente INT = NULL,  
@Observaciones VARCHAR(50) = NULL,  
@Estatus VARCHAR(15) = 'SINAFECTAR',  
@Situacion VARCHAR(50) = NULL,  
@SituacionFecha DATETIME = NULL,  
@SituacionUsuario VARCHAR(10) = NULL,  
@SituacionNota VARCHAR(100) = NULL,  
@Directo BIT = 1,  
@RenglonID INT = NULL,  
@Almacen VARCHAR(10) = NULL,  
@AlmacenDestino VARCHAR(10) = NULL,  
@AlmacenTransito VARCHAR(10) = '(TRANSITO)',  
@Largo BIT = 0,  
@FechaRequerida VARCHAR(10) = NULL,  
@Condicion VARCHAR(50) = NULL,  
@Vencimiento DATETIME = NULL,  
@FormaEnvio VARCHAR(50) = NULL,  
@OrigenTipo VARCHAR(10) = NULL,  
@Origen VARCHAR(20) = NULL,  
@OrigenID VARCHAR(20) = NULL,  
@Poliza VARCHAR(20) = NULL,  
@PolizaID VARCHAR(20) = NULL,  
@FechaConclusion DATETIME = NULL,  
@FechaCancelacion DATETIME = NULL,  
@FechaOrigen DATETIME = NULL,  
@Peso FLOAT = NULL,  
@Volumen FLOAT = NULL,  
@Sucursal INT = NULL,  
@VerLote BIT = 0,  
@VerDestino BIT = 0,  
@Personal VARCHAR(10) = NULL,  
@Conteo INT = NULL,  
@Agente VARCHAR(10) = NULL,  
@ACRetencion FLOAT = NULL,  
@SubModulo VARCHAR(5) = NULL,  
@SucursalOrigen INT = NULL,  
@ContUsoMAVI VARCHAR(20) = NULL,  
@Estacion INT = NULL,  
@ObtenerSalidaDiversa BIT = 0  
AS  
BEGIN  
 SET NOCOUNT ON  
  IF (@ObtenerSalidaDiversa = 0)  
  BEGIN  
    DECLARE @Ok NVARCHAR(255) = NULL,  
            @ID INT = NULL;  
  
    INSERT INTO Inv (
	Empresa,  
    Mov,  
    MovID,  
    FechaEmision,  
    Proyecto,  
    Moneda,  
    TipoCambio,  
    Concepto,  
    Referencia,  
    DocFuente,  
    Observaciones,  
    Estatus,  
    Situacion,  
    SituacionFecha,  
    SituacionUsuario,  
    SituacionNota,  
    Directo,  
    RenglonID,  
    Almacen,  
    AlmacenDestino,  
    AlmacenTransito,  
    Largo,  
    Condicion,  
    Vencimiento,  
    FormaEnvio,  
    Autorizacion,  
    Usuario,  
    UltimoCambio,  
    OrigenTipo,  
    Origen,  
    OrigenID,  
    Poliza,  
    PolizaID,  
    FechaConclusion,  
    FechaCancelacion,  
    FechaOrigen,  
    FechaRequerida,  
    Peso,  
    Volumen,  
    Sucursal,  
    SucursalOrigen,  
    VerLote,  
    UEN,  
    VerDestino,  
    Personal,  
    Conteo,  
    Agente,  
    ACRetencion,  
    SubModulo,  
    Actividad,  
    ContUsoMAVI)  
      VALUES (@Empresa, @Mov, @MovID, @FechaEmision, @Proyecto, @Moneda, @TipoCambio, @Concepto, @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Directo, @RenglonID, @Almacen, @AlmacenDestino,
	   @AlmacenTransito, @Largo, @Condicion, @Vencimiento, @FormaEnvio, @Autorizacion, @Usuario, @UltimoCambio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @FechaConclusion, @FechaCancelacion, @FechaOrigen, @FechaRequerida, @Peso, @Volumen, @Sucursal,
	   @SucursalOrigen, @VerLote, @UEN, @VerDestino, @Personal, @Conteo, @Agente, @ACRetencion, @SubModulo, @Actividad, @ContUsoMAVI)  
  
    SET @ID = SCOPE_IDENTITY();  
  INSERT INTO InvD (ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,Codigo,Articulo,FechaRequerida,Unidad,CantidadInventario,Sucursal,SucursalOrigen)
  (select @ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,Codigo,Articulo,FechaRequerida,Unidad,CantidadInventario,@Sucursal,@SucursalOrigen from VentaD where ID = @IDVenta)

    --Inserta la serie de la salida diversa  
    INSERT INTO SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades, Ubicacion,  
    Cliente, Localizacion, Sucursal, ArtCostoInv,Tarima,AsignacionUbicacion)  
      SELECT  
        Empresa,  
        'INV',  
        @ID,  
        RenglonID,  
        Articulo,  
        SubCuenta,  
        SerieLote,  
        Cantidad,  
        CantidadAlterna,  
        Propiedades,  
        Ubicacion,  
        Cliente,  
        Localizacion,  
        Sucursal,  
        ArtCostoInv,
		'',
		0
		FROM SerieLoteMov WITH (NOLOCK)  
      WHERE ID = @IDVenta  
  
    EXEC spAfectar 'INV',  
                   @ID,  
                   'AFECTAR',  
                   'Todo',  
                   NULL,  
                   @Usuario,  
                   @Estacion,  
                   @Ok = @Ok OUTPUT  
  
    IF (@Ok IS NOT NULL  
      AND @Ok <> 80030)  
    BEGIN  
      SELECT  
        Descripcion  
      FROM MensajeLista WITH (NOLOCK)  
      WHERE Mensaje = @Ok;  
    END  
    ELSE  
    BEGIN  
      SELECT  
        MOVID  
      FROM INV WITH (NOLOCK)  
      WHERE ID = @ID;  
    END  
  
  END  
  ELSE  
  BEGIN  
    SELECT  
      COUNT(ID) Existente  
    FROM INV WITH (NOLOCK)  
    WHERE Referencia = @Referencia  
    AND Mov = 'Salida Diversa'  
    AND Estatus = 'CONCLUIDO';  
  END  
 SET NOCOUNT OFF  
END