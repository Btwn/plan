SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spHistSugerir]
@Modulo varchar(5) = NULL,
@Database varchar(255) = NULL,
@Filegroup varchar(255) = NULL,
@FileName varchar(255) = NULL,
@Especial varchar(20) = NULL,
@EnSilencio bit = 0
AS
BEGIN
DECLARE
@ModuloIsNotNull bit,
@MovTabla varchar(50),
@Tabla varchar(100),
@hTabla varchar(100),
@gTabla varchar(100),
@Campo varchar(255),
@Top int,
@ErrorInsertar int,
@ErrorEliminar int,
@RutaArchivoBD varchar(255),
@Resultado varchar(max)
SELECT @ErrorInsertar = 61010,
@ErrorEliminar = 61020,
@Top = 1000000
SELECT @Modulo = NULLIF(RTRIM(UPPER(@Modulo)), '')
IF @Modulo IS NOT NULL SELECT @ModuloIsNotNull = 1 ELSE SELECT @ModuloIsNotNull = 0
IF EXISTS(SELECT * FROM sysobjects WHERE ID = object_id('HistResultado') AND SYSSTAT & 0xf = 3)

DROP TABLE HistResultado
CREATE TABLE HistResultado (
	[ID] INT NOT NULL IDENTITY (1, 1) PRIMARY KEY
   ,[SQL] VARCHAR(8000) NULL
   ,[FechaHora] DATETIME NULL DEFAULT GETDATE()
)
EXEC spALTER_TABLE 'HistResultado'
				  ,'Ejecutable'
				  ,'bit default 0'
IF EXISTS(SELECT * FROM sysobjects where id = object_id('HistCampo') and sysstat & 0xf = 3)
DROP TABLE HistCampo
CREATE TABLE HistCampo (
	Tabla VARCHAR(100) NOT NULL
   ,Campo VARCHAR(100) NOT NULL
   ,ConDatos BIT NULL DEFAULT 0
   ,CONSTRAINT priHistCampo PRIMARY KEY CLUSTERED (Tabla, Campo)
)

