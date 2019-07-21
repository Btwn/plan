SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsociarMonedero
@Empresa        varchar(5),
@Sucursal       int,
@ID             int,
@Monedero		varchar(20)

AS
BEGIN
IF NOT EXISTS(SELECT * FROM TarjetaSerieMov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID AND Serie = @Monedero AND Sucursal = @Sucursal)
INSERT TarjetaSerieMov(
Empresa,Modulo,ID,Serie,Sucursal)
SELECT
@Empresa,'VTAS',@ID,@Monedero,@Sucursal
RETURN
END

