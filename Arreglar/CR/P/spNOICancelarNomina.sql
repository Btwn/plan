SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOICancelarNomina
@Empresa       varchar(5),
@Estacion      int,
@ID            int,
@Usuario       varchar(10),
@FechaA        datetime

AS BEGIN
DECLARE @BaseNOI        varchar (100),
@EmpresaNOI     varchar(2),
@Estatus        varchar(15),
@SQL            varchar(max),
@Ok             int,
@OkRef          varchar(255)
SELECT @BaseNOI = '['+Servidor +'].'+BaseDatosNombre,@EmpresaNOI = EmpresaAspel
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SELECT @Estatus = Estatus FROM Nomina WHERE ID = @ID
IF @Estatus <> 'BORRADOR'
EXEC spAfectar 'NOM', @ID, 'CANCELAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL =' UPDATE ' + @BaseNOI + '.dbo.INTELISIS' + @EmpresaNOI +' SET  INTELISIS = 0 WHERE FECH_NOM_FIN = '+CHAR(39)+dbo.fnFormatearFecha(@FechaA,'DD/MM/AAAA')+CHAR(39)
EXEC (@SQL)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
SELECT 'Se Activo La Nomina del '+dbo.fnFormatearFecha(@FechaA,'DD/MM/AAAA')
ELSE
SELECT @OkRef
RETURN
END

