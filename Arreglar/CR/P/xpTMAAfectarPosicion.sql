SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpTMAAfectarPosicion
@ID                	int,
@Accion				char(20),
@Base				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20)	OUTPUT,
@MovTipo     		char(20),
@Usuario	      	char(10),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@Almacen			char(10),
@Agente				varchar(10),
@Tarima				varchar(20),
@Posicion			varchar(10),
@PosicionDestino	varchar(10),
@Articiulo			varchar(20),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT
AS BEGIN
DECLARE
@Tipo								varchar(20),
@TipoDestino						varchar(20),
@WMSPermitirReacomodosDomicilio		bit
SELECT @WMSPermitirReacomodosDomicilio = ISNULL(WMSPermitirReacomodosDomicilio,0) FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Tipo = Tipo FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
SELECT @TipoDestino = Tipo FROM AlmPos WHERE Posicion = @PosicionDestino AND Almacen = @Almacen
IF @Tipo = 'Domicilio' AND @TipoDestino = 'Domicilio' AND @WMSPermitirReacomodosDomicilio = 1
BEGIN
UPDATE AlmPos SET ArticuloEsp = '' WHERE Posicion = @Posicion AND Almacen = @Almacen
UPDATE AlmPos SET ArticuloEsp = @Articiulo WHERE Posicion = @PosicionDestino AND Almacen = @Almacen
UPDATE TMAD SET TMAD.PosicionDestino = @PosicionDestino
FROM TMAD JOIN TMA ON TMAD.ID = TMA.ID
JOIN MovTipo
ON TMA.Mov = MovTipo.Mov AND MovTipo.Modulo = 'TMA'
WHERE TMA.Estatus = 'PENDIENTE'
AND TMAD.PosicionDestino = @Posicion
AND MovTipo.Clave IN('TMA.SADO', 'TMA.SRADO')
UPDATE TMAD SET TMAD.Posicion = @PosicionDestino
FROM TMAD JOIN TMA ON TMAD.ID = TMA.ID
JOIN MovTipo
ON TMA.Mov = MovTipo.Mov AND MovTipo.Modulo = 'TMA'
WHERE TMA.Estatus = 'PENDIENTE'
AND TMAD.Posicion = @Posicion
AND MovTipo.Clave = 'TMA.OSUR'
AND MovTipo.SubClave = 'TMA.OSURP'
END
END

