SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSerieCFDFolio
@Sucursal INT ,
@Empresa CHAR(5) ,
@Modulo CHAR(5) ,
@Mov CHAR(20) ,
@Serie VARCHAR(20) OUTPUT ,
@Ok INT OUTPUT ,
@OkRef VARCHAR(255) OUTPUT

AS
BEGIN
SET NOCOUNT ON
DECLARE
@CFDFolio INT ,
@CFDFolioA INT ,
@CFDSerie VARCHAR(10) ,
@Nivel VARCHAR(10)
SELECT  @CFDFolioA = NULL
SELECT  @CFDFolioA = MIN(FolioA) ,
@Nivel = 'Global'
FROM    CFDFolio WITH ( NOLOCK )
WHERE   Empresa = @Empresa
AND Modulo = @Modulo
AND Mov = @Mov
AND Estatus = 'ALTA'
AND ISNULL(Folio, 0) < ISNULL(FolioA, 0)
AND Nivel = 'Global'
IF NULLIF(@CFDFolioA, 0) IS NULL
SELECT  @CFDFolioA = MIN(FolioA) ,
@Nivel = 'Sucursal'
FROM    CFDFolio WITH ( NOLOCK )
WHERE   Empresa = @Empresa
AND Modulo = @Modulo
AND Mov = @Mov
AND Estatus = 'ALTA'
AND ISNULL(Folio, 0) < ISNULL(FolioA, 0)
AND Nivel = 'Sucursal'
AND Sucursal = @Sucursal
IF NULLIF(@CFDFolioA, 0) IS NULL
SELECT  @Ok = 30013
ELSE
BEGIN
IF @Nivel = 'Global'
SELECT @CFDFolio = Folio, 
@CFDSerie = Serie
FROM CFDFolio WITH(NOLOCK)
WHERE   Empresa = @Empresa
AND Modulo = @Modulo
AND Mov = @Mov
AND Estatus = 'ALTA'
AND FolioA = @CFDFolioA
AND Nivel = 'Global'
ELSE
IF @Nivel = 'Sucursal'
SELECT @CFDFolio = Folio, 
@CFDSerie = Serie
FROM CFDFolio WITH(NOLOCK)
WHERE   Empresa = @Empresa
AND Modulo = @Modulo
AND Mov = @Mov
AND Estatus = 'ALTA'
AND FolioA = @CFDFolioA
AND Nivel = 'Sucursal'
AND Sucursal = @Sucursal
IF @CFDFolio > @CFDFolioA
SELECT  @Ok = 30013
ELSE
SELECT  @Serie = ISNULL(@CFDSerie, '')
END
IF ISNULL(@Serie,'') = ''
SELECT @Serie = Prefijo FROM Sucursal WHERE Sucursal = @Sucursal
END

