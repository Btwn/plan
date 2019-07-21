SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSSugerirMontacargaTarea
@Estacion			int,
@Empresa			char(5),
@PorZona			bit,
@AsignarPrioridad	char(5) 

AS BEGIN
DECLARE
@Movimientos	int,
@Agentes		int,
@Numero			int,
@Agente			varchar(20),
@Pendientes		int,
@Tipo			varchar(50),
@Zona			varchar(50),
@ID				int,
@IDLista		int,
@WMSValidarZona			int,
@ZonaAgente				varchar(30),
@PesoMaximoMontaCarga	float,
@PesoTarimaMovimiento	float,
@ValidaPeso				int,
@Tarima					varchar(20),
@ZonaDetalle			varchar(50),
@Mov					varchar(20),
@MovTipo				varchar(20),
@Error					int=NULL,
@ErrorRef				varchar(255)=NULL,
@TipoMov				varchar(20),
@Renglon				float,
@Montacargista			varchar(20),
@Sucursal				int,
@Articulo				varchar(20)
DECLARE @AgenteCantidad TABLE (Agente varchar(20), Cantidad int)
DECLARE @ZonaCantidadAgentes TABLE (Zona varchar(30), Cantidad int)
DECLARE @ZonaMovimientos TABLE (Zona varchar(30), Movimientos int)
DECLARE @AgenteAsignado TABLE (Agente varchar(20), Zona varchar(30), Clave varchar(20),Orden int IDENTITY(1,1))
DECLARE @AgentesZona TABLE (Agente varchar(20), Zona varchar(30), Orden int IDENTITY(1,1))
IF NOT EXISTS(SELECT * FROM ListaID WHERE Estacion=@Estacion)
BEGIN
SELECT 'Favor de Seleccionar un Movimiento'
RETURN
END
SELECT @Tipo = WMSTipoAcomodador,
@WMSValidarZona=ISNULL(WMSValidarZona,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @PorZona = 0
BEGIN
DECLARE crLista CURSOR FOR
SELECT ID
FROM ListaID
WHERE Estacion = @Estacion
OPEN crLista
FETCH NEXT FROM crLista INTO @IDLista
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Error=NULL
SET @Montacargista = NULL
SELECT @ID	    = ID,
@Renglon	= Renglon,
@Tarima  = Tarima,
@ZonaDetalle = Zona,
@MovTipo = Clave,
@Sucursal = Sucursal
FROM WMSMontacargaTarea
WHERE IDLista = @IDLista
SELECT @Mov = Mov FROM MovTipo WHERE Clave = @MovTipo AND Modulo = 'TMA'
IF @MovTipo IN ('TMA.OADO', 'TMA.SADO', 'TMA.ADO')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.ADO' AND Modulo = 'TMA'
ELSE
IF @MovTipo IN ('TMA.ORADO', 'TMA.SRADO', 'TMA.RADO')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.RADO' AND Modulo = 'TMA'
ELSE
IF @MovTipo IN ('TMA.OSUR', 'TMA.TSUR', 'TMA.SUR')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.SUR' AND Modulo = 'TMA'
DELETE FROM @AgentesZona
INSERT @AgentesZona(Agente, Zona)
SELECT A.Agente, B.Zona
FROM Agente A
LEFT JOIN AgenteZona B
ON A.Agente = B.Agente
WHERE A.SucursalEmpresa= @Sucursal
AND B.Zona = @ZonaDetalle
AND B.Tipo IN ('Acomodo','(Todos)')
AND A.Estatus = 'ALTA'
AND A.Tipo = @Tipo
ORDER BY B.Zona DESC, A.Agente ASC
IF @Montacargista IS NULL
BEGIN
SELECT TOP 1 @Montacargista = Montacarga
FROM WMSMontacargaTarea A
JOIN @AgentesZona B
ON A.Montacarga = B.Agente
WHERE Sucursal = @Sucursal
AND A.Zona = @ZonaDetalle
AND A.IDLista < @IDLista
AND A.IDlISTA IN (SELECT ID FROM ListaID)
ORDER BY A.IDLista DESC
END
IF @Montacargista IS NOT NULL
BEGIN
IF EXISTS(SELECT TOP 1 A.Agente
FROM @AgentesZona A
JOIN @AgentesZona B
ON B.Agente = @Montacargista
AND A.Orden > B.Orden)
BEGIN
SELECT TOP 1 @Montacargista = A.Agente
FROM @AgentesZona A
JOIN @AgentesZona B
ON B.Agente = @Montacargista
AND A.Orden > B.Orden
ORDER BY A.Orden ASC
END
ELSE
SET @Montacargista = NULL
END
IF @Montacargista IS NULL
BEGIN
SELECT TOP 1 @Montacargista = Agente
FROM @AgentesZona
ORDER BY Orden ASC
END
IF @WMSValidarZona=1
EXEC spTareaAcomodadorValidaMovimiento @Empresa, @ID, @Tarima, @ZonaDetalle, @Montacargista, @MovTipo, @Error OUTPUT, @ErrorRef OUTPUT
IF @Error IS NULL
BEGIN
UPDATE WMSMontacargaTarea SET Montacarga = @Montacargista, Modificar = 1
WHERE IDLista=@IDLista
END
FETCH NEXT FROM crLista INTO @IDLista
END
CLOSE crLista
DEALLOCATE crLista
END 
IF @PorZona = 1
BEGIN
UPDATE WMSMontacargaTarea SET Montacarga = NULL
WHERE IDLista IN (SELECT ID FROM ListaID)
DECLARE crLista CURSOR FOR
SELECT t.ID,t.Renglon,t.Tarima,t.Zona,t.Clave,t.Sucursal, t.Articulo
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
ORDER BY t.Tarima
OPEN crLista
FETCH NEXT FROM crLista INTO @ID, @Renglon, @Tarima, @ZonaDetalle, @MovTipo, @Sucursal, @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Error = NULL
SET @Montacargista = NULL
SET @IDLista = NULL
DELETE FROM @AgentesZona
INSERT @AgentesZona(Agente, Zona)
SELECT A.Agente, B.Zona
FROM Agente A
JOIN AgenteZona B
ON A.Agente = B.Agente
JOIN ArtZona C
ON B.Zona = C.Zona
AND C.Articulo = @Articulo
WHERE A.Estatus = 'ALTA'
AND B.Tipo IN ('Acomodo','(Todos)')
AND A.Tipo = @Tipo
AND A.SucursalEmpresa = @Sucursal
AND C.Zona = ISNULL(@ZonaDetalle,C.Zona)
ORDER BY C.Orden ASC
INSERT @AgentesZona(Agente, Zona)
SELECT A.Agente, B.Zona
FROM Agente A
LEFT JOIN AgenteZona B
ON A.Agente = B.Agente
WHERE A.Estatus = 'ALTA'
AND A.Tipo = @Tipo
AND A.SucursalEmpresa = @Sucursal
AND B.Zona IS NULL
EXCEPT
SELECT Agente, Zona
FROM @AgentesZona
SELECT TOP 1 @IDLista = A.IDLista , @Montacargista = Montacarga
FROM WMSMontacargaTarea A
JOIN @AgentesZona B
ON A.Montacarga = B.Agente
WHERE Sucursal = @Sucursal
AND A.Zona = @ZonaDetalle
AND A.IDLista NOT IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
ORDER BY IDLista DESC
SELECT TOP 1 @IDLista = A.IDLista , @Montacargista = Montacarga
FROM WMSMontacargaTarea A
JOIN @AgentesZona B
ON A.Montacarga = B.Agente
WHERE Sucursal = @Sucursal
AND A.Zona = @ZonaDetalle
AND A.IDLista IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
AND A.IDLista < (SELECT IDLista
FROM WMSMontacargaTarea
WHERE ID       = @ID
AND Renglon  = @Renglon
AND Tarima   = @Tarima
AND Estacion = @Estacion)
ORDER BY IDLista DESC
IF @Montacargista IS NULL
BEGIN
SELECT TOP 1 @IDLista = A.IDLista , @Montacargista = Montacarga
FROM WMSMontacargaTarea A
JOIN @AgentesZona B
ON A.Montacarga = B.Agente
WHERE Sucursal = @Sucursal
AND A.Zona <> @ZonaDetalle
AND B.Zona IS NOT NULL
AND A.Estacion = @Estacion
AND A.IDLista NOT IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
ORDER BY IDLista DESC
END
IF @Montacargista IS NULL
BEGIN
SELECT TOP 1 @Montacargista = Agente
FROM @AgentesZona
ORDER BY Orden ASC
END
IF @IDLista	IS NOT NULL
BEGIN
IF EXISTS(SELECT TOP 1 A.Agente
FROM @AgentesZona A
JOIN @AgentesZona B
ON B.Agente = @Montacargista
AND A.Orden > B.Orden)
BEGIN
SELECT TOP 1 @Montacargista = NULLIF(A.Agente,'')
FROM @AgentesZona A
JOIN @AgentesZona B
ON B.Agente = @Montacargista
AND A.Orden > B.Orden
ORDER BY A.Orden ASC
END
ELSE
SET @Montacargista = NULL
END
IF @Montacargista IS NULL
BEGIN
SELECT TOP 1 @Montacargista = Agente
FROM @AgentesZona
ORDER BY Orden ASC
END
IF @WMSValidarZona=1
EXEC spTareaAcomodadorValidaMovimiento @Empresa, @ID, @Tarima, @ZonaDetalle, @Montacargista, @MovTipo, @Error OUTPUT, @ErrorRef OUTPUT
IF @Error IS NULL
UPDATE WMSMontacargaTarea SET Montacarga = @Montacargista, Modificar = 1
WHERE ID=@ID AND Renglon = @Renglon AND ISNULL(PosicionDestino,'') <> ''
FETCH NEXT FROM crLista INTO @ID, @Renglon, @Tarima, @ZonaDetalle, @MovTipo, @Sucursal, @Articulo
END
CLOSE crLista
DEALLOCATE crLista
END
IF @AsignarPrioridad='Si'
BEGIN
UPDATE WMSMontacargaTarea
SET Prioridad = 'Normal'
WHERE Estacion = @Estacion
UPDATE WMSMontacargaTarea
SET Prioridad = 'Alta'
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
END
IF @AsignarPrioridad='No'
BEGIN
UPDATE WMSMontacargaTarea
SET Prioridad = 'Normal'
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
END
EXEC spWMSActualizarMontacargaTarea @Estacion 
RETURN
END

