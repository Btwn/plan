SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerPlanArtConteo
@Categoria	    	varchar(50),
@Grupo		    	varchar(50),
@Familia	    	varchar(50),
@Fabricante	    	varchar(50),
@Linea		    	varchar(50),
@Temporada	    	varchar(50),
@ProveedorEspecifico 	char(10),
@Referencia		varchar(50),
@ReferenciaModulo	varchar(5),
@ReferenciaActividad	varchar(50)

AS BEGIN
DECLARE	@CantidadProyecto	int
SELECT @Categoria	        = NULLIF(NULLIF(RTRIM(@Categoria), '(Todos)'), ''),
@Grupo		= NULLIF(NULLIF(RTRIM(@Grupo), '(Todos)'), ''),
@Familia	        = NULLIF(NULLIF(RTRIM(@Familia), '(Todos)'), ''),
@Fabricante	        = NULLIF(NULLIF(RTRIM(@Fabricante), '(Todos)'), ''),
@Linea		= NULLIF(NULLIF(RTRIM(@Linea), '(Todos)'), ''),
@Temporada	        = NULLIF(NULLIF(RTRIM(@Temporada), '(Todos)'), ''),
@ProveedorEspecifico = NULLIF(NULLIF(RTRIM(@ProveedorEspecifico), '(TODOS)'), ''),
@Referencia	        = NULLIF(NULLIF(NULLIF(RTRIM(@Referencia), '(Todos)'), ''), '0'),
@ReferenciaModulo    = NULLIF(NULLIF(NULLIF(RTRIM(@ReferenciaModulo), '(Todos)'), ''), '0'),
@ReferenciaActividad = NULLIF(NULLIF(NULLIF(RTRIM(@ReferenciaActividad), '(Todos)'), ''), '0')
IF @Referencia IS NOT NULL
BEGIN
IF @ReferenciaModulo = 'VTAS'
SELECT COUNT(*) FROM VentaD d, Venta e WHERE d.ID = e.ID AND RTRIM(e.Mov)+' '+RTRIM(e.MovID) = @Referencia AND Estatus = 'PENDIENTE'
ELSE
IF @ReferenciaModulo = 'INV'
SELECT COUNT(*) FROM InvD d, Inv e WHERE d.ID = e.ID AND RTRIM(e.Mov)+' '+RTRIM(e.MovID) = @Referencia AND Estatus = 'PENDIENTE'
ELSE
IF @ReferenciaModulo = 'PROY' 
BEGIN
SELECT @CantidadProyecto = COUNT(*) FROM InvD d, Inv e WHERE d.ID = e.ID AND e.Proyecto = @Referencia AND ISNULL(e.Actividad,'') = ISNULL(@ReferenciaActividad,ISNULL(e.Actividad,'')) AND Estatus = 'PENDIENTE'
SELECT @CantidadProyecto = @CantidadProyecto + COUNT(*) FROM VentaD d, Venta e WHERE d.ID = e.ID AND e.Proyecto = @Referencia AND Estatus = 'PENDIENTE'
SELECT @CantidadProyecto
END
END ELSE
SELECT COUNT(*)
FROM Art a
WHERE ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
RETURN
END

