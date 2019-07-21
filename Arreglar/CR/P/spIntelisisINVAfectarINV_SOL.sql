SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisINVAfectarINV_SOL
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ID2                int,
@ID3                int,
@IDGenerar          int,
@IDAcceso           int,
@Estacion           int,
@Empresa            varchar(5),
@Mov                varchar(20),
@Mov2                varchar(20),
@Usuario            varchar(20),
@CB                 varchar(30),
@Cantidad           float,
@MovID  			varchar(20),
@Articulo 			varchar(20),
@SubCuenta 			varchar(50),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@Caducidad          datetime,
@FechaCaducidad     int,
@Fecha              datetime,
@Verifica           int,
@Verifica2          int,
@Sucursal           int,
@Partidas           int, /*RJP 171110 Cuenta partidas con CantidadA > 0*/
@Referencia         varchar (50) 
BEGIN TRANSACTION
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WHERE ID = @IDAcceso
SELECT  @Empresa   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Usuario = NULLIF(Usuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Usuario   varchar(255))
SELECT  @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT  @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ID2 = ID FROM Compra WHERE  Mov=@Mov AND MovID =@MovID AND Empresa=@Empresa
SELECT @ID3 = f.DID
FROM MovFlujo f
JOIN MovTipo t
ON f.DMov = t.Mov AND f.DModulo = t.Modulo
WHERE f.OModulo = 'COMS'
AND f.OID = @ID2
AND f.DModulo = 'INV'
AND f.Empresa = @Empresa
AND t.Clave = 'INV.SOL'
/*RJP 171110 Valida que existan partidas recibidas para que la entrada de compra no se genere vacia*/
IF @OK is NULL
BEGIN
SELECT @Partidas = count(ID) FROM InvD WHERE ID = @ID3
IF @Partidas = 0
SET @OK = 60010 
END
IF @Ok IS NULL
BEGIN
SELECT @Mov2 = InvEntarimado FROM EmpresaCfgMov WHERE Empresa = @Empresa
EXEC  @IDGenerar=spAfectar 'INV', @ID3, 'GENERAR', 'Pendiente', @Mov2, @Usuario, @Estacion=@Estacion, @EnSilencio=1, @Conexion=0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000     SELECT @Ok = NULL
END
IF @Ok IS NULL
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion=@Estacion, @EnSilencio=1, @Conexion=0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NULL
SELECT @Referencia = Idioma from compra
where ID = @ID2
UPDATE Inv set Referencia = @Referencia
Where ID = @IDGenerar
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '></Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END
END

