SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceVentaC ON  Venta

FOR UPDATE
AS BEGIN
DECLARE
@Ok			int,
@Modulo		char(5),
@Mov		char(20),
@MovIDN		char(20),
@MovIDA		char(20),
@Sucursal		int,
@ID			int,
@FechaInicio	datetime,
@Ahora 		datetime,
@FechaAnterior	datetime,
@EstatusNuevo 	char(15),
@EstatusAnterior 	char(15),
@SituacionNueva 	varchar(50),
@SituacionAnterior 	varchar(50),
@FechaRequeridaN	datetime,
@FechaRequeridaA	datetime,
@Tipo		varchar(50),
@UsuarioA		char(10),
@UsuarioN		char(10),
@Mensaje		char(255),
@eCommerceSucursal  varchar(20),
@OrigenID           varchar(20),
@eCommerceEmpresa   bit,
@Empresa		varchar(5)
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
SELECT @Modulo = 'VTAS', @Ok = NULL
SELECT @EstatusAnterior = NULLIF(RTRIM(Estatus), ''), @SituacionAnterior = NULLIF(RTRIM(Situacion), ''), @MovIDA = NULLIF(RTRIM(MovID), '')  FROM Deleted
SELECT @ID = ID, @EstatusNuevo    = NULLIF(RTRIM(Estatus), ''), @SituacionNueva    = NULLIF(RTRIM(Situacion), ''), @Mov = NULLIF(RTRIM(Mov), ''), @MovIDN = NULLIF(RTRIM(MovID), ''),@Tipo = NULLIF(RTRIM(ServicioTipo), '') FROM Inserted
IF   dbo.fneCommerceOrigen('VTAS',@ID,1) = 1  AND(@SituacionAnterior <> @SituacionNueva AND @SituacionNueva IS NOT NULL
AND EXISTS (SELECT * FROM WebSituacionEstatus w WHERE w.Modulo = 'VTAS' AND  w.Situacion = @SituacionNueva AND w.Mov = @Mov AND w.Estatus = @EstatusNuevo
AND @SituacionNueva IN (SELECT Situacion FROM MovSituacion WHERE Modulo = 'VTAS' AND Mov = @Mov AND Estatus = @EstatusNuevo AND Tipo = @Tipo AND UPPER(Flujo) IN ('INICIAL TODAS', 'INICIAL ESPECIAL'))))
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @OrigenID = ISNULL(dbo.fneCommerceIDOrigen(@Modulo,@ID,1),@ID)
EXEC speCommerceSolicitudISWebMovSituacion @OrigenID,'VTAS',@ID, @EstatusNuevo, @Sucursal, @eCommerceSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
END

