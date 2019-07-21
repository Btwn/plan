SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTareaAcomodadorValidaMovimiento
@Empresa    char(5),
@ID			int,
@Tarima		varchar(20),
@Zona       varchar(50),
@Montacarga	varchar(20),
@MovTipo    varchar(20),
@Error      int=NULL OUTPUT,
@ErrorRef   varchar(255)=NULL OUTPUT

AS
BEGIN
DECLARE @Agente			varchar(20),
@Pendientes		int,
@WMSValidarZona    int,
@ZonaAgente     varchar(30),
@PesoMaximoMontaCarga	float,
@PesoTarimaMovimiento float,
@ValidaPeso     int,
@Mov		    varchar(20),
@TipoMov	    varchar(20),
@Tipo			varchar(50)
SELECT @Tipo = WMSTipoAcomodador, @WMSValidarZona=ISNULL(WMSValidarZona,0) FROM EmpresaCfg WHERE Empresa = @Empresa 
SELECT @Mov = Mov FROM MovTipo WHERE Clave = @MovTipo AND Modulo = 'TMA'
IF @MovTipo IN ('TMA.OADO', 'TMA.SADO', 'TMA.ADO')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.ADO' AND Modulo = 'TMA'
ELSE
IF @MovTipo IN ('TMA.ORADO', 'TMA.SRADO', 'TMA.RADO')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.RADO' AND Modulo = 'TMA'
ELSE
IF @MovTipo IN ('TMA.OSUR', 'TMA.TSUR', 'TMA.SUR')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.SUR' AND Modulo = 'TMA'
IF NOT EXISTS(SELECT *
FROM AgenteZona
WHERE Agente = ISNULL(@Montacarga,Agente)
AND ISNULL(NULLIF(Tipo,''),@TipoMov) IN (@TipoMov,'(Todos)')
AND Zona IN(ISNULL(@Zona,Zona),'(TODAS)','(TODOS)'))
AND @Zona IS NOT NULL
AND @WMSValidarZona=1
AND EXISTS(SELECT * FROM AgenteZona WHERE Agente = ISNULL(@Montacarga,Agente))
BEGIN
SELECT @Error = 20934
SELECT @ErrorRef = ISNULL(Descripcion,'') + '. Agente: ' + RTRIM(LTRIM(@Montacarga))FROM MensajeLista WHERE Mensaje = @Error
END
RETURN
END

