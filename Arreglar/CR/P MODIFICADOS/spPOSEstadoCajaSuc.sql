SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSEstadoCajaSuc
@ID   varchar(36),
@Usuario varchar(10)

AS BEGIN
DECLARE	@EstatusCaja		varchar(50),
@Caja				varchar(10),
@Host				varchar(20),
@Cajero				varchar(10),
@Abierto			bit,
@EsSucursal			bit,
@POSEsSupervisor	bit,
@DefSucursal		int,
@DefAlmacen			varchar(10),
@DefCtaDinero		varchar(10),
@DefCtaDineroTrans	varchar(10),
@DefAlmacenSuc		int,
@DefCtaDineroSuc	int,
@DefCtaDineroTransSuc int,
@DefListaPreciosEsp varchar (20),
@SucListaPreciosEsp varchar (20),
@Bandera			int,
@EsConcentradora	bit,
@DefCajero			varchar(10),
@Sucursal			int
SELECT @Bandera = 0  , @EstatusCaja = NULL,  @Sucursal = ISNULL(Sucursal,0) FROM POSiSync WITH (NOLOCK)
SELECT @POSEsSupervisor =		ISNULL(u.POSEsSupervisor,0),
@DefSucursal =			u.Sucursal,
@DefCtaDinero =			u.DefCtaDinero,
@DefCtaDineroTrans =	u.DefCtaDineroTrans,
@DefAlmacen =			u.DefAlmacen,
@DefListaPreciosEsp =	RTRIM(u.DefListaPreciosEsp),
@DefCajero =			RTRIM(u.DefCajero)
FROM Usuario u WITH (NOLOCK)
WHERE u.Usuario = @Usuario
SELECT @SucListaPreciosEsp = RTRIM(ListaPreciosEsp) FROM Sucursal WITH (NOLOCK) WHERE Sucursal = @Sucursal
SELECT @DefCtaDineroSuc = Sucursal					 FROM CtaDinero WITH (NOLOCK) WHERE CtaDinero = @DefCtaDinero
SELECT @DefCtaDineroTransSuc = Sucursal			 FROM CtaDinero WITH (NOLOCK) WHERE CtaDinero = @DefCtaDineroTrans
SELECT @DefAlmacenSuc = Sucursal					 FROM Alm WITH (NOLOCK)  WHERE Almacen = @DefAlmacen
IF @Bandera = 0 AND @Sucursal <> @DefSucursal     SELECT @Bandera = 1
IF @Bandera = 0 AND @Sucursal <> @DefCtaDineroSuc    SELECT @Bandera = 2
IF @Bandera = 0 AND @Sucursal <> @DefAlmacenSuc    SELECT @Bandera = 3
IF @Bandera = 0 AND @SucListaPreciosEsp <> @DefListaPreciosEsp SELECT @Bandera = 4
IF @Bandera = 1 SELECT @EstatusCaja = 'DefSucursal'
IF @Bandera = 2 SELECT @EstatusCaja = 'DefCtaDineroSuc'
IF @Bandera = 3 SELECT @EstatusCaja = 'DefAlmacenSuc'
IF @Bandera = 4 SELECT @EstatusCaja = 'DefListaPreciosEsp'
IF @Bandera = 0 SELECT @EstatusCaja = 'OK'
SELECT @EstatusCaja
END

