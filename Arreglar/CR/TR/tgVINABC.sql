SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgVINABC ON VIN

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@VIN	varchar(20),
@Modelo	varchar(4),
@Hoy	datetime,
@Empresa	varchar(5),
@Km		int,
@Articulo	varchar(20),
@SigKms	int,
@KmsxDia	int,
@Dias	int
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Hoy = GETDATE()
EXEC spExtraerFecha @Hoy OUTPUT
IF EXISTS(SELECT VIN FROM Inserted)
BEGIN
IF UPDATE(Km)
BEGIN
SELECT @VIN = VIN, @Modelo = Modelo, @Empresa = Empresa, @Articulo = Articulo, @Km = Km FROM Inserted
SELECT @KmsxDia = KmsxMes / 30 FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @SigKms = MIN(Kms) FROM ArtKms WHERE Articulo = @Articulo AND Kms>@Km
SELECT @Dias = (@SigKms - @Km) / @KmsxDia
IF ISNULL(@Dias, 0)>=0
UPDATE VIN SET FechaSiguienteServicio = DATEADD(day, @Dias, @Hoy) WHERE VIN = @VIN
END
IF (SELECT ISNULL(Interfase, 0) FROM Inserted) = 0 AND @Articulo IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM VINAccesorio WHERE VIN = @VIN)
IF (SELECT VINAccesorioArt FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1
INSERT VINAccesorio (VIN, Tipo, Accesorio, Descripcion, PrecioDistribuidor, PrecioPublico, PrecioContado, FechaAlta, Estatus)
SELECT @VIN, av.Tipo, av.Accesorio, a.Descripcion1, a.CostoEstandar, a.PrecioLista, a.Precio2, @Hoy, 'ALTA'
FROM ArtVINAccesorio av, Art a
WHERE av.Articulo = @Articulo AND a.Articulo = av.Accesorio
ELSE
INSERT VINAccesorio (VIN, Accesorio, Descripcion, PrecioDistribuidor, PrecioPublico, PrecioContado, FechaAlta, Estatus)
SELECT @VIN, Accesorio, Descripcion, PrecioDistribuidor, PrecioPublico, PrecioContado, @Hoy, 'ALTA'
FROM ArtVINAccesorio
WHERE Articulo = @Articulo AND Modelo = @Modelo
END
END
IF UPDATE(Placas) OR UPDATE(Cliente) OR UPDATE(Conductor) OR UPDATE(Estatus) OR UPDATE(Situacion)
INSERT VINHist (VIN, Fecha, Placas, Cliente, Conductor, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota)
SELECT VIN, GETDATE(), Placas, Cliente, Conductor, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota
FROM Inserted
IF NOT EXISTS(SELECT VIN FROM Inserted) AND EXISTS(SELECT VIN FROM Deleted)
DELETE VINAccesorio WHERE VIN IN (SELECT VIN FROM Deleted)
END

