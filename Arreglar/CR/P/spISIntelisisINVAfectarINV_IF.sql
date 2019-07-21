SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisINVAfectarINV_IF
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar					int,
@IDAcceso					int,
@MovTipo					varchar(20),
@ReferenciaIS				varchar(100),
@Usuario2					varchar(10),
@Estacion					int,
@SubReferencia				varchar(100),
@Empresa   				    varchar(5),
@Mov   					    varchar(20),
@MovID   					varchar(20),
@Sucursal                   int,
@ID2                        int,
@Tarima                     varchar(20),
@Sucursal2                  varchar(100),
@Posicion                   varchar(20),
@PosicionDestino            varchar(20),
@Usuario                    varchar(15),
@Montacargas                varchar(20),
@Estatus                    varchar(20),
@Agente                     varchar(20),
@Modificar                  bit,
@Procesado                  bit,
@Mov2  					    varchar(20),
@Mov3  					    varchar(20),
@MovID2   					varchar(20),
@PosicionDGenerar           varchar(20),
@Descripcion                varchar(100),
@RenglonID					float,
@RenglonID2					float,
@InvFisicoConteo			int
BEGIN TRANSACTION
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WHERE ID = @IDAcceso
SELECT  @Usuario   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro') 
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AgenteA'
IF @Ok IS NULL
BEGIN
SELECT  @ID2   = NULLIF(ID,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/INV')
WITH(ID    varchar(255))
END
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Empresa = Empresa FROM Inv WHERE ID = @ID2
SELECT @MovTipo = Clave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'INV'
IF @MovTipo NOT IN('INV.IF')
SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL AND @Estatus = 'SINAFECTAR' AND @MovTipo = 'INV.IF'
BEGIN
SELECT @InvFisicoConteo = ISNULL(InvFisicoConteo,1) FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Mov3 = InvAjuste FROM EmpresaCfgMov WHERE Empresa = @Empresa
/*
IF @Ok IS NULL AND @InvFisicoConteo > 1
EXEC spAfectar 'INV', @ID2, 'AFECTAR', 'Todo', @Mov3, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @InvFisicoConteo > 2
EXEC spAfectar 'INV', @ID2, 'AFECTAR', 'Todo', @Mov3, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
*/
IF @Ok IS NULL
BEGIN
DELETE FROM SerieLoteMov
WHERE Empresa = @Empresa
AND Modulo = 'INV'
AND ID = @ID2
INSERT SerieLoteMov(
Empresa, Modulo, ID, RenglonID, Articulo,
SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv,
Tarima)
SELECT Empresa,Modulo,ID,RenglonID,Articulo,
SubCuenta,SerieLote,Cantidad,CantidadAlterna,Propiedades,
Ubicacion,Cliente,Localizacion,Sucursal,ArtCostoInv,
Tarima
FROM SerieLoteMovMovil
WHERE Empresa = @Empresa
AND Modulo = 'INV'
AND ID = @ID2
END
/*  
EXEC @IDGenerar =  spAfectar 'INV', @ID2, 'AFECTAR', 'Seleccion', @Mov3, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
SELECT @RenglonID = MAX(RenglonID)
FROM SerieLoteMov
WHERE ID = @IDGenerar
AND Modulo = 'INV'
AND Empresa = @Empresa
DECLARE crRenglonID CURSOR LOCAL FOR
SELECT RenglonID
FROM SerieLoteMovMovil
WHERE ID = @ID2
AND Procesado = 0
OPEN crRenglonID
FETCH NEXT FROM crRenglonID INTO @RenglonID2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @RenglonID = @RenglonID + 1
INSERT INTO SerieLoteMov (Empresa, Modulo, ID,		  RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades, Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv)
SELECT                    Empresa, Modulo, @IDGenerar, @RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades, Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv
FROM SerieLoteMovMovil
WHERE ID = @ID2
AND Procesado = 0
AND RenglonID = @RenglonID2
AND Modulo = 'INV'
AND Empresa = @Empresa
UPDATE SerieLoteMovMovil SET Procesado = 1 WHERE ID = @ID2 AND Procesado = 0 AND RenglonID = @RenglonID2
FETCH NEXT FROM crRenglonID INTO @RenglonID2
END
CLOSE crRenglonID
DEALLOCATE crRenglonID
DELETE SerieLoteMov WHERE ID = @IDGenerar AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Cantidad, 0) <= 0
IF @Ok IS NULL
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok = 72060 SELECT @Ok = 80070 
*/ 
IF @Ok BETWEEN 80030 AND 81000
IF @Ok NOT IN (80070) 
SELECT @Ok = NULL , @OkRef = NULL
END
IF @Ok BETWEEN 80030 AND 81000
IF @Ok NOT IN (80070) 
SELECT @Ok = NULL , @OkRef = NULL
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @OkRef = REPLACE(@OkRef, '<BR>' , '')
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="INV" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) +'  Mov=' + CHAR(34) + ISNULL(@Mov2,'') + CHAR(34) +'  MovID=' + CHAR(34) + ISNULL(@MovID2,'') + CHAR(34)  +'  PosicionDestino=' + CHAR(34) + ISNULL(@PosicionDGenerar,'') + CHAR(34) +'  DescripcionPosicionDestino=' + CHAR(34) + ISNULL(@Descripcion,'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

