SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSActualizarCxcAnticipoAplicar
@Estacion       int,
@IDPOS          varchar(50)

AS
BEGIN
UPDATE POSCxcAnticipoTemp SET AnticipoAplicar = a.AnticipoAplicar
FROM CxcAnticipoPendienteTemp a JOIN POSCxcAnticipoTemp c ON a.ID = c.ID  AND a.Estacion = c.Estacion
WHERE a.Estacion = @Estacion AND ISNULL(a.AnticipoAplicar,0.0) > 0.0
UPDATE POSCxcAnticipoTemp SET AnticipoAplicar = a.AnticipoAplicar
FROM CxcAnticipoPendienteTemp2 a JOIN POSCxcAnticipoTemp c ON a.ID = c.ID  AND a.Estacion = c.Estacion
WHERE a.Estacion = @Estacion AND ISNULL(a.AnticipoAplicar,0.0) > 0.0
EXEC spPOSAplicarAnticiposTipoServicio @Estacion, @IDPOS
END