IF @FileName IS NULL
BEGIN
	SELECT @RutaArchivoBD = physical_name
	FROM sys.database_files
	WHERE type_desc = 'ROWS'
	ORDER BY data_space_id ASC
	SELECT @RutaArchivoBD = REVERSE(@RutaArchivoBD)
	SELECT @RutaArchivoBD = SUBSTRING(@RutaArchivoBD, CHARINDEX('\', @RutaArchivoBD, 1), LEN(@RutaArchivoBD))
	SELECT @RutaArchivoBD = RTRIM(LTRIM(REVERSE(@RutaArchivoBD)))
END

IF @Database IS NULL
	SELECT @Database = RTRIM(DB_NAME())

IF @Filegroup IS NULL
	SELECT @Filegroup = 'Hist'

IF @FileName IS NULL
	SELECT @FileName = @RutaArchivoBD + @Database + '_' + @Filegroup + '.ndf'
IF EXISTS(SELECT * FROM sysobjects where id = object_id('HistMov') and sysstat & 0xf = 3)

DROP TABLE HistMov
CREATE TABLE HistMov (
	Tabla VARCHAR(100) NOT NULL PRIMARY KEY
)
INSERT HistMov (Tabla)
	VALUES ('Mov')
INSERT HistMov (Tabla)
	VALUES ('MovTiempo')
INSERT HistMov (Tabla)
	VALUES ('MovEstatusLog')
INSERT HistMov (Tabla)
	VALUES ('MovUsuario')
INSERT HistMov (Tabla)
	VALUES ('MovBitacora')
INSERT HistMov (Tabla)
	VALUES ('MovImpuesto')
INSERT HistMov (Tabla)
	VALUES ('MovRecibo')
INSERT HistMov (Tabla)
	VALUES ('MovPresupuesto')
INSERT HistMov (Tabla)
	VALUES ('MovPersonal')
INSERT HistMov (Tabla)
	VALUES ('MovGastoIndirecto')
INSERT HistMov (Tabla)
	VALUES ('MovArtEstatus')
INSERT HistMov (Tabla)
	VALUES ('MovTarea')
INSERT HistMov (Tabla)
	VALUES ('MovReg')
INSERT HistMov (Tabla)
	VALUES ('MovDReg')

IF @Modulo IS NULL
BEGIN
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado ([SQL], Ejecutable)
		SELECT ''
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ''
			  ,0
	INSERT HistResultado ([SQL], Ejecutable)
		SELECT 'ALTER DATABASE ' + @Database + ' ADD FILEGROUP ' + @Filegroup
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ''
			  ,0
	INSERT HistResultado ([SQL], Ejecutable)
		SELECT 'ALTER DATABASE ' + @Database + ' ' +
			   'ADD FILE(NAME = ' + @Database + '_' + @Filegroup + ', FILENAME = ''' + @FileName + ''', ' +
			   'SIZE = 5MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5MB) TO FILEGROUP ' + @Filegroup
			  ,1
		UNION
		SELECT CHAR(71) + CHAR(79)
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'USE ' + @Database
			  ,1
	DECLARE
		crTabla
		CURSOR LOCAL FOR
		SELECT RTRIM(SysTabla)
		FROM SysTabla
WITH(NOLOCK) WHERE SysTabla IN (SELECT Tabla FROM HistMov WITH(NOLOCK) )
		ORDER BY SysTabla
	OPEN crTabla
	FETCH NEXT FROM crTabla  INTO @Tabla
	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF @Especial IS NULL
	BEGIN
		SELECT @hTabla = 'h' + @Tabla
		INSERT HistResultado (SQL)
			SELECT ''
		INSERT HistResultado (SQL, Ejecutable)
			SELECT 'CREATE TABLE ' + @hTabla + '('
				  ,1
		EXEC spHistSugerirEstructura @Tabla
									,@ConTipoDatos = 1
									,@ConNulos = 1
									,@ConvertirVarchar = 1
									,@AsCalcSinDatos = @ModuloIsNotNull
									,@HistCampo = 1

		IF ISNULL(dbo.fnTablaPKSt(@Tabla), '') <> ''
			INSERT HistResultado (SQL, Ejecutable)
				SELECT ' CONSTRAINT pk_' + @hTabla + ' PRIMARY KEY CLUSTERED (' + dbo.fnTablaPKSt(@Tabla) + ')'
					  ,1

		INSERT HistResultado (SQL, Ejecutable)
			SELECT ') ON ' + @Filegroup
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT CHAR(71) + CHAR(79)
				  ,1
	END

	IF @Especial IN (NULL, 'VISTAS')
	BEGIN
		SELECT @gTabla = 'g' + @Tabla
		INSERT HistResultado (SQL)
			SELECT ''
		INSERT HistResultado (SQL, Ejecutable)
			SELECT 'CREATE VIEW ' + @gTabla
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' AS'
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT 'SELECT '
				  ,1
		EXEC spHistSugerirEstructura @Tabla
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' FROM ' + @Tabla ' WITH(NOLOCK)'
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT 'UNION ALL '
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT 'SELECT '
				  ,1
		EXEC spHistSugerirEstructura @Tabla
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' FROM ' + @hTabla
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT CHAR(71) + CHAR(79)
				  ,1
	END

	FETCH NEXT FROM crTabla  INTO @Tabla
	END
	CLOSE crTabla
	DEALLOCATE crTabla
	SELECT @MovTabla = 'Mov'
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'IF EXISTS(SELECT * FROM SYSOBJECTS WHERE ID = object_id(''dbo.spHist' + @MovTabla + 'Mover'') AND TYPE = ''P'') DROP PROCEDURE dbo.spHist' + @MovTabla + 'Mover'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'CREATE PROCEDURE spHist' + @MovTabla + 'Mover'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @ID int,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @Modulo varchar(5),'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @Ok int OUTPUT,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @OkRef varchar(255) OUTPUT'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ''
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'AS BEGIN'
			  ,1
	DECLARE
		crTabla
		CURSOR LOCAL FOR
		SELECT RTRIM(SysTabla)
		FROM SysTabla
WITH(NOLOCK) WHERE SysTabla IN (SELECT Tabla FROM HistMov)
		ORDER BY SysTabla
	OPEN crTabla
	FETCH NEXT FROM crTabla  INTO @Tabla
	WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @Resultado = ''
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' INSERT h' + @Tabla
			  ,1
	EXEC spHistSugerirEstructura @Tabla
								,@EnSilencio = 1
								,@Resultado = @Resultado OUTPUT
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' (' + @Resultado + ')'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' SELECT ' + @Resultado
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' FROM ' + @Tabla
			  ,1
	SELECT @Campo = dbo.fnIDModuloID(@Tabla)

	IF @Modulo IS NOT NULL
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' WHERE ' + @Campo + ' = @ID'
				  ,1
	ELSE
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' WHERE ' + @Campo + ' = @ID AND Modulo = @Modulo'
				  ,1

	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' IF @@ERROR <> 0 SELECT @Ok = ' + CONVERT(VARCHAR, @ErrorInsertar) + ', @OkRef = ''h' + @Tabla + ''''
			  ,1

	IF @Modulo IS NOT NULL
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' DELETE ' + @Tabla + ' WHERE ' + @Campo + ' = @ID'
				  ,1
	ELSE
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' DELETE ' + @Tabla + ' WHERE ' + @Campo + ' = @ID AND Modulo = @Modulo'
				  ,1

	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' IF @@ERROR <> 0 SELECT @Ok = ' + CONVERT(VARCHAR, @ErrorEliminar) + ', @OkRef = ''' + @Tabla + ''''
			  ,1
	FETCH NEXT FROM crTabla  INTO @Tabla
	END
	CLOSE crTabla
	DEALLOCATE crTabla
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' RETURN'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'END'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
END

IF @Modulo IS NOT NULL
BEGIN
	SELECT @MovTabla = RTRIM(dbo.fnMovTabla(@Modulo))
	INSERT HistResultado (SQL)
		SELECT ''
	DECLARE
		crTabla
		CURSOR LOCAL FOR
		SELECT RTRIM(SysTabla)
		FROM SysTabla
WITH(NOLOCK) WHERE Modulo = @Modulo
		AND SysTabla NOT IN ('DimPasoPipe')
		ORDER BY Orden
	OPEN crTabla
	FETCH NEXT FROM crTabla  INTO @Tabla
	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF @Especial IS NULL
	BEGIN
		SELECT @hTabla = 'h' + @Tabla
		INSERT HistResultado (SQL)
			SELECT ''
		INSERT HistResultado (SQL, Ejecutable)
			SELECT 'CREATE TABLE ' + @hTabla + '('
				  ,1
		EXEC spHistSugerirEstructura @Tabla
									,@ConTipoDatos = 1
									,@ConNulos = 1
									,@ConvertirVarchar = 1
									,@AsCalcSinDatos = @ModuloIsNotNull
									,@HistCampo = 1

		IF ISNULL(dbo.fnTablaPKSt(@Tabla), '') <> ''
			INSERT HistResultado (SQL, Ejecutable)
				SELECT ' CONSTRAINT pk_' + @hTabla + ' PRIMARY KEY CLUSTERED (' + dbo.fnTablaPKSt(@Tabla) + ')'
					  ,1

		INSERT HistResultado (SQL, Ejecutable)
			SELECT ') ON ' + @Filegroup
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT CHAR(71) + CHAR(79)
				  ,1

		IF @Especial IN (NULL, 'VISTAS')
		BEGIN
			SELECT @gTabla = 'g' + @Tabla
			INSERT HistResultado (SQL)
				SELECT ''
			INSERT HistResultado (SQL, Ejecutable)
				SELECT 'CREATE VIEW ' + @gTabla
					  ,1
			INSERT HistResultado (SQL, Ejecutable)
				SELECT ' AS'
					  ,1
			INSERT HistResultado (SQL, Ejecutable)
				SELECT 'SELECT '
					  ,1
			EXEC spHistSugerirEstructura @Tabla
			INSERT HistResultado (SQL, Ejecutable)
				SELECT ' FROM ' + @Tabla
					  ,1
			INSERT HistResultado (SQL, Ejecutable)
				SELECT 'UNION ALL '
					  ,1
			INSERT HistResultado (SQL, Ejecutable)
				SELECT 'SELECT '
					  ,1
			EXEC spHistSugerirEstructura @Tabla
			INSERT HistResultado (SQL, Ejecutable)
				SELECT ' FROM ' + @hTabla
					  ,1
			INSERT HistResultado (SQL, Ejecutable)
				SELECT CHAR(71) + CHAR(79)
					  ,1
		END

		FETCH NEXT FROM crTabla  INTO @Tabla
	END

	END
	CLOSE crTabla
	DEALLOCATE crTabla

	IF RTRIM(@MovTabla) <> 'Mov'
	BEGIN
		INSERT HistResultado (SQL)
			SELECT 'EXEC spADD_INDEX ''' + @MovTabla + ''', ''Hist'', ''FechaEmision, ID, Estatus'''
		INSERT HistResultado (SQL)
			SELECT CHAR(71) + CHAR(79)
	END

	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'IF EXISTS(SELECT * FROM sysobjects WHERE ID = object_id(' + CHAR(39) + 'dbo.' + 'spHist' + @MovTabla + 'Mover' + CHAR(39) + ') AND TYPE = ' + CHAR(39) + 'P' + CHAR(39) + ')'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'DROP PROCEDURE dbo.' + 'spHist' + @MovTabla + 'Mover'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'CREATE PROCEDURE spHist' + @MovTabla + 'Mover'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @ID int,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @Ok int OUTPUT,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @OkRef varchar(255) OUTPUT'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ''
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'AS BEGIN'
			  ,1
	DECLARE
		crTabla
		CURSOR LOCAL FOR
		SELECT RTRIM(SysTabla)
		FROM SysTabla
WITH(NOLOCK) WHERE Modulo = @Modulo
		AND SysTabla NOT IN ('DimPasoPipe')
		ORDER BY Orden
	OPEN crTabla
	FETCH NEXT FROM crTabla  INTO @Tabla
	WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @Resultado = ''
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' INSERT h' + @Tabla
			  ,1
	EXEC spHistSugerirEstructura @Tabla
								,@EnSilencio = 1
								,@Resultado = @Resultado OUTPUT
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' (' + @Resultado + ')'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' SELECT ' + @Resultado
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' FROM ' + @Tabla
			  ,1
	SELECT @Campo = dbo.fnIDModuloID(@Tabla)

	IF @Modulo IS NOT NULL
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' WHERE ' + @Campo + ' = @ID'
				  ,1
	ELSE
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' WHERE ' + @Campo + ' = @ID AND Modulo = @Modulo'
				  ,1

	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' IF @@ERROR <> 0 SELECT @Ok = ' + CONVERT(VARCHAR, @ErrorInsertar) + ', @OkRef = ''h' + @Tabla + ''''
			  ,1

	IF @Modulo IS NOT NULL
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' DELETE ' + @Tabla + ' WHERE ' + @Campo + ' = @ID'
				  ,1
	ELSE
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' DELETE ' + @Tabla + ' WHERE ' + @Campo + ' = @ID AND Modulo = @Modulo'
				  ,1

	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' IF @@ERROR <> 0 SELECT @Ok = ' + CONVERT(VARCHAR, @ErrorEliminar) + ', @OkRef = ''' + @Tabla + ''''
			  ,1
	FETCH NEXT FROM crTabla  INTO @Tabla
	END
	CLOSE crTabla
	DEALLOCATE crTabla
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' RETURN'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'END'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
END

IF @Modulo IS NOT NULL
	AND @Especial IS NULL
BEGIN
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'IF EXISTS (SELECT * FROM sysobjects WHERE ID = object_id(''dbo.spHist' + @MovTabla + ''') AND TYPE = ''P'') DROP PROCEDURE dbo.spHist' + @MovTabla
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		VALUES (CHAR(71) + CHAR(79), 1)
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'CREATE PROCEDURE spHist' + @MovTabla
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @Horas float,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @HastaFecha datetime,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @HastaHora datetime,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @Ok int OUTPUT,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @OkRef varchar(255) OUTPUT'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ''
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'AS BEGIN'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'DECLARE'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @ID int,'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' @Cantidad int'
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' BEGIN TRANSACTION'
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' ALTER TABLE ' + @MovTabla + ' DISABLE TRIGGER ALL '
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' SELECT @Cantidad = 0'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' DECLARE crHist' + @MovTabla + ' CURSOR FORWARD_ONLY LOCAL STATIC FOR '
			  ,1

	IF @Top IS NULL
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' SELECT ID'
				  ,1
	ELSE
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' SELECT TOP ' + CONVERT(VARCHAR, @Top) + ' ID'
				  ,1

	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' FROM ' + @MovTabla
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' WHERE FechaEmision < @HastaFecha AND Estatus IN (''CONCLUIDO'', ''CONCILIADO'', ''CANCELADO'')'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' ORDER BY FechaEmision'
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' OPEN crHist' + @MovTabla
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' FETCH NEXT FROM crHist' + @MovTabla + ' INTO @ID'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' BEGIN'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' EXEC spHist' + @MovTabla + 'Mover @ID, @Ok OUTPUT, @OkRef OUTPUT'
			  ,1

	IF @Modulo IS NOT NULL
	BEGIN
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' IF @Ok IS NULL'
				  ,1
		INSERT HistResultado (SQL, Ejecutable)
			SELECT ' EXEC spHistMovMover @ID, ''' + @Modulo + ''', @Ok OUTPUT, @OkRef OUTPUT'
				  ,1
	END

	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' IF @Ok IS NULL SELECT @Cantidad = @Cantidad + 1'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' FETCH NEXT FROM crHist' + @MovTabla + ' INTO @ID'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' END'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' CLOSE crHist' + @MovTabla
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' DEALLOCATE crHist' + @MovTabla
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' ALTER TABLE ' + @MovTabla + ' ENABLE TRIGGER ALL '
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' IF @Ok IS NULL COMMIT TRANSACTION ELSE ROLLBACK TRANSACTION'
			  ,1
	INSERT HistResultado (SQL)
		SELECT ''
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' INSERT HistLog (Modulo, HastaFecha, HastaHora, Cantidad, Ok, OkRef, Horas, Periodo, Ejercicio) VALUES (''' + @Modulo + ''', @HastaFecha, @HastaHora, @Cantidad, @Ok, @OkRef, @Horas, MONTH(@HastaFecha), YEAR(@HastaFecha))'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT ' RETURN'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT 'END'
			  ,1
	INSERT HistResultado (SQL, Ejecutable)
		SELECT CHAR(71) + CHAR(79)
			  ,1
END

IF @EnSilencio = 0
	SELECT [SQL]
	FROM HistResultado WITH(NOLOCK)
END

