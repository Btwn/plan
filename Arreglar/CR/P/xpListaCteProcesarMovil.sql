SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpListaCteProcesarMovil @Empresa char(5),@Estacion int,@Agente varchar(10)
AS BEGIN
DELETE CteProcesarMovil WHERE Estacion = @Estacion
INSERT INTO CteProcesarMovil(Empresa,Estacion,Cliente,Agente,AgenteNombre,
ClienteNombre,EnviarA,Tipo,Direccion,DireccionNumero,
DireccionNumeroInt,Rama,Estatus,Categoria,Familia,
Grupo,Espacio)
SELECT MovilUsuarioCfg.Empresa,@Estacion,Cte.Cliente,Cte.Agente,Agente.Nombre,
Cte.Nombre,ISNULL(Cte.EnviarA,0)As EnviarA,Cte.Tipo,Cte.Direccion,Cte.DireccionNumero,
Cte.DireccionNumeroInt,Cte.Rama,Cte.Estatus,Cte.Categoria,Cte.Familia,
Cte.Grupo,Cte.Espacio
FROM Cte
JOIN MovilUsuarioCfg ON Cte.Agente = MovilUsuarioCfg.Agente
JOIN Agente ON Cte.Agente = Agente.Agente
WHERE MovilUsuarioCfg.Empresa = @Empresa AND Cte.Agente = @Agente AND ISNULL(Cte.EnviarA,0) = 0
UNION
SELECT MovilUsuarioCfg.Empresa,@Estacion,Cte.Cliente,CteEnviarA.Agente,Agente.Nombre,
CteEnviarA.Nombre,CteEnviarA.ID,Cte.Tipo,CteEnviarA.Direccion,CteEnviarA.DireccionNumero,
CteEnviarA.DireccionNumeroInt,Cte.Rama,Cte.Estatus,Cte.Categoria,Cte.Familia,
Cte.Grupo,Cte.Espacio
FROM Cte
JOIN CteEnviarA ON(Cte.Cliente = CteEnviarA.Cliente)
JOIN MovilUsuarioCfg ON CteEnviarA.Agente = MovilUsuarioCfg.Agente
JOIN Agente ON CteEnviarA.Agente = Agente.Agente
WHERE MovilUsuarioCfg.Empresa = @Empresa AND Cte.Agente = @Agente
END

