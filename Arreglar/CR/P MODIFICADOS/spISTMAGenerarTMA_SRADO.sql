SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISTMAGenerarTMA_SRADO
@ID				int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Tarima			varchar(20),
@Posicion		varchar(10),
@Articulo		varchar(20),
@IDDestino      int             OUTPUT,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @IDOrigen				int,
@Accion				char(20),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             	varchar(20),
@MovTipo     			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      	datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Autorizacion      	char(10),
@DocFuente	      	int,
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo			char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      		int,
@MovUsuario			char(10),
@SucursalDestino		int,
@SucursalOrigen		int,
@SucursalFiltro		int
SELECT  @IDOrigen				= @ID,
@Accion				= 'AFECTAR',
@Modulo	      		= 'TMA',
@Mov	  	      		= TMA.Mov,
@MovID             	= MovID,
@MovTipo     			= MovTipo.Clave,
@MovMoneda			= NULL,
@MovTipoCambio		= NULL,
@FechaEmision      	= GETDATE(),
@Proyecto	      		= Proyecto,
@Autorizacion      	= NULL,
@DocFuente	      	= NULL,
@Observaciones     	= 'Solicitud Patinero',
@Concepto     		= Concepto,
@Referencia			= Referencia,
@Estatus           	= 'SINAFECTAR',
@EstatusNuevo			= 'PENDIENTE',
@SucursalFiltro		= SucursalFiltro,
@SucursalDestino		= SucursalDestino
FROM TMA WITH (NOLOCK)
JOIN MovTipo WITH (NOLOCK) ON MovTipo.Modulo = 'TMA' AND MovTipo.Mov = TMA.Mov
WHERE TMA.ID = @ID
EXEC spExtraerFecha @FechaEmision OUTPUT
EXEC spTMAReacomodoSolicitar @ID, @@SPID, @IDOrigen, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion,
@FechaConclusion, @Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus,
@EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @Sucursal, @SucursalDestino, @SucursalOrigen,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @TarimaEsp = @Tarima, @PosicionEsp = @Posicion,
@ArticuloEsp = @Articulo, @IDDestino = @IDDestino OUTPUT,
@SucursalFiltro = @SucursalFiltro
END

