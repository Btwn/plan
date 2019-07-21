SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCambiarCtaSituacion
@Rama		char(5),
@Cuenta		char(20),
@Situacion		char(50),
@SituacionFecha	datetime,
@SituacionUsuario	varchar(10) = NULL,
@SituacionNota	varchar(100) = NULL,
@Empresa		varchar(5) = NULL,
@Usuario		varchar(10) = NULL

AS BEGIN
DECLARE
@SituacionesPorArea	bit,
@Area		varchar(50)
SELECT @Situacion = NULLIF(RTRIM(@Situacion), '')
SELECT @SituacionesPorArea = SituacionesPorArea FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Area = SituacionArea FROM Usuario WHERE Usuario = @Usuario
BEGIN TRANSACTION
IF (ISNULL(@SituacionesPorArea, 0) = 1) AND (ISNULL(UPPER(@Area), '') <> '(GENERAL)')
BEGIN
UPDATE SituacionCta
SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota
WHERE Rama = @Rama AND Cuenta = @Cuenta AND Area = @Area
IF @@ROWCOUNT = 0
INSERT SituacionCta (
Rama, Cuenta, Area, Situacion, SituacionFecha, SituacionUsuario, SituacionNota)
VALUES (@Rama, @Cuenta, @Area, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota)
END ELSE
BEGIN
IF @Rama = 'INV'  UPDATE Art       SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Articulo     = @Cuenta ELSE
IF @Rama = 'CXC'  UPDATE Cte       SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Cliente      = @Cuenta ELSE
IF @Rama = 'CXP'  UPDATE Prov      SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Proveedor    = @Cuenta ELSE
IF @Rama = 'RH'   UPDATE Personal  SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Personal     = @Cuenta ELSE
IF @Rama = 'PROY' UPDATE Proy      SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Proyecto     = @Cuenta ELSE
IF @Rama = 'ESP'  UPDATE Espacio   SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Espacio      = @Cuenta ELSE
IF @Rama = 'AUTO' UPDATE VIN       SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE VIN          = @Cuenta ELSE
IF @Rama = 'REP'  UPDATE Rep       SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Reporte      = @Cuenta ELSE
IF @Rama = 'AC'   UPDATE LC        SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE LineaCredito = @Cuenta ELSE
IF @Rama = 'ARO'  UPDATE aroRiesgo SET Situacion = @Situacion, SituacionFecha = @SituacionFecha, SituacionUsuario = @SituacionUsuario, SituacionNota = @SituacionNota WHERE Riesgo       = @Cuenta
END
COMMIT TRANSACTION
RETURN
END

