SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER Procedure dbo.spPlanArtSabanaValidar
@Estacion           INT,
@EstacionFija       INT,
@Nivel              INT

As
BEGIN
DECLARE
@OperadorVenta      VARCHAR(2),
@Venta              FLOAT,
@OperadorExistencia VARCHAR(2),
@Existencia         FLOAT,
@FechaD             DATETIME,
@FechaA             DATETIME,
@SucursalGrupo      VARCHAR(20),
@Proveedor          VARCHAR(20),
@Departamento       VARCHAR(50),
@Seccion            VARCHAR(50),
@Articulo           VARCHAR(20),
@OkRef              VARCHAR(255)
SELECT @OkRef = 'OK'
SELECT @OperadorVenta = OperadorVenta, @Venta = Venta, @OperadorExistencia = OperadorExistencia, @Existencia = Existencia,
@FechaD = FechaD, @FechaA = FechaA, @SucursalGrupo = SucursalGrupo, @Proveedor = Proveedor, @Departamento = Departamento,
@Seccion = Seccion, @Articulo = Articulo
FROM SabanaFiltro
WHERE Estacion = @EstacionFija
IF @Nivel = 1
BEGIN
IF NULLIF(@FechaD, '') IS NULL OR NULLIF(@FechaA, '') IS NULL
SELECT @OkRef = 'Falta especificar la fecha' ELSE
IF NULLIF(@Proveedor, '') IS NULL AND NULLIF(@Articulo, '') IS NULL
SELECT @OkRef = 'Falta especificar el Proveedor' ELSE
IF NULLIF(@Departamento, '') IS NULL AND NULLIF(@Articulo, '') IS NULL
SELECT @OkRef = 'Falta especificar el Departamento' ELSE
IF NULLIF(@SucursalGrupo, '') IS NULL
SELECT @OkRef = 'Falta especificar el Grupo de Sucursales'
END ELSE
IF @Nivel = 2
BEGIN
DELETE FROM SabanaFiltroSucursal WHERE Estacion = @EstacionFija AND Sucursal NOT IN (SELECT Clave FROM ListaSt li WHERE Estacion = @Estacion)
IF NOT EXISTS(SELECT * FROM SabanaFiltroSucursal WHERE Estacion = @EstacionFija)
SELECT @OkRef = 'No hay sucursales seleccionadas'
END
SELECT @OkRef
END

