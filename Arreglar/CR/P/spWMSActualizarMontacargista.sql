SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSActualizarMontacargista
@Estacion		int,
@Montacargista	varchar(20),
@Empresa		char(5)

AS BEGIN
DECLARE @Tipo		varchar(50),
@ID				int,
@IDLista		int,
@Agente			varchar(20),
@Pendientes		int,
@WMSValidarZona    int,
@ZonaAgente     varchar(30),
@PesoMaximoMontaCarga	float,
@PesoTarimaMovimiento float,
@ValidaPeso     int,
@Tarima			varchar(20),
@ZonaDetalle    varchar(50),
@Mov		    varchar(20),
@MovID		    varchar(20),
@MovTipo        varchar(20),
@Error          int=NULL,
@TipoMov	    varchar(20),
@ErrorRef       varchar(255),
@PosicionDestino	char(10), 
@TarimaValida	varchar(20),
@MovValida	    varchar(20),
@MovIDValida	varchar(20),
@MovTipoValida  varchar(20),
@RenglonValida  float
/***************************************Validación Asignación Acomodador***************************************************************************************************/
/* Validación cuando se seleccionan dos o mas movimientos con la misma tarima y diferente clave de afectación */
/*
SELECT t.Tarima, t.Clave, t.Mov, t.MovID
INTO #WMSMontacargaTreaPCK
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
EXEC spWMSValidaPCK @Estacion, @Error=@Error OUTPUT , @ErrorRef=@ErrorRef OUTPUT
IF @Error IS NULL
BEGIN
SELECT t.Tarima, t.Clave
INTO #WMSMontacargaTrea
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
AND t.Clave IN ('TMA.OPCKTARIMA', 'TMA.OSUR')
GROUP BY t.Tarima, t.Clave
SELECT Tarima, COUNT(Tarima) Cantidad INTO #WMSMontacargaTreaCant FROM #WMSMontacargaTrea GROUP BY Tarima
SELECT TOP 1 @Mov=Mov, @MovID=MovID
FROM #WMSMontacargaTreaCant a
JOIN #WMSMontacargaTrea b ON b.Tarima=a.Tarima
JOIN WMSMontacargaTarea c ON c.Tarima=b.Tarima AND c.Clave=b.Clave AND c.Estacion=@Estacion
WHERE Cantidad>1
ORDER BY b.Tarima, b.Clave DESC
IF NULLIF(@Mov, '') IS NOT NULL AND NULLIF(@MovID, '') IS NOT NULL
BEGIN
SELECT @Error = 20024, @ErrorRef='No es posible asignar acomodador al movimiento '  + @Mov + ' '+ @MovID + '. Existen ordenes previas pendientes.'
END
/* Validación cuando no se seleccionan dos o mas movimientos con la misma tarima y diferente clave de afectación pero si existen en WMSMontacargaTarea */
IF @Error IS NULL
BEGIN
SELECT t.Renglon, t.Tarima, t.Clave, t.Mov, t.MovID
INTO #WMSMontacargaTarValida
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
DECLARE crListaValida CURSOR FOR
SELECT t.Renglon, t.Tarima, t.Clave, t.Mov, t.MovID
FROM #WMSMontacargaTarValida t
ORDER BY t.Tarima
OPEN crListaValida
FETCH NEXT FROM crListaValida INTO @RenglonValida, @TarimaValida, @MovTipoValida, @MovValida, @MovIDValida
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM WMSMontacargaTarea WHERE Estacion=@Estacion AND Tarima=@TarimaValida AND Clave <> @MovTipoValida AND @MovTipoValida <> 'TMA.OPCKTARIMA')
BEGIN
SELECT @Error = 20024, @ErrorRef='No es posible asignar acomodador al movimiento '  + @MovValida + ' '+ @MovIDValida + '. Existen ordenes previas pendientes.'
END
FETCH NEXT FROM crListaValida INTO @RenglonValida, @TarimaValida, @MovTipoValida, @MovValida, @MovIDValida
END
CLOSE crListaValida
DEALLOCATE crListaValida
END
*/
IF @Error IS NULL
BEGIN
/***************************************Validación Asignación Acomodador***************************************************************************************************/
DECLARE crLista CURSOR FOR
SELECT t.ID, t.Tarima, t.Zona, t.Clave, t.PosicionDestino, t.Mov, t.MovID
FROM WMSMontacargaTarea t
JOIN ListaID l ON t.IDLista = l.ID AND t.Estacion = l.Estacion
WHERE t.Estacion = @Estacion
ORDER BY t.Tarima
OPEN crLista
FETCH NEXT FROM crLista INTO @ID, @Tarima, @ZonaDetalle, @MovTipo, @PosicionDestino, @Mov, @MovID
WHILE @@FETCH_STATUS = 0
BEGIN
IF NULLIF(@PosicionDestino,'') IS NULL
SELECT @Error = 20024, @ErrorRef='Es Necesario asignar la posicion destino, ' + @Mov + ' '+ @MovID
IF @Error IS NULL
EXEC spTareaAcomodadorValidaMovimiento @Empresa, @ID, @Tarima, @ZonaDetalle, @Montacargista, @MovTipo, @Error OUTPUT, @ErrorRef OUTPUT
FETCH NEXT FROM crLista INTO @ID, @Tarima, @ZonaDetalle, @MovTipo, @PosicionDestino, @Mov, @MovID
END
CLOSE crLista
DEALLOCATE crLista
SELECT @Tipo = WMSTipoAcomodador FROM EmpresaCfg WHERE Empresa = @Empresa
IF EXISTS(SELECT * FROM Agente WHERE Agente = @Montacargista AND Tipo = @Tipo) AND @Error IS NULL  
UPDATE WMSMontacargaTarea SET Montacarga = @Montacargista WHERE Estacion = @Estacion AND IDLista IN(SELECT ID FROM ListaID WHERE Estacion = @Estacion)
END
IF @Error IS NULL
EXEC spWMSActualizarMontacargaTarea @Estacion
SELECT ISNULL(@ErrorRef,'')
RETURN
END

