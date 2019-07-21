SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSGeneraLoteMovimiento
@Estacion	int,
@Empresa	char(5)

AS BEGIN
DECLARE
@IDLista			int,
@ID					int,
@Clave				varchar(20),
@SubClave			varchar(20),
@Tarima				varchar(20),
@CantidadA			float,
@Renglon			float,
@Ok					int,
@OkRef				varchar(255),
@Mov				varchar(20),
@IDGenerar			int,
@Usuario			varchar(20),
@Agente				varchar(20),
@Montacarga			varchar(20),
@IDGenerar2			int,
@Articulo           varchar(20),
@Almacen            varchar(10),
@SubCuenta          varchar(50),
@PosicionDestino	varchar(20),
@PosicionDestinoO   varchar(20)
BEGIN TRANSACTION
DECLARE crListaSt CURSOR FOR
SELECT DISTINCT IDLista, ID, Clave, SubClave, Tarima, CantidadA, Renglon, Acomodador, Montacarga, Articulo, Almacen, SubCuenta
FROM WMSLoteMovimiento
WHERE IDLista IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @IDLista, @ID, @Clave, @SubClave, @Tarima, @CantidadA, @Renglon, @Agente, @Montacarga, @Articulo, @Almacen, @SubCuenta
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Clave = 'TMA.SADO'
SELECT @Mov = TMAOrdenAcomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Clave = 'TMA.OADO'
SELECT @Mov = TMAAcomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Clave = 'TMA.SRADO'
SELECT @Mov = TMAOrdenReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Clave = 'TMA.ORADO'
SELECT @Mov = TMAReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Clave = 'TMA.OSUR'
IF @SubClave = 'TMA.OSURP'
SELECT @Mov = TMASurtidoTransitoPCK FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
ELSE
SELECT @Mov = TMASurtidoTransito FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Clave = 'TMA.TSUR'
SELECT @Mov = TMASurtido FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Clave = 'TMA.OPCKTARIMA'
SELECT @Mov = TMAPCKTarimaTransito FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF NULLIF(@Agente,'') IS NULL AND @Ok IS NULL
SELECT @Ok = 20930
IF NULLIF(@Montacarga,'') IS NULL AND @Ok IS NULL
SELECT @Ok = 20919
IF NULLIF(@Mov,'') IS NULL AND @Ok IS NULL
SELECT @Ok = 55130
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Agente) AND @Ok IS NULL SET @Ok = 26090
IF NOT EXISTS(SELECT * FROM Montacarga WHERE Montacarga = @Montacarga) AND @Ok IS NULL SELECT @Ok = 20936
IF @Ok IS NULL
BEGIN
UPDATE TMAD SET CantidadA = @CantidadA WHERE ID = @ID AND Tarima = @Tarima AND Renglon = @Renglon
UPDATE TMA
SET Agente		= @Agente,
Montacarga	= @Montacarga
WHERE ID = @ID
UPDATE TMAD
SET CantidadA = @CantidadA
WHERE ID		= @ID
AND Renglon	= @Renglon
AND Tarima	= @Tarima
UPDATE TMAD
SET CantidadA = NULL
WHERE ID		= @ID
AND Renglon	<> @Renglon
AND Tarima	<> @Tarima
END
IF @Clave IN('TMA.SADO', 'TMA.SRADO', 'TMA.OADO', 'TMA.ORADO', 'TMA.ADO', 'TMA.RADO') AND @Ok IS NULL
BEGIN
IF @Clave IN('TMA.SADO', 'TMA.SRADO') AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
EXEC @IDGenerar =  spAfectar 'TMA', @ID, 'GENERAR', 'Seleccion', @Mov, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
SELECT @PosicionDestinoO = ISNULL(PosicionDestino,'')
FROM TMAD
WHERE ID = @IDGenerar
AND Renglon = @Renglon
IF @PosicionDestinoO = ''
BEGIN
SELECT @PosicionDestino = dbo.fnTMAUbicacionDisponible(@Empresa, @Almacen, @Articulo, @IDGenerar, @Tarima, ISNULL(@SubCuenta,''))
UPDATE TMAD
SET PosicionDestino = ISNULL(@PosicionDestino,'')
WHERE ID = @IDGenerar
AND Renglon = @Renglon
END
END
ELSE
SELECT @IDGenerar = @ID
IF @Clave IN('TMA.SADO', 'TMA.SRADO') AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Clave = 'TMA.SADO'
SELECT @Mov = TMAAcomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
ELSE
IF @Clave = 'TMA.SRADO'
SELECT @Mov = TMAReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
UPDATE TMAD
SET CantidadA = @CantidadA
WHERE ID		= @IDGenerar
AND Renglon	= @Renglon
AND Tarima	= @Tarima
IF @Clave IN('TMA.SADO', 'TMA.SRADO', 'TMA.OADO', 'TMA.ORADO') AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC @IDGenerar2 =  spAfectar 'TMA', @IDGenerar, 'GENERAR', 'Seleccion', @Mov, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spAfectar 'TMA', @IDGenerar2, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
END
ELSE
IF @Clave IN('TMA.OSUR', 'TMA.TSUR') AND @Ok IS NULL
BEGIN
IF @Clave IN('TMA.OSUR') AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC @IDGenerar =  spAfectar 'TMA', @ID, 'GENERAR', 'Seleccion', @Mov, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
ELSE
SELECT @IDGenerar = @ID
IF @Clave IN('TMA.OSUR') AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000  AND @SubClave NOT IN('TMA.OSURP')
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Clave = 'TMA.OSUR'
SELECT @Mov = TMASurtido FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
UPDATE TMAD
SET CantidadA = @CantidadA
WHERE ID		= @IDGenerar
AND Renglon	= @Renglon
AND Tarima	= @Tarima
IF @Clave IN('TMA.OSUR', 'TMA.TSUR') AND @SubClave NOT IN('TMA.OSURP') AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC @IDGenerar2 =  spAfectar 'TMA', @IDGenerar, 'GENERAR', 'Seleccion', @Mov, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND @SubClave NOT IN('TMA.OSURP')
EXEC spAfectar 'TMA', @IDGenerar2, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
END
IF @Clave IN ('TMA.OPCKTARIMA')
BEGIN
EXEC @IDGenerar2 = spAfectar 'TMA', @ID, 'GENERAR', 'Seleccion', @Mov, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spAfectar 'TMA', @IDGenerar2, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
SELECT @Clave = Clave FROM MovTipo A JOIN TMA B ON A.Modulo = 'TMA' AND A.Mov = B.Mov WHERE B.ID = @IDGenerar2
IF @Clave = 'TMA.PCKTARIMATRAN'
BEGIN
SELECT @Mov = TmaPCKTarima FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
EXEC @IDGenerar2 = spAfectar 'TMA', @IDGenerar2, 'GENERAR', 'Pendiente', @Mov, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spAfectar 'TMA', @IDGenerar2, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
END
END
END
IF @Ok BETWEEN 80030 AND 81000
SELECT @Ok = NULL
FETCH NEXT FROM crListaSt INTO @IDLista, @ID, @Clave, @SubClave, @Tarima, @CantidadA, @Renglon, @Agente, @Montacarga, @Articulo, @Almacen, @SubCuenta
END
CLOSE crListaSt
DEALLOCATE crListaSt
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
SELECT 'Proceso Terminado'
SELECT @OkRef = NULL
EXEC spWMSPreparaLoteMovimiento @Estacion, @Empresa
COMMIT TRANSACTION
END
ELSE
BEGIN
EXEC spEliminarMov 'TMA', @IDGenerar
SELECT @OkRef = LTRIM(RTRIM(ISNULL(@OkRef, '')))+ ' ' + Descripcion FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok = 20934
SELECT @OkRef + ' ' + @Agente
ELSE
SELECT 'Error - ' + CONVERT(varchar, @Ok) + '<BR><BR>' + @OkRef
ROLLBACK TRANSACTION
END
RETURN
END

