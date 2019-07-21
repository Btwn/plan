SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCompraCotizacionAutorizarValida (@Estacion	int)
RETURNS INT

AS BEGIN
DECLARE
@Conteo	  int,
@Registros   int,
@RegistrosL  int,
@RegistrosLC int,
@Estatus     int
Declare @Valores Table (row_id int , clave int)
SELECT @Conteo = 1
SELECT @Registros  =  count(*) FROM (select ID from ListaIDRenglon WHERE Estacion = @Estacion  GROUP BY ID) as total
Insert Into @Valores
select ROW_NUMBER() OVER(ORDER BY ID DESC) AS Row , ID from ListaIDRenglon WHERE Estacion = 1 GROUP BY ID
WHILE @Conteo <= @Registros
BEGIN
select @RegistrosL  = count(*) From ListaIDRenglon Where Estacion = @Estacion And ID = (select clave from @Valores where row_id = @Conteo)
select @RegistrosLC = count(*) From CompraConfirmarD Where ID = (select clave from @Valores where row_id = @Conteo)
IF @RegistrosL = @RegistrosLC
SELECT @Estatus = 1, @Conteo =  @Conteo +1
ELSE
begin
SELECT @Estatus = 0
BREAK
end
END
RETURN(@Estatus)
END

