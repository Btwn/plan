SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommercePedidoEnvolturasRegalo
@iSolicitud             int,
@Solicitud              varchar(max),
@IDGenerar				int,
@Ok int OUTPUT,
@OkRef varchar(255) OUTPUT

AS BEGIN
DECLARE @IDEnvoltura	int,
@Campo	varchar(255),
@Valor	varchar(max),
@Articulo varchar(10),
@SubCuenta varchar(50),
@Renglon float,
@RenglonID int,
@Precio float,
@Impuesto1 float,
@Impuesto2 float,
@Impuesto3 float,
@Sucursal int,
@Almacen varchar(10),
@Unidad varchar(50),
@Usuario varchar(10),
@Empresa varchar(5),
@Mov varchar(20),
@Cliente varchar(10),
@GUIDUsuario varchar(50)
DECLARE @TablaVentaDWeb table (
ID			int,
IDCampo		int,
Campo	varchar(255),
Valor	text
)
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT INTO @TablaVentaDWeb (ID, IDCampo, Campo, Valor)
SELECT        ID, IDCampo, Campo, Valor
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Pedido/PedidoD/CamposConfigurables/CampoConfigurable',1)
WITH (ID int '../../@ID', IDCampo int, Campo varchar(50), Valor varchar(max))
SELECT @Empresa = Empresa, @Sucursal = Sucursal
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Pedido')
WITH (Empresa varchar(5), Sucursal int)
SELECT @GUIDUsuario = GUID FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Pedido/Usuario')
WITH (GUID varchar(50))
IF @@ERROR<>0 SET @Ok = 1
EXEC sp_xml_removedocument @iSolicitud
SELECT @Cliente = Cliente FROM WebUsuarios WHERE  GUID = @GUIDUsuario
SELECT @Almacen = eCommerceAlmacen
FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Mov = eCommercePedido
FROM Sucursal WHERE Sucursal = @Sucursal
DECLARE crVentaDWeb CURSOR LOCAL FOR
SELECT Campo, Valor
FROM @TablaVentaDWeb
OPEN crVentaDWeb
FETCH NEXT FROM crVentaDWeb INTO @Campo, @Valor
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF(SUBSTRING(@Campo, 1, 18) = 'Envoltura Regalo #')
BEGIN
SELECT @IDEnvoltura = SUBSTRING(@Campo, 19, LEN(@Campo))
SELECT @Articulo = Articulo, @SubCuenta = SubCuenta, @Precio = Precio
FROM WebEnvolturaRegalo
WHERE ID = @IDEnvoltura
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @Articulo
EXEC spDesglosarPrecioCImpuestos2  @Articulo , @Usuario, @Empresa, @Sucursal, @Precio OUTPUT, @Cliente, 'VTAS', @Mov, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3  OUTPUT
IF(ISNULL(@Articulo, '') != '')
BEGIN
SELECT @Renglon = MAX(Renglon)+2048.0, @RenglonID = MAX(RenglonID) +1 FROM VentaD WHERE ID = @IDGenerar
INSERT VentaD(ID ,        Renglon,   RenglonID, Articulo,  SubCuenta,  Almacen,  Precio,  Cantidad, CantidadInventario,   Unidad, Impuesto1,  Impuesto2,  Impuesto3)
SELECT        @IDGenerar, @Renglon, @RenglonID, @Articulo, @SubCuenta, @Almacen, @Precio, 1,     1,                   @Unidad, @Impuesto1, @Impuesto2, @Impuesto3
END
END
FETCH NEXT FROM crVentaDWeb INTO @Campo, @Valor
END
CLOSE crVentaDWeb
DEALLOCATE crVentaDWeb
END

