SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSCBGenerar (
@ID     varchar(36)
)
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado  varchar(20),
@Host       varchar(20),
@HostCadena varchar(20),
@Sucursal   int,
@SucCadena  varchar(20),
@Caja       varchar(20),
@IDCaja     int,
@IDCajaCadena varchar(20),
@RID         int,
@RIDCadena   varchar(20)
SELECT @HOST = HOST , @Sucursal = Sucursal, @Caja = CtaDinero, @RID = Orden
FROM POSL WITH(NOLOCK) WHERE ID = @ID
SELECT @IDCaja = RID FROM CtaDinero WITH(NOLOCK) WHERE CtaDinero =@Caja
IF (SELECT LEN(@HOST))>4
SELECT  @HostCadena = REVERSE(SUBSTRING(REVERSE(@Host),1,4))
ELSE
SELECT  @HostCadena =@Host
SELECT @SucCadena =  dbo.fnRellenarConCaracter(CONVERT(varchar,@Sucursal),3,'I','S')
SELECT @IDCajaCadena =  dbo.fnRellenarConCaracter(CONVERT(varchar,@IDCaja),3,'I','C')
SELECT @RIDCadena =  dbo.fnRellenarConCaracter(CONVERT(varchar,@RID),8,'I','K')
SELECT @Resultado = @HostCadena+@IDCajaCadena+@RIDCadena
RETURN (@Resultado)
END

