SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAlmPosDomicilios ON AlmPos
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @ArticuloEspI		varchar(20),
@ArticuloEspD		varchar(20),
@Almacen			varchar(10),
@Posicion			varchar(10),
@Ok				int,
@OkRef			varchar(255),
@Tarima			varchar(20),
@Sucursal			int,
@Empresa			varchar(5),
@FechaEmision		datetime,
@Moneda			varchar(10),
@CambioDomicilios	bit,
@TipoI            varchar(10)
IF UPDATE(ArticuloEsp)
BEGIN
SELECT @ArticuloEspI = ISNULL(ArticuloEsp, ''), @Almacen = Almacen, @Posicion = Posicion, @CambioDomicilios = CambioDomicilios, @TipoI=Tipo FROM Inserted 
SELECT @ArticuloEspD = ISNULL(ArticuloEsp, '') FROM Deleted
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
IF NOT EXISTS(SELECT * FROM EmpresaGral WHERE ISNULL(WMS,0)=1) RETURN
SELECT @Empresa = Empresa FROM EmpresaGral WHERE ISNULL(WMS,0)=1
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @CambioDomicilios IS NULL AND @ArticuloEspI <> @ArticuloEspD
BEGIN
IF EXISTS(SELECT *
FROM ArtDisponibleTarima
JOIN Tarima ON ArtDisponibleTarima.Tarima = Tarima.Tarima AND ArtDisponibleTarima.Almacen = Tarima.Almacen
JOIN AlmPos ON Tarima.Posicion = AlmPos.Posicion AND Tarima.Almacen = AlmPos.Almacen
WHERE AlmPos.Almacen = @Almacen
AND AlmPos.Posicion = @Posicion
AND Tipo = 'Domicilio'
AND Disponible > 0
)
BEGIN
RAISERROR ('Existen Tarimas con Existencia para esta Posición.', 16, 1)
RETURN
END
IF EXISTS(SELECT *
FROM ArtDisponibleTarima
JOIN Tarima ON ArtDisponibleTarima.Tarima = Tarima.Tarima AND ArtDisponibleTarima.Almacen = Tarima.Almacen
JOIN AlmPos ON Tarima.Posicion = AlmPos.Posicion AND Tarima.Almacen = AlmPos.Almacen
WHERE AlmPos.Almacen = @Almacen
AND AlmPos.Tipo = 'Domicilio'
AND AlmPos.ArticuloEsp = @ArticuloEspI
AND AlmPos.Posicion <> @Posicion
) AND @CambioDomicilios IS NULL AND @TipoI<>'Ubicacion' 
BEGIN
RAISERROR ('Ya existe otro Domicilio para este Articulo.', 16, 1)
RETURN
END
/*
IF NOT EXISTS(SELECT *
FROM ArtDisponibleTarima
JOIN Tarima ON ArtDisponibleTarima.Tarima = Tarima.Tarima AND ArtDisponibleTarima.Almacen = Tarima.Almacen
JOIN AlmPos ON Tarima.Posicion = AlmPos.Posicion AND Tarima.Almacen = AlmPos.Almacen
WHERE AlmPos.Almacen = @Almacen
AND AlmPos.Posicion = @Posicion
AND Tipo = 'Domicilio'
AND Disponible > 0
)
BEGIN
UPDATE Tarima
SET Posicion = NULL,
Estatus  = 'BAJA',
Alta     = NULL,
Baja     = GETDATE()
WHERE Posicion = @Posicion
AND Almacen  = @Almacen
END
*/
IF NULLIF(RTRIM(@ArticuloEspI), '') IS NOT NULL AND @TipoI='Domicilio' 
BEGIN
IF NOT EXISTS(SELECT *
FROM ArtDisponibleTarima
JOIN Tarima ON ArtDisponibleTarima.Tarima = Tarima.Tarima AND ArtDisponibleTarima.Almacen = Tarima.Almacen
JOIN AlmPos ON Tarima.Posicion = AlmPos.Posicion AND Tarima.Almacen = AlmPos.Almacen
WHERE AlmPos.Almacen = @Almacen
AND AlmPos.Posicion = @Posicion
AND Tipo = 'Domicilio'
)
BEGIN
SELECT @Ok = NULL, @OkRef = NULL, @Tarima = NULL
EXEC spConsecutivo 'Tarima', @Sucursal, @Tarima OUTPUT
IF @Tarima IS NULL
BEGIN
RAISERROR ('Falta configurar Consecutivos Generales para el Tipo: Tarima.', 16, 1)
RETURN
END
EXEC spTarimaAlta @Empresa, @Sucursal, '', @Almacen, @FechaEmision, @FechaEmision, @Tarima, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE Tarima SET Posicion = @Posicion, Articulo=@ArticuloEspI WHERE Tarima = @Tarima 
IF EXISTS(SELECT * FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Empresa = @Empresa AND Articulo <> @ArticuloEspI)
RAISERROR ('Ya existe otro Articulo para esta Nueva Tarima.', 16, 1)
IF NOT EXISTS(SELECT Grupo FROM SaldoUWMS WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Grupo = @Almacen AND Cuenta = @ArticuloEspI AND SubCuenta = '' AND Rama = 'INV' AND Moneda = @Moneda AND SubGrupo = @Tarima)
INSERT INTO SaldoUWMS(
Sucursal,  Empresa, Rama,   Moneda,  Grupo,    SubGrupo,  Cuenta,       SubCuenta, Saldo, SaldoU, PorConciliar, PorConciliarU, UltimoCambio)
SELECT @Sucursal, @Empresa, 'INV', @Moneda, @Almacen, @Tarima,   @ArticuloEspI, '',        0,     0,      0,            0,             GETDATE()
END
END
END
/* Es diferente Almacen pero es el mismo articulo y la misma clave de la posición */
IF @CambioDomicilios IS NULL AND @ArticuloEspI = @ArticuloEspD
BEGIN
IF NULLIF(RTRIM(@ArticuloEspI), '') IS NOT NULL AND @TipoI='Domicilio'
BEGIN
IF NOT EXISTS(SELECT *
FROM ArtDisponibleTarima
JOIN Tarima ON ArtDisponibleTarima.Tarima = Tarima.Tarima AND ArtDisponibleTarima.Almacen = Tarima.Almacen
JOIN AlmPos ON Tarima.Posicion = AlmPos.Posicion AND Tarima.Almacen = AlmPos.Almacen
WHERE AlmPos.Almacen = @Almacen
AND AlmPos.Posicion = @Posicion
AND Tipo = 'Domicilio'
)
BEGIN
SELECT @Ok = NULL, @OkRef = NULL, @Tarima = NULL
EXEC spConsecutivo 'Tarima', @Sucursal, @Tarima OUTPUT
IF @Tarima IS NULL
BEGIN
RAISERROR ('Falta configurar Consecutivos Generales para el Tipo: Tarima.', 16, 1)
RETURN
END
EXEC spTarimaAlta @Empresa, @Sucursal, '', @Almacen, @FechaEmision, @FechaEmision, @Tarima, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE Tarima SET Posicion = @Posicion, Articulo=@ArticuloEspI WHERE Tarima = @Tarima
IF EXISTS(SELECT * FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Empresa = @Empresa AND Articulo = @ArticuloEspI)
RAISERROR ('Ya existe otro Articulo para esta Nueva Tarima.', 16, 1)
IF NOT EXISTS(SELECT Grupo FROM SaldoUWMS WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Grupo = @Almacen AND Cuenta = @ArticuloEspI AND SubCuenta = '' AND Rama = 'INV' AND Moneda = @Moneda AND SubGrupo = @Tarima)
INSERT INTO SaldoUWMS(
Sucursal,  Empresa, Rama,   Moneda,  Grupo,    SubGrupo,  Cuenta,       SubCuenta, Saldo, SaldoU, PorConciliar, PorConciliarU, UltimoCambio)
SELECT @Sucursal, @Empresa, 'INV', @Moneda, @Almacen, @Tarima,   @ArticuloEspI, '',        0,     0,      0,            0,             GETDATE()
END
END
END
END
END

