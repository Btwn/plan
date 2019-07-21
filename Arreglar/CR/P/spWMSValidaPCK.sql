SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSValidaPCK
@Estacion         int,
@Error				int	 	= NULL	OUTPUT,
@ErrorRef			varchar(255)	= NULL	OUTPUT

AS BEGIN
DECLARE
@TarimaW      varchar(100),
@MovW         varchar(100),
@MovIDW       varchar(100),
@ClaveW       varchar(100)
SELECT a.ID, a.Mov, a.MovID, b.Tarima, c.Clave, a.Estatus
INTO #TMAEx
FROM TMA a
LEFT OUTER JOIN TMAD b ON b.ID=a.ID
JOIN MovTipo c ON c.Modulo='TMA' AND c.Mov=a.Mov AND c.Clave='TMA.OPCKTARIMA'
WHERE a.Estatus='PENDIENTE'
DECLARE crListaValidaPCK CURSOR FOR
SELECT Tarima, Mov, MovID, Clave FROM  #WMSMontacargaTreaPCK
OPEN crListaValidaPCK
FETCH NEXT FROM crListaValidaPCK INTO @TarimaW, @MovW, @MovIDW, @ClaveW
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM #TMAEx WHERE Tarima=@TarimaW) AND @ClaveW = 'TMA.OSUR'
BEGIN
SELECT @Error = 20024, @ErrorRef='No es posible asignar acomodador al movimiento ' + @MovW + ' '+ @MovIDW + '. Existen ordenes previas pendientes.'
END
FETCH NEXT FROM crListaValidaPCK INTO @TarimaW, @MovW, @MovIDW, @ClaveW
END
CLOSE crListaValidaPCK
DEALLOCATE crListaValidaPCK
RETURN
END

