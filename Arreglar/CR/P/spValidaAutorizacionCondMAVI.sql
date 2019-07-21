SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidaAutorizacionCondMAVI
@ID    int,
@Usuario  varchar(10),
@Estacion  int

AS BEGIN
DECLARE @UsuarioCondona     varchar(10),
@PorcentajeCondMoratorioMAVI float,
@PorcentajeReal     float,
@Mov       varchar(20),
@MovId       varchar(20),
@SePasa       char(1),
@ImporteACondonar    money,
@ImporteMoratorio    money
IF (SELECT COUNT(*) FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Estacion = @Estacion AND MoratorioAPagar > 0  AND ImporteACondonar = 0) = ( SELECT COUNT(*) FROM  NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Estacion = @Estacion AND MoratorioAPagar > 0 )
begin
SELECT @SePasa = '3' 
end
ELSE
IF EXISTS(SELECT * FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Estacion = @Estacion AND MoratorioAPagar > 0  AND ImporteACondonar > 0)
BEGIN
SELECT DISTINCT @UsuarioCondona = UsuarioCondona FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Estacion = @Estacion
IF @UsuarioCondona IS NOT NULL
BEGIN
SELECT @PorcentajeCondMoratorioMAVI = PorcentajeCondMoratorioMAVI FROM UsuarioCfg2 WHERE Usuario = @Usuario
SELECT @SePasa = '2'
DECLARE crCond CURSOR FOR
SELECT Mov, MovID, MoratorioAPagar, ImporteACondonar
FROM NegociaMoratoriosMAVI
WHERE IDCobro = @ID AND Estacion = @Estacion AND ImporteACondonar > 0
OPEN crCond
FETCH NEXT FROM crCond INTO @Mov, @MovID, @ImporteMoratorio, @ImporteACondonar
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2
BEGIN    
SELECT @PorcentajeReal = ((@ImporteACondonar)/ @ImporteMoratorio)*100.0
IF @PorcentajeReal > @PorcentajeCondMoratorioMAVI
SELECT @SePasa = '1'
END
FETCH NEXT FROM crCond INTO @Mov, @MovID, @ImporteMoratorio, @ImporteACondonar
END
CLOSE crCond
DEALLOCATE CrCond
END
ELSE
SELECT @SePasa = '4'
END
SELECT @SePasa
RETURN
END  

