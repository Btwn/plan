SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSAsignaAcomodador
@Acomodador		varchar(10),
@Estacion		int,
@Tipo			varchar(50),
@Montacarga		varchar(50)

AS
BEGIN
IF @Tipo = 'WMSSurtidoProcesarD'
UPDATE WMSSurtidoProcesarD SET Acomodador = @Acomodador
FROM ListaSt
WHERE ListaSt.Clave = WMSSurtidoProcesarD.Articulo AND ListaSt.Estacion = WMSSurtidoProcesarD.Estacion AND WMSSurtidoProcesarD.Procesado = 0 AND
ListaSt.Estacion = @Estacion
ELSE
IF @Tipo = 'WMSLoteMovimiento'
BEGIN
UPDATE WMSLoteMovimiento
SET Acomodador = @Acomodador,
Montacarga = @Montacarga
FROM ListaSt
WHERE ListaSt.Clave = WMSLoteMovimiento.IDLista
AND ListaSt.Estacion = WMSLoteMovimiento.Estacion
AND ListaSt.Estacion = @Estacion
UPDATE B
SET B.Montacarga = NULLIF(@Montacarga,''),
B.Agente = NULLIF(@Acomodador,'')
FROM WMSLoteMovimiento A
JOIN TMA B
ON A.ID = B.ID
JOIN ListaSt C
ON A.IDLista = C.Clave
AND A.Estacion = C.Estacion
WHERE C.Estacion = @Estacion
UPDATE D
SET D.Montacarga = NULLIF(@Acomodador,'')
FROM WMSLoteMovimiento A
JOIN TMA B
ON A.ID = B.ID
JOIN TMAD D
ON B.ID = D.ID
AND A.Tarima = D.Tarima
JOIN ListaSt C
ON A.IDLista = C.Clave
AND A.Estacion = C.Estacion
WHERE C.Estacion = @Estacion
END
END

