SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIVerificarPersonal
@Empresa       varchar(5),
@TablaPeriodo  varchar(10),
@Estacion      int

AS BEGIN
DECLARE
@EmpresaNOI         varchar(2),
@Ok                 int,
@OKRef              varchar(255),
@Verificado         bit,
@Personal           varchar(10),
@Nombre             varchar(30),
@ApellidoPaterno    varchar(30),
@ApellidoMaterno    varchar(30),
@FechaAlta          datetime,
@FormaPago          varchar(50),
@Departamento       varchar(50),
@Puesto             varchar(50),
@SueldoDiario       money
SElECT @Ok = NULL,@OKRef = NULL, @Verificado =0
SELECT @EmpresaNOI = EmpresaAspel
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
DECLARE crDetalle CURSOR FOR
SELECT  Personal,Nombre,ApellidoPaterno,ApellidoMaterno,FechaAlta,FormaPago,SueldoDiario,Departamento,Puesto
FROM NOIPersonal
WHERE EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno,@FechaAlta,@FormaPago, @SueldoDiario, @Departamento, @Puesto
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Verificado = 0 ,@Ok = NULL,@OkRef= NULL
IF NULLIF(@ApellidoPaterno,'') IS NULL
SELECT @Ok = 74100
IF NULLIF(@Nombre,'') IS NULL
SELECT @Ok = 74105
IF NULLIF(@FormaPago,'') IS NULL
SELECT @Ok = 74110
IF @SueldoDiario IS NULL
SELECT @Ok = 74115
IF @FechaAlta IS NULL
SELECT @Ok = 74120
IF NULLIF(@ApellidoPaterno,'') IS NULL
SELECT @Ok = 74100
IF NULLIF(@Departamento,'') IS NULL OR NOT EXISTS (SELECT * FROM Departamento WHERE Departamento = @Departamento)
SELECT @Ok = 74125
IF NULLIF(@Puesto,'') IS NULL OR NOT EXISTS (SELECT * FROM Puesto WHERE Puesto = @Puesto)
SELECT @Ok = 74130
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion
FROM MensajeLista
WHERE  Mensaje = @Ok
IF @Ok IS NULL SET @Verificado = 1
UPDATE NOIPersonal SET Verificado = @Verificado,Ok = @OK,OkRef = @OkRef
WHERE Personal = @Personal AND EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion
FETCH NEXT FROM crDetalle INTO  @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno,@FechaAlta,@FormaPago, @SueldoDiario, @Departamento, @Puesto
END
CLOSE crDetalle
DEALLOCATE crDetalle
UPDATE NOINomina
SET Ok = p.Ok,OkRef =p.OkRef,Verificado = p.Verificado
FROM NOINomina n JOIN  NOIPersonal p ON n.Personal = p.Personal AND p.Estacion = n.Estacion AND p.Nomina = n.Nomina
WHERE n.EmpresaNOI = @EmpresaNOI AND n.Nomina = @TablaPeriodo AND n.Estacion = @Estacion AND n.Ok <> 30100
END

