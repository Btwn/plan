SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmbarqueMov
@Accion		char(20),
@Empresa		char(5),
@Modulo  		char(5),
@ID	    		int,
@Mov			char(20),
@MovID		varchar(20),
@Estatus		char(15),
@EstatusNuevo	char(15),
@CfgEmbarcar		bit,
@Ok			int OUTPUT

AS BEGIN
DECLARE
@Sucursal		int,
@AsignadoID		int,
@MovReferencia 	varchar(50),
@MovObservaciones 	varchar(100),
@FechaEmision	datetime,
@Almacen		char(10),
@Cliente		char(10),
@ClienteEnviarA	int,
@Proveedor		char(10),
@AlmacenDestino	char(10),
@Peso		float,
@Volumen		float,
@Paquetes		int,
@Importe		money,
@Impuestos		money,
@ImporteNeto	money,
@DescuentoGlobal	float,
@SobrePrecio	float,
@Moneda  		char(10),
@TipoCambio		float,
@UEN		int,
@Condicion  	varchar(50),
@Vencimiento	datetime,
@BeneficiarioNombre	varchar(100),
@Nombre		varchar(100),
@NombreEnvio	varchar(100),
@Direccion 		varchar(100),
@EntreCalles	varchar(100),
@Plano		varchar(15),
@Observaciones	varchar(100),
@Delegacion		varchar(30),
@Colonia 		varchar(30),
@Poblacion 		varchar(30),
@Estado 		varchar(30),
@Pais 		varchar(30),
@CodigoPostal 	varchar(15),
@Telefonos		varchar(100),
@Contacto1 		varchar(50),
@Contacto2 		varchar(50),
@Extencion1		varchar(10),
@Extencion2		varchar(10),
@DireccionNumero	varchar(20),
@DireccionNumeroInt	varchar(20),
@MapaLatitud	float,
@MapaLongitud	float,
@MapaPrecision	int,
@AccionEmbarque	varchar(50),
@Zona		varchar(30),
@Ruta		varchar(50),
@ZonaTipo		varchar(50),
@OrdenEmbarque	int,
@CfgEstadoPendiente	varchar(50),
@SubClave           varchar(20),
@Ubicacion          varchar(1000)
IF @Estatus = @EstatusNuevo RETURN
SELECT @Cliente = NULL, @ClienteEnviarA = NULL, @Proveedor = NULL, @Almacen = NULL, @AlmacenDestino = NULL, @Ruta = NULL, @Zona = NULL,
@Volumen = 0.0, @Peso = 0.0, @Paquetes = NULL, @Importe = 0.0, @DescuentoGlobal = 0.0, @SobrePrecio = 0.0, @Impuestos = 0.0,
@AccionEmbarque = NULL, @BeneficiarioNombre = NULL
IF @CfgEmbarcar = 1 AND @Estatus = 'SINAFECTAR' AND @EstatusNuevo <> 'CANCELADO'
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones, @Almacen = Almacen,
@Cliente = Cliente, @ClienteEnviarA = NULLIF(EnviarA, 0), @Volumen = ISNULL(Volumen, 0.0), @Peso = ISNULL(Peso, 0.0),
@Importe = ISNULL(Importe, 0.0), @DescuentoGlobal = ISNULL(DescuentoGlobal, 0.0), @SobrePrecio = ISNULL(SobrePrecio, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Moneda = Moneda, @TipoCambio = TipoCambio,
@Condicion = Condicion, @Vencimiento = Vencimiento, @Paquetes = Paquetes, @UEN = UEN
FROM Venta WITH (NOLOCK)
WHERE ID = @ID
SELECT @SubClave = SubClave FROM MovTipo WITH (NOLOCK) WHERE  Mov = @Mov and @Modulo = 'VTAS'
end
ELSE
IF @Modulo = 'COMS'
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones, @Almacen = Almacen,
@Proveedor = Proveedor, @Volumen = ISNULL(Volumen, 0.0), @Peso = ISNULL(Peso, 0.0),
@Importe = ISNULL(Importe, 0.0), @DescuentoGlobal = ISNULL(DescuentoGlobal, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Moneda = Moneda, @TipoCambio = TipoCambio,
@Condicion = Condicion, @Vencimiento = Vencimiento, @UEN = UEN
FROM Compra WITH (NOLOCK)
WHERE ID = @ID
ELSE
IF @Modulo = 'INV'
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones, @Almacen = Almacen,
@AlmacenDestino = AlmacenDestino, @Volumen = ISNULL(Volumen, 0.0), @Peso = ISNULL(Peso, 0.0),
@Importe = ISNULL(Importe, 0.0), @Moneda = Moneda, @TipoCambio = TipoCambio,
@Condicion = Condicion, @Vencimiento = Vencimiento, @Paquetes = Paquetes, @UEN = UEN
FROM Inv WITH (NOLOCK)
WHERE ID = @ID
ELSE
IF @Modulo = 'CXC'
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones,
@Cliente = Cliente, @ClienteEnviarA = NULLIF(ClienteEnviarA, 0), @Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Moneda = Moneda, @TipoCambio = TipoCambio,
@Condicion = Condicion, @Vencimiento = Vencimiento, @UEN = UEN
FROM Cxc WITH (NOLOCK)
WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones,
@Proveedor = Proveedor, @Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Moneda = Moneda, @TipoCambio = TipoCambio,
@Condicion = Condicion, @Vencimiento = Vencimiento, @UEN = UEN
FROM Cxp WITH (NOLOCK)
WHERE ID = @ID
ELSE
IF @Modulo = 'DIN'
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones,
@Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Moneda = Moneda, @TipoCambio = TipoCambio,
@BeneficiarioNombre = NULLIF(RTRIM(BeneficiarioNombre), ''), @UEN = UEN
FROM Dinero WITH (NOLOCK)
WHERE ID = @ID
ELSE
IF @Modulo = 'CAM'
SELECT @Sucursal = Sucursal, @FechaEmision = FechaEmision, @MovReferencia = Referencia, @MovObservaciones = Observaciones,
@Cliente = Cliente, @ClienteEnviarA = NULLIF(ClienteEnviarA, 0),
@Condicion = Condicion, @Vencimiento = Vencimiento, @UEN = UEN
FROM Cambio WITH (NOLOCK)
WHERE ID = @ID
SELECT @ImporteNeto = dbo.fnSubTotal(@Importe, @DescuentoGlobal, @SobrePrecio)
IF @Cliente IS NOT NULL
SELECT @Nombre = Nombre, @NombreEnvio = Nombre, @Direccion = Direccion, @Colonia = Colonia, @Delegacion = Delegacion, @Poblacion = Poblacion, @Estado = Estado,
@EntreCalles = EntreCalles, @Plano = Plano, @Observaciones = Observaciones,
@Pais = Pais, @CodigoPostal = CodigoPostal, @Telefonos = Telefonos,
@Contacto1 = Contacto1, @Contacto2 = Contacto2, @Extencion1 = Extencion1, @Extencion2 = Extencion2,
@Ruta = Ruta, @OrdenEmbarque = RutaOrden,
@DireccionNumero = DireccionNumero, @DireccionNumeroInt = DireccionNumeroInt,
@MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @MapaPrecision = MapaPrecision
FROM Cte WITH (NOLOCK)
WHERE Cliente = @Cliente
IF @AlmacenDestino IS NOT NULL
SELECT @Nombre = Almacen, @NombreEnvio = Nombre, @Direccion = Direccion, @Colonia = Colonia, @Delegacion = Delegacion, @Poblacion = Poblacion, @Estado = Estado,
@EntreCalles = EntreCalles, @Plano = Plano, @Observaciones = Observaciones,
@Pais = Pais, @CodigoPostal = CodigoPostal, @Telefonos = Telefonos,
@Contacto1 = Encargado, @Ruta = Ruta,
@DireccionNumero = DireccionNumero, @DireccionNumeroInt = DireccionNumeroInt,
@MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @MapaPrecision = MapaPrecision
FROM Alm WITH (NOLOCK)
WHERE Almacen = @AlmacenDestino
IF @Cliente IS NOT NULL AND @ClienteEnviarA IS NOT NULL
SELECT @NombreEnvio = Nombre, @Direccion = Direccion, @Colonia = Colonia, @Delegacion = Delegacion, @Poblacion = Poblacion, @Estado = Estado,
@EntreCalles = EntreCalles, @Plano = Plano, @Observaciones = Observaciones,
@Pais = Pais, @CodigoPostal = CodigoPostal, @Telefonos = Telefonos,
@Contacto1 = Contacto1, @Contacto2 = Contacto2, @Extencion1 = Extencion1, @Extencion2 = Extencion2,
@Ruta = Ruta,
@DireccionNumero = DireccionNumero, @DireccionNumeroInt = DireccionNumeroInt,
@MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @MapaPrecision = MapaPrecision
FROM CteEnviarA WITH (NOLOCK)
WHERE Cliente = @Cliente AND ID = @ClienteEnviarA
IF @BeneficiarioNombre IS NOT NULL
SELECT @Proveedor = Proveedor FROM Prov WITH (NOLOCK) WHERE  BeneficiarioNombre = @BeneficiarioNombre OR Nombre = @BeneficiarioNombre
IF @Proveedor IS NOT NULL
SELECT @Nombre = Nombre, @NombreEnvio = Nombre, @Direccion = Direccion, @Colonia = Colonia, @Delegacion = Delegacion, @Poblacion = Poblacion, @Estado = Estado,
@EntreCalles = EntreCalles, @Plano = Plano, @Observaciones = Observaciones,
@Pais = Pais, @CodigoPostal = CodigoPostal, @Telefonos = Telefonos,
@Contacto1 = Contacto1, @Contacto2 = Contacto2, @Extencion1 = Extencion1, @Extencion2 = Extencion2,
@Ruta = Ruta,
@DireccionNumero = DireccionNumero, @DireccionNumeroInt = DireccionNumeroInt,
@MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @MapaPrecision = MapaPrecision
FROM Prov WITH (NOLOCK)
WHERE Proveedor = @Proveedor
SELECT @Ruta = r.Ruta, @Zona = r.Zona, @ZonaTipo = NULLIF(RTRIM(z.Tipo), '')
FROM Ruta r WITH (NOLOCK), Zona z WITH (NOLOCK)
WHERE r.Ruta = @Ruta AND r.Zona = z.Zona
SELECT @CfgEstadoPendiente = EmbarqueEstadoPendiente
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @AccionEmbarque = Accion
FROM EmpresaCfgMovEsp WITH (NOLOCK)
WHERE Empresa = @Empresa
AND Asunto = 'EMB'
AND Modulo = @Modulo
AND Mov = @Mov
IF @SubClave = 'VTAS.EMBARQUE'
SELECT @MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @Ubicacion = Ubicacion
FROM Venta WITH (NOLOCK)
WHERE ID = @ID
INSERT EmbarqueMov (Sucursal, Accion, Zona, Ruta, ZonaTipo, OrdenEmbarque,
Empresa, Modulo, ModuloID, Mov, MovID, MovEstatus, FechaEmision, MovReferencia, MovObservaciones, Almacen,
Cliente, ClienteEnviarA, Proveedor, AlmacenDestino,
Volumen, Peso, Paquetes, Importe, Impuestos, Moneda, TipoCambio, UEN, Condicion, Vencimiento,
Nombre, NombreEnvio, Direccion, EntreCalles, Plano, Observaciones, Colonia, Delegacion, Poblacion, Estado, Pais, CodigoPostal,
Telefonos, Contacto1, Contacto2, Extencion1, Extencion2,
DireccionNumero, DireccionNumeroInt, MapaLatitud, MapaLongitud, MapaPrecision, Ubicacion)
VALUES (@Sucursal, @AccionEmbarque, @Zona, @Ruta, @ZonaTipo, @OrdenEmbarque,
@Empresa, @Modulo, @ID, @Mov, @MovID, @EstatusNuevo, @FechaEmision, @MovReferencia, @MovObservaciones, @Almacen,
@Cliente, @ClienteEnviarA, @Proveedor, @AlmacenDestino,
@Volumen, @Peso, NULLIF(@Paquetes, 0), @ImporteNeto, @Impuestos, @Moneda, @TipoCambio, @UEN, @Condicion, @Vencimiento,
@Nombre, @NombreEnvio, @Direccion, @EntreCalles, @Plano, @Observaciones, @Colonia, @Delegacion, @Poblacion, @Estado, @Pais, @CodigoPostal,
@Telefonos, @Contacto1, @Contacto2, @Extencion1, @Extencion2,
@DireccionNumero, @DireccionNumeroInt, @MapaLatitud, @MapaLongitud, @MapaPrecision, @Ubicacion)
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
BEGIN
IF @Modulo = 'VTAS' UPDATE Venta  WITH(ROWLOCK) SET EmbarqueEstado = @CfgEstadoPendiente WHERE ID = @ID ELSE
IF @Modulo = 'COMS' UPDATE Compra WITH(ROWLOCK) SET EmbarqueEstado = @CfgEstadoPendiente WHERE ID = @ID ELSE
IF @Modulo = 'INV'  UPDATE Inv    WITH(ROWLOCK) SET EmbarqueEstado = @CfgEstadoPendiente WHERE ID = @ID ELSE
IF @Modulo = 'CXC'  UPDATE Cxc    WITH(ROWLOCK) SET EmbarqueEstado = @CfgEstadoPendiente WHERE ID = @ID ELSE
IF @Modulo = 'DIN'  UPDATE Dinero WITH(ROWLOCK) SET EmbarqueEstado = @CfgEstadoPendiente WHERE ID = @ID
END
END
ELSE BEGIN
UPDATE EmbarqueMov
SET MovEstatus = @EstatusNuevo,
@AsignadoID = AsignadoID
WHERE Modulo = @Modulo
AND ModuloID = @ID
/* AND Empresa = @Empresa
AND Mov = @Mov
AND MovID = @MovID*/
IF @Accion = 'CANCELAR' AND @AsignadoID IS NOT NULL
IF (SELECT Estatus FROM Embarque WITH (NOLOCK) WHERE  ID = @AsignadoID) <> 'CONCLUIDO'
SELECT @Ok = 42020
END
RETURN
END

