SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFlujoSAUX
@Modulo			varchar(5),
@ID		        int,
@Accion			varchar(20),
@Base			varchar(20),
@MovGenerar		char(20),
@FechaRegistro	datetime,
@Empresa        varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Conexion		bit,
@SincroFinal	bit,
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo		varchar(20),
@Almacen		varchar(10),
@FechaEmision	datetime,
@Proyecto	    varchar(50),
@Ok             int           	OUTPUT,
@OkRef          varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@ModuloDestino			varchar(5),
@MovDestino				varchar(20),
@ModuloOrigen			varchar(20),
@Estatus				varchar(20),
@EstatusGenerar			varchar(20),
@Articulo				varchar(20),
@Material				varchar(20),
@Cantidad				float,
@IDGenerar				int,
@Renglon				float,
@RenglonID				int,
@Merma					float,
@Desperdicio			float,
@Unidad					varchar(50),
@MovIDGenerar			varchar(20),
@IDCancelar				int,
@MovIDDestino			varchar(20),
@Moneda					varchar(10),
@TipoCambio				float,
@TipoCosteo				varchar(20),
@Costo					float,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@ContID					int,
@VolverAfectar			int,
@ArtTipo	         	varchar(20),
@SubCuenta				varchar(50),
@Factor					float,
@CantidadInventario		float,
@RenglonTipo			char(1),
@DetalleTipo			varchar(20),
@SubProducto			varchar(50),
@MovSS					varchar(20),
@MovIDSS				varchar(20),
@IDSS					int,
@DID					int,
@EstatusD				varchar(20)
IF @Modulo = 'INV'
SELECT @Estatus = Estatus FROM Inv WHERE ID = @ID
SELECT TOP 1
@MovDestino = ISNULL(RTRIM(LTRIM(SAUXMov)),''),
@ModuloDestino = 'SAUX'
FROM MovTipo
WHERE Mov = @Mov
AND Modulo = @Modulo
AND Clave = @MovTipo
IF @Modulo = 'VTAS' AND NOT EXISTS(SELECT * FROM Art WHERE Articulo IN (SELECT Articulo FROM VentaD WHERE ID = @ID)AND SAUX = 1 AND Tipo = 'Servicio')
RETURN
ELSE
IF @Modulo = 'COMS' AND NOT EXISTS(SELECT * FROM Art WHERE Articulo IN (SELECT Articulo FROM CompraD WHERE ID = @ID)AND SAUX = 1 AND Tipo = 'Servicio')
RETURN
ELSE
IF @ModuloDestino = 'SAUX' AND @Modulo IN ('VTAS', 'COMS') AND @MovDestino <> ''
BEGIN
SELECT @IDSS = s.ID,
@MovSS = s.Mov,
@MovIDSS = s.MovID
FROM SAUX s
JOIN Venta v
ON s.OrigenTipo = @Modulo
AND s.Origen = v.Mov
AND s.OrigenID = v.MovID
AND s.Empresa = v.Empresa
WHERE s.OrigenTipo = @Modulo
AND s.Origen = @Mov
AND s.OrigenID = @MovID
AND s.Empresa = @Empresa
IF EXISTS(SELECT * FROM SAUX WHERE Origen = @MovSS AND OrigenID = @MovIDSS AND Estatus <> 'CANCELADO') AND @Accion = 'CANCELAR'
SELECT @Ok = 60060
IF @Accion = 'CANCELAR'
BEGIN
IF @Modulo = 'COMS'
SELECT @DID = DID FROM MovFlujo WHERE OID = @ID AND OModulo = 'COMS' AND DModulo = 'SAUX'
IF @Modulo = 'VTAS'
SELECT @DID = DID FROM MovFlujo WHERE OID = @ID AND OModulo = 'VTAS' AND DModulo = 'SAUX'
SELECT @EstatusD = Estatus FROM SAUX WHERE ID = @DID
IF @EstatusD = 'CONCLUIDO'
SELECT @OK = 60060, @OkRef = RTRIM(@Mov)+' '+LTRIM(Convert(char, @MovID))
END
IF @Ok IS NULL
EXEC spSAUXGenerar @Modulo, @ID, @Accion, @Base, @FechaRegistro, @MovGenerar, @Empresa, @Sucursal, @Usuario, @Conexion, @SincroFinal, @Mov, @MovID, @MovTipo, @Almacen, @FechaEmision, @ModuloDestino, @MovDestino, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

