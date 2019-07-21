SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHControlPlazas
@Accion	 	char(20),
@CfgControlPlazas	varchar(20),
@Empresa	 	char(5),
@SucursalTrabajo	int,
@MovTipo	 	char(20),
@FechaAlta		datetime,
@Personal	 	char(10),
@Plaza		varchar(20),
@Puesto	 	varchar(50),
@Departamento 	varchar(50),
@SubClave		varchar(20),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@Cantidad		  	int,
@Plazas		  	int,
@EnUso		  	int,
@PersonalPuesto	  	varchar(50),
@PersonalDepartamento 	varchar(50),
@PersonalSucursalTrabajo	int,
@PlazaPuesto	  	varchar(50),
@PlazaDepartamento 		varchar(50),
@PlazaPersonal		varchar(10),
@PlazaActual		varchar(20)
IF @CfgControlPlazas = 'SIMPLE'
BEGIN
IF @Accion <> 'CANCELAR' SELECT @Cantidad = 1 ELSE SELECT @Cantidad = -1
SELECT @PersonalPuesto = NULLIF(RTRIM(Puesto), ''), @PersonalDepartamento = NULLIF(RTRIM(Departamento), ''), @PersonalSucursalTrabajo = SucursalTrabajo
FROM Personal
WHERE Personal = @Personal
IF @MovTipo <> 'RH.A' AND @PersonalPuesto IS NOT NULL AND @PersonalDepartamento IS NOT NULL
BEGIN
UPDATE RHPlaza
SET @Plazas = Plazas, @EnUso = EnUso = NULLIF(ISNULL(EnUso, 0) - @Cantidad, 0)
WHERE Empresa = @Empresa AND Sucursal = @PersonalSucursalTrabajo AND Puesto = @PersonalPuesto AND Departamento = @PersonalDepartamento
IF @@ROWCOUNT = 0 SELECT @Ok = 55350 ELSE
IF @Plazas < @EnUso SELECT @Ok = 55340
END
IF @MovTipo <> 'RH.B' AND @Puesto IS NOT NULL AND @Departamento IS NOT NULL AND @Ok IS NULL
BEGIN
UPDATE RHPlaza
SET @Plazas = Plazas, @EnUso = EnUso = NULLIF(ISNULL(EnUso, 0) + @Cantidad, 0)
WHERE Empresa = @Empresa AND Sucursal = @SucursalTrabajo AND Puesto = @Puesto AND Departamento = @Departamento
IF @@ROWCOUNT = 0 SELECT @Ok = 55350 ELSE
IF @Plazas < @EnUso SELECT @Ok = 55340
END
END ELSE
IF @CfgControlPlazas = 'AVANZADO'
BEGIN
IF @MovTipo = 'RH.A' AND @Accion = 'CANCELAR'
SELECT @Plaza = Plaza FROM Personal WHERE Personal = @Personal
IF @MovTipo = 'RH.M' AND @Accion = 'CANCELAR'
SELECT @PlazaActual = Plaza FROM Personal WHERE Personal = @Personal
IF NULLIF(RTRIM(@Plaza), '') IS NULL
SELECT @Ok = 55400
ELSE BEGIN
SELECT @PlazaPersonal = NULLIF(RTRIM(Personal), '') FROM Plaza WHERE Plaza = @Plaza
IF @Accion = 'CANCELAR'
BEGIN
IF @PlazaPersonal is not null AND @PlazaPersonal <> @Personal
SELECT @Ok = 55410, @OkRef = @PlazaPersonal
ELSE
BEGIN
IF @MovTipo = 'RH.A'
BEGIN
UPDATE Plaza SET Personal = NULL WHERE Plaza = @Plaza
UPDATE Personal SET Plaza = NULL WHERE Personal = @Personal
END
IF @MovTipo = 'RH.M'
BEGIN
UPDATE Plaza SET Personal = @Personal WHERE Plaza = @Plaza
UPDATE Plaza SET Personal = NULL WHERE Plaza = @PlazaActual
UPDATE Personal SET Plaza = @Plaza WHERE Personal = @Personal
END
IF @MovTipo = 'RH.B'
BEGIN
UPDATE Plaza SET Personal = @Personal WHERE Plaza = @Plaza
UPDATE Personal SET Plaza = @Plaza WHERE Personal = @Personal
END
END
END ELSE
BEGIN
/*
IF @MovTipo in ('RH.A', 'RH.M', 'RH.B')
BEGIN
SELECT @PlazaEmpresa = Empresa, @PlazaSucursal = Sucursal, @PlazaEstatus = Estatus, @Tipo = ISNULL(Tipo, 'Definitiva'), @VigenciaD = VigenciaD, @VigenciaA = VigenciaA
FROM Plaza WHERE Plaza = @Plaza
IF @PlazaEmpresa <> @Empresa
SELECT @Ok = 10060, @OkRef = 'La Empresa de la Plaza no corresponde. Personal ' + RTRIM(@Personal)
ELSE
IF @PlazaSucursal <> @SucursalTrabajo
SELECT @Ok = 10060, @OkRef = 'La Sucursal de la Plaza no corresponde. Personal ' + RTRIM(@Personal)
ELSE
IF @PlazaEstatus <> 'ALTA'
SELECT @Ok = 10060, @OkRef = 'El Estatus de la Plaza ' + RTRIM(@Plaza) + ' es ' + RTRIM(@PlazaEstatus)
ELSE
IF @Tipo = 'Temporal' AND (@FechaAlta > @VigenciaA OR @FechaAlta < @VigenciaD)
SELECT @Ok = 10060, @OkRef = 'Las Vigencias de la Plaza ' + RTRIM(@Plaza) + ' no corresponde a la Fecha Alta'
END
*/
IF @MovTipo = 'RH.B' AND @SubClave <> 'RH.BRP' 
BEGIN
UPDATE Plaza SET Personal = NULL WHERE Plaza = @Plaza
UPDATE Personal SET Plaza = NULL WHERE Personal = @Personal
END
IF @PlazaPersonal <> @Personal 
BEGIN
/*
IF @MovTipo = 'RH.A'
BEGIN
SELECT @PlazaPuesto = NULLIF(RTRIM(Puesto), ''), @PlazaDepartamento = NULLIF(RTRIM(Departamento), '')
FROM Plaza
WHERE Plaza = @Plaza
IF @PlazaPuesto <> @Puesto OR @PlazaDepartamento <> @Departamento
SELECT @OK = 55420, @OkRef = @PlazaPersonal
END
IF @PlazaPersonal IS NOT NULL AND (SELECT Estatus FROM Personal WHERE Personal = @PlazaPersonal) = 'ALTA'
SELECT @Ok = 55410, @OkRef = @PlazaPersonal
ELSE*/
IF @MovTipo = 'RH.A'
BEGIN
UPDATE Plaza SET Personal = @Personal, TieneMovimientos = 1 WHERE Plaza = @Plaza
UPDATE Personal SET Plaza = @Plaza WHERE Personal = @Personal
END
IF @MovTipo = 'RH.M' AND @Plaza <> (SELECT Plaza FROM Personal WHERE Personal = @Personal)
BEGIN
UPDATE Plaza SET Personal = NULL WHERE Personal = @Personal
UPDATE Plaza SET Personal = @Personal, TieneMovimientos = 1 WHERE Plaza = @Plaza
UPDATE Personal SET Plaza = @Plaza WHERE Personal = @Personal
END
END
END
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona: '+RTRIM(@Personal)
RETURN
END

