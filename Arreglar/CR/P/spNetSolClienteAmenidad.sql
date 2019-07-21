SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetSolClienteAmenidad
@Cliente			VARCHAR(20),
@DiaCompletoHora	VARCHAR(20),
@Espacio			VARCHAR(20),
@FechaDesde			VARCHAR(20),
@FechaHasta			VARCHAR(20),
@FechaRegistro		VARCHAR(20),
@HorasEvento		VARCHAR(MAX),
@NomCteInquilino	VARCHAR(100),
@NumPersonas		INT,
@Observaciones		VARCHAR(100),
@Telefono			VARCHAR(100),
@Vivienda			VARCHAR(20),
@eMail				VARCHAR(255) = NULL,
@IDSol					INT = NULL
AS BEGIN
/*Extrae Datos para obtener Info de la Venta*/
DECLARE
@ID				INT,
@Articulo		VARCHAR(20),
@Descripcion	VARCHAR(100),
@MonedaTipo		CHAR(10),
@TipoCambio		FLOAT,
@Empresa		CHAR(5),
@Sucursal		INT,
@Responsable	VARCHAR(100),
@Mov			VARCHAR(20),
@SituacionTipo	VARCHAR(20),
@MonedaPrecio	VARCHAR(10),
@TipoArticulo	VARCHAR(20),
@OcupacionMax	INT,
@Precio			MONEY,
@Almacen		VARCHAR(20),
@Renglon		FLOAT,
@RenglonID		INT,
@NumHorasRes	INT,
@IDAmenidades   INT,
@Ok				INT,
@OkRef			VARCHAR(255),
@VentaFactura	CHAR(20)
EXEC spNetDisponibilidadAmenidad @Cliente,@DiaCompletoHora,@Espacio, @FechaDesde,@FechaHasta,@HorasEvento,@IDSol,@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @Empresa = CteRep.Empresa, @Sucursal = CteRep.Sucursal, @Responsable = CteRep.Responsable
FROM Cte Cte
LEFT JOIN CteRep CteRep ON Cte.Cliente = CteRep.Cliente
WHERE Cte.Cliente = @Cliente
AND Cte.Estatus = 'Alta'
SELECT @MonedaTipo = Moneda , @TipoCambio = TipoCambio FROM Mon WHERE Mon.Moneda = 'Dolares'
SELECT @VentaFactura = VentaFactura FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @SituacionTipo = dbo.fnMovSituacionTipoFlujo(@Empresa, 'VTAS', @VentaFactura, 'SINAFECTAR')
SELECT @Almacen = AlmacenTransito FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Articulo = A.Articulo,@Descripcion = A.Descripcion1,@TipoArticulo = A.Tipo,@MonedaPrecio = A.MonedaPrecio,@Precio = A.PrecioLista
FROM Art A
JOIN ArtEspacio AE ON A.Articulo = AE.Articulo AND A.Estatus = 'Alta'
JOIN Espacio E ON AE.Espacio = E.Espacio AND E.Estatus = 'Alta'
WHERE
E.Espacio = @Espacio
SELECT  @Mov = Mov
FROM MovTipo MT
JOIN EmpresaCfgMov ECM ON MT.Mov = ECM.VentaFactura
WHERE ECM.Empresa =  @Empresa
AND Modulo = 'VTAS'
SET @Renglon = 0
SET @RenglonID = 0
BEGIN TRAN
IF @IDSol IS NULL
BEGIN
INSERT INTO VENTA (Empresa,Mov,FechaEmision,UltimoCambio,Concepto,Moneda,TipoCambio,Usuario,Estatus,Directo,Prioridad,FechaOriginal,Cliente,Almacen,FechaRequerida,Vencimiento,Comentarios,Referencia)
VALUES (@Empresa,@Mov,GETDATE(),GETDATE(),@Descripcion,@MonedaTipo,@TipoCambio,@Responsable,'SINAFECTAR',1,@SituacionTipo,CONVERT(DATETIME,@FechaHasta),@Cliente,@Almacen,CONVERT(DATETIME,@FechaDesde),GETDATE(),@Observaciones,@Cliente)
SET @ID = @@IDENTITY
END
ELSE
BEGIN
SET @ID = @IDSol
IF  EXISTS( SELECT * FROM VentaD WHERE ID = @IDSol)
BEGIN
SELECT @Renglon = MAX(Renglon),  @RenglonID = MAX(RenglonID) FROM VentaD WHERE ID = @IDSol
END
END
DECLARE @HoraRequerida NVARCHAR(255)
DECLARE db_cursor CURSOR FOR
SELECT * FROM dbo.splitstring(@HorasEvento)
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @HoraRequerida
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @RenglonTipo	CHAR(1)
EXEC spRenglonTipo @TipoArticulo, NULL, @RenglonTipo OUTPUT
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
INSERT INTO VentaD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, EnviarA, Almacen, Codigo, SubCuenta, Articulo, Cantidad, Precio, PrecioSugerido, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Costo, Paquete, ContUso, Comision, Aplica, AplicaID, CantidadA, Factor, SustitutoArticulo, SustitutoSubCuenta, Unidad, FechaRequerida, Instruccion, CantidadInventario, Agente, Departamento, Sucursal, PoliticaPrecios, SucursalOrigen, AutoLocalidad, UEN, Espacio, HoraRequerida,CantidadAlterna, PrecioMoneda, PrecioTipoCambio, Estado, ServicioNumero, AgentesAsignados, AFArticulo, AFSerie, ExcluirPlaneacion, ExcluirISAN, Posicion, PresupuestoEsp, ProveedorRef, TransferirA, Tarima, ContUso2, ContUso3, ABC, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Retencion1, Retencion2, Retencion3, AnticipoFacturado, RecargaTelefono, RecargaConfirmarTelefono, LDIReferencia, LDICuenta, POSDesGlobal, POSDesLinea)
VALUES
(@ID, @Renglon, 0,  @RenglonID, @RenglonTipo, NULL, @Almacen, NULL, NULL, @Articulo, 1.0, @Precio, @Precio, NULL, 0.0, NULL, 0.0, 0.0, 0.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, 1.0, NULL, NULL, NULL, CONVERT(datetime,dateadd(day, datediff(day,'19000101',CONVERT(DATETIME,@FechaDesde)), CAST(@HoraRequerida AS DATETIME))), NULL, NULL, NULL, NULL, @Sucursal, NULL, 0, NULL, NULL, @Espacio, @HoraRequerida, NULL, @MonedaTipo, 1.0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
FETCH NEXT FROM db_cursor INTO @HoraRequerida
END
CLOSE db_cursor
DEALLOCATE db_cursor
INSERT INTO Amenidades(Espacio,DiaCompletoHora,FechaRegistro,FechaDesde,FechaHasta,NumPersonas,Cliente,
NomCteInquilino,Vivienda,Telefono,eMail,Observaciones,Mov,MovID,IDMovDet)
VALUES(@Espacio,@DiaCompletoHora,@FechaRegistro,@FechaDesde,CONVERT(DATETIME,@FechaHasta),@NumPersonas,@Cliente,
@NomCteInquilino,@Vivienda,@Telefono,ISNULL(@eMail,''),ISNULL(@Observaciones,''),@Mov,NULL,@ID)
SET @IDAmenidades = @@IDENTITY
EXEC spAfectar 'VTAS', @ID, 'VERIFICAR', NULL, NULL, @Responsable, @Estacion=5, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok >= 80000
COMMIT TRAN
ELSE
BEGIN
ROLLBACK
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END
END
ELSE
BEGIN
SET @ID = @IDSol
END
SELECT @ID as ID, @Ok Ok, @OkRef OkRef
END

