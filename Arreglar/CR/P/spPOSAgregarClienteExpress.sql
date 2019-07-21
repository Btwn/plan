SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAgregarClienteExpress
@Sucursal			int,
@Cliente			varchar(20),
@Nombre			varchar(100),
@Direccion			varchar(100),
@DireccionNumero		varchar(20),
@DireccionNumeroInt	varchar(20),
@EntreCalles		varchar(100),
@Delegacion		varchar(100),
@Colonia			varchar(100),
@Poblacion			varchar(100),
@Estado			varchar(50),
@Pais			varchar(50),
@CodigoPostal		varchar(15),
@RFC			varchar(15),
@CURP			varchar(50),
@Contacto1			varchar(50) = NULL,
@Email1			varchar(50) = NULL,
@ClienteNuevo		bit	    = 0,
@ZonaImpuesto              varchar(50) = NULL,
@FechaNacimiento	        datetime  =   NULL,
@EstadoCivil	        varchar(20)=  NULL,
@Conyuge	                varchar(100)= NULL,
@Sexo	                varchar(20)  =  NULL,
@Profesion	                varchar(100)   = NULL,
@Puesto	                varchar(100)   = NULL,
@NumeroHijos	        int            = NULL,
@Religion	                varchar(50)    = NULL

AS
BEGIN
DECLARE
@Consecutivo		int,
@Host			varchar(20),
@Cluster		varchar(20)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF EXISTS(SELECT 1 FROM Cte WHERE Cliente = @Cliente AND @ClienteNuevo = 0)
UPDATE Cte Set Nombre = @Nombre,
Direccion = @Direccion,
DireccionNumero = @DireccionNumero,
DireccionNumeroInt = @DireccionNumeroInt,
EntreCalles = @EntreCalles,
Delegacion = @Delegacion,
Colonia = @Colonia,
Poblacion = @Poblacion,
Estado = @Estado,
Pais = @Pais,
CodigoPostal = @CodigoPostal,
RFC = @RFC,
CURP = CURP,
Contacto1 = @Contacto1,
Email1 = @Email1,
ZonaImpuesto = @ZonaImpuesto,
FechaNacimiento = @FechaNacimiento,
EstadoCivil	= @EstadoCivil,
Conyuge	= @Conyuge,
Sexo = @Sexo	,
Profesion = @Profesion ,
Puesto = @Puesto,
NumeroHijos	= @NumeroHijos,
Religion = @Religion
WHERE Cliente = @Cliente
ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM ConsecutivoSucursal WHERE Tipo = 'Cte' AND Sucursal = @Sucursal)
INSERT ConsecutivoSucursal(Tipo,  Sucursal, Consecutivo)
SELECT                     'CTE', @Sucursal, 0
SELECT @Consecutivo = ISNULL(Consecutivo,0)
FROM ConsecutivoSucursal cs
WHERE cs.Tipo = 'Cte'
AND cs.Sucursal = @Sucursal
SELECT @Cliente = @Host + CONVERT(varchar, ISNULL(@Consecutivo,0) + 1)
UPDATE ConsecutivoSucursal SET Consecutivo = ISNULL(Consecutivo,0) +1
WHERE Tipo = 'Cte'
AND Sucursal = @Sucursal
IF EXISTS (SELECT 1 FROM Cte WHERE Cliente = @Cliente)
BEGIN
SELECT @Cliente = NULL
END
IF @Cliente IS NOT NULL
INSERT Cte (
Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal,
RFC, CURP, Tipo, Estatus, Contacto1, eMail1, ZonaImpuesto, FechaNacimiento, EstadoCivil, Conyuge, Sexo, Profesion, Puesto,
NumeroHijos, Religion)
VALUES (
@Cliente, @Nombre, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Delegacion, @Colonia, @Poblacion, @Estado, @Pais, @CodigoPostal,
@RFC, @CURP, 'Cliente', 'ALTA', @Contacto1, @Email1, @ZonaImpuesto, @FechaNacimiento, @EstadoCivil, @Conyuge , @Sexo, @Profesion, @Puesto,
@NumeroHijos, @Religion)
END
SELECT @Cliente
END

