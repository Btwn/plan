SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spProyGenerarPresup
@IDProyecto int,
@Modulo     varchar(20),
@Mov        varchar(20),
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@SubTipo    varchar(50),
@Proyecto   varchar(50),
@Proveedor  varchar(50)

AS BEGIN
DECLARE
@MovID          varchar(20),
@MovTipo        varchar(20),
@Origen         varchar(20),
@OrigenID       varchar(20),
@FechaEmision   datetime,
@Almacen        varchar(10),
@Articulo	    varchar(20),
@SerieLote	    varchar(50),
@Ok		        int,
@OkRef	        varchar(255),
@AlmTipo	    varchar(20),
@ArtTipo	    varchar(20),
@ID		        int,
@Costo	        float,
@Moneda	        varchar(10),
@TipoCambio	    float,
@UEN			int,
@ConceptoRH		varchar(255),
@ConceptoStaff	varchar(255),
@ImporteRH		float,
@Renglon		float,
@Acreedor		varchar(50),
@ArticuloMP		varchar(255),
@AlmacenMP		varchar(255),
@CantidadMP		int,
@UnidadMP		varchar(50),
@SubCuentaMP	varchar(255),
@Impuesto1MP	float,
@Impuesto2MP	float,
@Impuesto3MP	float,
@FactorMP		float,
@DuracionDias	float,
@CostoHora		float,
@HorasDia		float,
@UltimoCostoArt	float,
@CfgCostoSugerido	varchar(50),
@ProveedorArt	varchar(50)
SET @Ok = null
SET @OkRef = null
SELECT @Moneda = Moneda,
@TipoCambio = TipoCambio,
@Origen = Mov,
@OrigenID = MovID
FROM Proyecto
WHERE ID = @IDProyecto
SELECT @MovTipo = Clave
FROM MovTipo
WHERE Modulo = @Modulo
AND Mov = @Mov
SELECT @CfgCostoSugerido = CompraCostoSugerido FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @UEN = UEN FROM UEN WHERE NOMBRE = @Moneda
IF @Modulo NOT IN ('COMS','GAS')
SELECT @Ok = 1, @OkRef = 'Error: Solo es posible generar movimientos de Compras o Gastos'
IF @Ok IS NULL AND @Modulo = 'COMS' AND @MovTipo = 'COMS.PR'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Compra WHERE OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80001, @OkRef = 'Error: ya existe un Presupuesto de Materias Primas. Si desea agregar un nuevo movimiento necesita cancelar el existente.'
END
ELSE
BEGIN
SELECT TOP 1 @AlmacenMP = Almacen FROM ProyectoDArtMaterial WHERE ID = @IDProyecto
INSERT Compra (Empresa,     Mov,    FechaEmision,   UltimoCambio,   Proyecto,   Moneda,      Estatus,       Usuario,  Sucursal,	 TipoCambio,  UEN,	Proveedor,	Almacen, OrigenTipo, Origen, OrigenID)
VALUES        (@Empresa,    @Mov,   GETDATE(),      GETDATE(),      @Proyecto,  @Moneda,    'SINAFECTAR',   @Usuario, @Sucursal, @TipoCambio, @UEN,	@Proveedor, @AlmacenMP, 'PROY', @Origen, @OrigenID)
SELECT @ID = SCOPE_IDENTITY()
SET @Renglon = 2048.0
DECLARE crMateriaPrima CURSOR LOCAL FOR
SELECT Material, Cantidad, Unidad, SubCuenta, Almacen FROM ProyectoDArtMaterial WHERE ID = @IDProyecto
OPEN crMateriaPrima
FETCH NEXT FROM crMateriaPrima INTO @ArticuloMP, @CantidadMP, @UnidadMP, @SubCuentaMP, @AlmacenMP
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @UltimoCostoArt = 0.0
SELECT @Impuesto1MP = Impuesto1, @Impuesto2MP = Impuesto2, @Impuesto3MP = Impuesto3 FROM ART WHERE ARTICULO = @ArticuloMP
SELECT @ProveedorArt = Proveedor FROM ArtProv WHERE Articulo = @ArticuloMP
EXEC spVerCosto @Sucursal, @Empresa, @ProveedorArt, @ArticuloMP, @SubCuentaMP, @UnidadMP, @CfgCostoSugerido, @Moneda, @TipoCambio, @UltimoCostoArt OUTPUT, 0
SELECT @FactorMP = dbo.fnArtUnidadFactor(@Empresa, @ArticuloMP, @UnidadMP)
INSERT CompraD(ID,	RENGLON,	RENGLONSUB, FECHAREQUERIDA,	FECHAENTREGA,	ARTICULO,		CANTIDAD,		CANTIDADINVENTARIO,	COSTO,			ALMACEN,	IMPUESTO1,		IMPUESTO2,		IMPUESTO3,		UNIDAD,		FACTOR,		SUCURSAL,	SUCURSALORIGEN,	PAQUETE,	CambioImpuesto)
VALUES		  (@ID,	@Renglon,	0,			GETDATE(),		GETDATE(),		@ArticuloMP,	@CantidadMP,	@CantidadMP,		@UltimoCostoArt,@AlmacenMP,	@Impuesto1MP,	@Impuesto2MP,	@Impuesto3MP,	@UnidadMP,	@FactorMP,	@Sucursal,	@Sucursal,		0,			0)
END
FETCH NEXT FROM crMateriaPrima INTO @ArticuloMP, @CantidadMP, @UnidadMP, @SubCuentaMP, @AlmacenMP
SET @Renglon += 2048.0
END
CLOSE crMateriaPrima
DEALLOCATE crMateriaPrima
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID
FROM Compra
WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
ELSE IF @Ok IS NULL AND @Modulo = 'GAS' AND @MovTipo = 'GAS.PR' AND @SubTipo = 'Recurso Humano'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Gasto WHERE MOV = @Mov AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80002, @OkRef = 'Error: ya existe un Presupuesto de Gastos por RH. Si desea agregar un nuevo movimiento necesita cancelar el existente.'
END
ELSE
BEGIN
INSERT Gasto (Empresa,  Mov,    FechaEmision,   UltimoCambio,   Proyecto,   Moneda,  Usuario,  Estatus,      Prioridad,  Sucursal,	TipoCambio,  UEN,	Acreedor, OrigenTipo, Origen, OrigenID)
VALUES       (@Empresa, @Mov,   GETDATE(),      GETDATE (),     @Proyecto,  @Moneda, @Usuario, 'SINAFECTAR', 'Normal',   @Sucursal, @TipoCambio, @UEN,	@Proveedor, 'PROY', @Origen, @OrigenID)
SELECT @ID = SCOPE_IDENTITY()
SET @Renglon = 2048.0
SELECT @ConceptoRH = ConceptoRH, @ConceptoStaff = ConceptoStaff FROM ConceptosRH
IF @ConceptoRH IS NOT NULL
BEGIN
SET @ImporteRH = 0.0
DECLARE crCostoRH CURSOR LOCAL FOR
SELECT A.DuracionDias, B.CostoHora, B.HorasDia FROM ProyectoD as A, ProyectoRecurso as B, Recurso as C
WHERE A.ID = B.ID AND A.RecursosAsignados = C.Nombre AND B.Recurso = C.Recurso AND B.ID = @IDProyecto AND A.ID = @IDProyecto
OPEN crCostoRH
FETCH NEXT FROM crCostoRH INTO @DuracionDias, @CostoHora, @HorasDia
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
SET @ImporteRH+= ((@DuracionDias * @HorasDia) * @CostoHora)
FETCH NEXT FROM crCostoRH INTO @DuracionDias, @CostoHora, @HorasDia
END
CLOSE crCostoRH
DEALLOCATE crCostoRH
INSERT GastoD (ID,	RENGLON,	RENGLONSUB, FECHA,		CONCEPTO,	CANTIDAD,	PRECIO,		IMPORTE,	IMPUESTOS,	IMPUESTOS2,	IMPUESTOS3,	SUCURSAL,	SUCURSALORIGEN,	PorcentajeDeducible,	CambioImpuesto)
VALUES		  (@ID,	@Renglon,	0,			GETDATE(),	@ConceptoRH,	1,			@ImporteRH,	@ImporteRH,	0.0,		0.0,		0.0,		@Sucursal,	@Sucursal,		100.00,					0)
SET @Renglon += 2048.0
END
IF @ConceptoStaff IS NOT NULL
BEGIN
SET @ImporteRH = 0.0
INSERT GastoD (ID,	RENGLON,	RENGLONSUB, FECHA,		CONCEPTO,	CANTIDAD,	PRECIO,		IMPORTE,	IMPUESTOS,	IMPUESTOS2,	IMPUESTOS3,	SUCURSAL,	SUCURSALORIGEN,	PorcentajeDeducible,	CambioImpuesto)
VALUES		  (@ID,	@Renglon,	0,			GETDATE(),	@ConceptoStaff,	1,			@ImporteRH,	@ImporteRH,	0.0,		0.0,		0.0,		@Sucursal,	@Sucursal,		100.00,					0)
SET @Renglon += 2048.0
END
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID
FROM Gasto
WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
ELSE IF @Ok IS NULL AND @Modulo = 'GAS' AND @MovTipo = 'GAS.PR' AND @SubTipo = 'Servicio'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Gasto WHERE Mov = @Mov AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80003, @OkRef = 'Error: ya existe un Presupuesto de Gastos por Servicios. Si desea agregar un nuevo movimiento necesita cancelar el existente.'
END
ELSE
BEGIN
INSERT Gasto (Empresa,   Mov, FechaEmision,  UltimoCambio,   Proyecto,   Moneda,  Usuario,  Estatus,         Prioridad, Sucursal,	TipoCambio,  UEN,	Acreedor, OrigenTipo, Origen, OrigenID)
VALUES       (@Empresa, @Mov, GETDATE(),     GETDATE(),      @Proyecto,  @Moneda, @Usuario, 'SINAFECTAR',    'Normal',  @Sucursal, @TipoCambio, @UEN,	@Proveedor, 'PROY', @Origen, @OrigenID)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID
FROM Gasto
WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
END
IF @Ok IS NOT NULL AND @OkRef IS NOT NULL
BEGIN
SELECT @OkRef = Descripcion+' '+ISNULL(RTRIM(@OkRef), '')
FROM MensajeLista
WHERE Mensaje = @Ok
END
IF @Ok = NULL
SELECT 'Se Genero '+@Mov+ ' (por Confirmar)'
ELSE
SELECT @OkRef
RETURN
END

