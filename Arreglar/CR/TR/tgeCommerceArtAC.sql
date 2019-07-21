SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceArtAC ON Art

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Articulo            varchar(20),
@Estatus             varchar(10),
@Precio              float ,
@Precio2             float ,
@Precio3             float ,
@Precio4             float ,
@Precio5             float ,
@Precio6             float ,
@Precio7             float ,
@Precio8             float ,
@Precio9             float ,
@Precio10            float ,
@PrecioD             float ,
@PrecioD2            float ,
@PrecioD3            float ,
@PrecioD4            float ,
@PrecioD5            float ,
@PrecioD6            float ,
@PrecioD7            float ,
@PrecioD8            float ,
@PrecioD9            float ,
@PrecioD10           float ,
@Peso				float,
@PesoD				float,
@Ok                  int ,
@ListaPrecios        varchar(20),
@eCommerceEmpresa    bit,
@Empresa		varchar(5),
@ID                  int
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
DECLARE crArt CURSOR FOR
SELECT i.Articulo, i.PrecioLista, i.Precio2, i.Precio3, i.Precio4, i.Precio5, i.Precio6, i.Precio7, i.Precio8, i.Precio9, i.Precio10, i.Peso, d.PrecioLista, d.Precio2, d.Precio3, d.Precio4, d.Precio5, d.Precio6, d.Precio7, d.Precio8, d.Precio9, d.Precio10, d.Peso
FROM Inserted i LEFT JOIN Deleted d ON i.Articulo = d.Articulo
WHERE  (ISNULL(i.PrecioLista,0.0) <> ISNULL(d.PrecioLista,0.0)) OR
(ISNULL(i.Precio2,0.0) <> ISNULL(d.Precio2,0.0)) OR
(ISNULL(i.Precio3,0.0) <> ISNULL(d.Precio3,0.0)) OR
(ISNULL(i.Precio4,0.0) <> ISNULL(d.Precio4,0.0)) OR
(ISNULL(i.Precio5,0.0) <> ISNULL(d.Precio5,0.0)) OR
(ISNULL(i.Precio6,0.0) <> ISNULL(d.Precio6,0.0)) OR
(ISNULL(i.Precio7,0.0) <> ISNULL(d.Precio7,0.0)) OR
(ISNULL(i.Precio8,0.0) <> ISNULL(d.Precio8,0.0)) OR
(ISNULL(i.Precio9,0.0) <> ISNULL(d.Precio9,0.0)) OR
(ISNULL(i.Precio10,0.0) <> ISNULL(d.Precio10,0.0)) OR
(ISNULL(i.Peso,0.0) <> ISNULL(d.Peso,0.0))
OPEN crArt
FETCH NEXT FROM crArt INTO @Articulo, @Precio, @Precio2,    @Precio3,    @Precio4,    @Precio5,    @Precio6,    @Precio7,    @Precio8,    @Precio9,    @Precio10, @Peso, @PrecioD, @PrecioD2,    @PrecioD3,    @PrecioD4,    @PrecioD5,    @PrecioD6,    @PrecioD7,    @PrecioD8,    @PrecioD9,    @PrecioD10, @PesoD
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM WebArt WHERE Articulo = @Articulo AND
(ISNULL(@PrecioD,0.0) <> ISNULL(@Precio,0.0)) OR
(ISNULL(@PrecioD2,0.0) <> ISNULL(@Precio2,0.0)) OR
(ISNULL(@PrecioD3,0.0) <> ISNULL(@Precio3,0.0)) OR
(ISNULL(@PrecioD4,0.0) <> ISNULL(@Precio4,0.0)) OR
(ISNULL(@PrecioD5,0.0) <> ISNULL(@Precio5,0.0)) OR
(ISNULL(@PrecioD6,0.0) <> ISNULL(@Precio6,0.0)) OR
(ISNULL(@PrecioD7,0.0) <> ISNULL(@Precio7,0.0)) OR
(ISNULL(@PrecioD8,0.0) <> ISNULL(@Precio8,0.0)) OR
(ISNULL(@PrecioD9,0.0) <> ISNULL(@Precio9,0.0)) OR
(ISNULL(@PrecioD10,0.0) <> ISNULL(@Precio10,0.0)) OR
(ISNULL(@PesoD,0.0) <> ISNULL(@Peso,0.0))
)
UPDATE WebArt
SET Precio = @Precio, Precio2 = @Precio2, Precio3 = @Precio3, Precio4 = @Precio4, Precio5 = @Precio5, Precio6 = @Precio6, Precio7 = @Precio7, Precio8 = @Precio8, Precio9 = @Precio9, Precio10 = @Precio10, Peso = @Peso
WHERE Articulo = @Articulo
IF @@ERROR <> 0 SET  @Ok  = 0
IF EXISTS(SELECT * FROM WebArtVariacionCombinacion WHERE Articulo = @Articulo AND
(ISNULL(@PrecioD,0.0) <> ISNULL(@Precio,0.0)) OR
(ISNULL(@PrecioD2,0.0) <> ISNULL(@Precio2,0.0)) OR
(ISNULL(@PrecioD3,0.0) <> ISNULL(@Precio3,0.0)) OR
(ISNULL(@PrecioD4,0.0) <> ISNULL(@Precio4,0.0)) OR
(ISNULL(@PrecioD5,0.0) <> ISNULL(@Precio5,0.0)) OR
(ISNULL(@PrecioD6,0.0) <> ISNULL(@Precio6,0.0)) OR
(ISNULL(@PrecioD7,0.0) <> ISNULL(@Precio7,0.0)) OR
(ISNULL(@PrecioD8,0.0) <> ISNULL(@Precio8,0.0)) OR
(ISNULL(@PrecioD9,0.0) <> ISNULL(@Precio9,0.0)) OR
(ISNULL(@PrecioD10,0.0) <> ISNULL(@Precio10,0.0)))
UPDATE WebArtVariacionCombinacion
SET Precio = @Precio, Precio2 = @Precio2, Precio3 = @Precio3, Precio4 = @Precio4, Precio5 = @Precio5, Precio6 = @Precio6, Precio7 = @Precio7, Precio8 = @Precio8, Precio9 = @Precio9, Precio10 = @Precio10
WHERE Articulo = @Articulo
IF @@ERROR <> 0 SET  @Ok  = 0
FETCH NEXT FROM crArt INTO @Articulo, @Precio, @Precio2,    @Precio3,    @Precio4,    @Precio5,    @Precio6,    @Precio7,    @Precio8,    @Precio9,    @Precio10, @Peso, @PrecioD, @PrecioD2,    @PrecioD3,    @PrecioD4,    @PrecioD5,    @PrecioD6,    @PrecioD7,    @PrecioD8,    @PrecioD9,    @PrecioD10, @PesoD
END
CLOSE crArt
DEALLOCATE crArt
END

