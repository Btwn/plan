SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgInforArtCostoABC ON ArtCosto

FOR  UPDATE
AS BEGIN
DECLARE
@ProdInterfazINFOR					bit,
@Articulo							varchar (20),
@Estatus							    varchar (10),
@Datos								varchar (max),
@UltimoCostoD						float,
@CostoPromedioD						float,
@CostoEstandarD						float,
@UltimoCostoI						float,
@CostoPromedioI 						float,
@CostoEstandarI 						float,
@ID									int,
@ReferenciaIntelisisService			varchar(50)	,
@Empresa								varchar(20)
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @Articulo = Articulo FROM Inserted
SELECT  @Estatus = 'CAMBIO'
SELECT  @UltimoCostoI = UltimoCosto,
@CostoPromedioI = CostoPromedio,
@CostoEstandarI = CostoEstandar
FROM  Inserted
SELECT  @UltimoCostoD = UltimoCosto,
@CostoPromedioD = CostoPromedio ,
@CostoEstandarD = CostoEstandar
FROM Deleted
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WHERE Empresa = @Empresa
IF @ProdInterfazINFOR = 1
BEGIN
IF ISNULL(@UltimoCostoI,0) <> ISNULL(@UltimoCostoD,0) OR ISNULL(@CostoPromedioI,0) <> ISNULL(@CostoPromedioD,0) OR ISNULL(@CostoEstandarI,0) <> ISNULL(@CostoEstandarD,0)
BEGIN
EXEC spInforGenerarSolicitudArticulo  @Articulo,@Estatus,@ReferenciaIntelisisService,@Datos OUTPUT
END
END
END

