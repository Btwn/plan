USE [IntelisisTmp]
GO
/****** Object:  StoredProcedure [dbo].[SP_RM1155ReporteAsistencias]    Script Date: 02/07/2019 04:29:27 p. m. ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---- =======================================================================================================================================
---- NOMBRE			: SP_RM1155ReporteAsistencias
---- AUTOR			: Fernando Hernández Rubio.
---- FECHA CREACION	: 11-05-2017
---- DESARROLLO		: Reporte de Asistencias.
---- DESCRIPCION	: Consulta de las asistencias en un determinado periodo de tiempo, filtrado por Departamento y/o Puesto.
---- Ejemplo		: EXEC SP_RM1155ReporteAsistencias '2017-03-01','2017-03-16','CREDITO,TECNOLOGIAS DE INFORMACION','AUXILIAR ADMVO,ADMINISTRADOR INTELISIS'
---- ========================================================================================================================================


ALTER PROCEDURE [dbo].[SP_RM1155ReporteAsistencias]
		@FechaD DATETIME,
		@FechaA DATETIME,
		@Dep VARCHAR(MAX),
		@Puesto VARCHAR(MAX)
AS
BEGIN
DECLARE 
@ConsultaWhere VARCHAR(4000),
@sql NVARCHAR(MAX)


IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Universo') AND TYPE='U')
	DROP TABLE #Universo
IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Pivote') AND TYPE='U')
	DROP TABLE #Pivote
IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Pivotear') AND TYPE='U')
	DROP TABLE #Pivotear
IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Reporte') AND TYPE='U')
  DROP TABLE #Reporte


	CREATE TABLE #Universo(
		Id INT IDENTITY(1,1),
		Nombre VARCHAR(100) NULL,
		Nomina VARCHAR(20) NULL,
		Departamento VARCHAR(100) NULL,
		Puesto VARCHAR(100) NULL,
		Registro VARCHAR(20) NULL,
		HoraReg VARCHAR(5) NULL,
		FechaAplic DATETIME NULL,
		FechaIngreso DATETIME NULL
	) 

	CREATE TABLE #Pivote(
		Nomina VARCHAR(20) NULL,
		FechaAplic DATETIME NULL,
		Checada1 VARCHAR(5) NULL,
		Checada2 VARCHAR(5) NULL,
		Checada3 VARCHAR(5) NULL,
		Checada4 VARCHAR(5) NULL		
	)
	

	CREATE TABLE #Reporte(
		Nomina VARCHAR(20) NULL,
		Nombre VARCHAR(100) NULL,
		Departamento VARCHAR(100) NULL,
		Puesto VARCHAR(100) NULL,
		FechaIngreso DATETIME NULL,
		FechaRegistro DATETIME NULL,
		Entrada VARCHAR(5) NULL,
		SalidaComida VARCHAR(5) NULL,
		RegresoComida VARCHAR(5) NULL,
		Salida VARCHAR(5) NULL
	)

--------Validación de filtros. Se verifica que las variables @Dep y/o @Puesto tengan datos, 
--------Intelisis envía los datos de esta forma 'CREDITO,TECNOLOGIAS DE INFORMACION', 
--------primeramente reemplaza la coma por ',' ej.'CREDITO,TECNOLOGIAS DE INFORMACION' --->  CREDITO','TECNOLOGIAS DE INFORMACION
--------se concatena la cadena a comparar en la variable @ConsultaWhere dependiendo el caso.
SET @Dep=REPLACE(@Dep, ',',''',''')
SET @Puesto=REPLACE(@Puesto, ',',''',''') 
SET @ConsultaWHERE='' 
	
	IF @Dep IS NULL OR @Dep='' OR @Dep=' '
		SET @ConsultaWhere=@ConsultaWhere + ' T.Departamento IN(SELECT Descripcion FROM COMERCIALIZADORA.DBO.Departamento WITH(NOLOCK))'
	ELSE 
		SET @ConsultaWhere=@ConsultaWhere + ' T.Departamento IN ('+CHAR(39)+@Dep+CHAR(39)+')'

	
	IF @Puesto IS NULL OR @Puesto = '' OR @Puesto = ' '
		SET @ConsultaWhere=@ConsultaWhere + '  AND T.Puesto IN(SELECT Descripcion FROM COMERCIALIZADORA.DBO.Puesto WITH(NOLOCK))'
	ELSE
		SET @ConsultaWhere=@ConsultaWhere + '  AND T.Puesto IN ('+CHAR(39)+@Puesto+CHAR(39)+')'



--------Tabla #Universo. Esta tabla esta compuesta por las tablas físicas Asiste, AsisteD, Personal, Departamento,Puesto mediante una consulta dinámica;
--------filtrado por un rango de fechas, por departamento y/o puesto.
	SET @sql=(N'SELECT * FROM(SELECT Nombre=P.ApellidoPaterno+'' ''+P.ApellidoMaterno+'' ''+P.Nombre,AD.Personal,D.Descripcion AS Departamento,
	PU.Descripcion AS Puesto,AD.Registro,AD.HoraRegistro,A.FechaAplicacion,P.FechaAlta 
	FROM COMERCIALIZADORA.DBO.AsisteD AD WITH(NOLOCK) JOIN COMERCIALIZADORA.DBO.Asiste A WITH(NOLOCK) ON AD.ID=A.ID AND A.Estatus IN(''CONCLUIDO'',''BORRADOR'',''PROCESAR'') 
	AND A.FechaAplicacion BETWEEN @FechaD AND @FechaA AND A.Mov=''Registro'' 
	JOIN COMERCIALIZADORA.DBO.Personal P WITH(NOLOCK) ON P.Personal=AD.Personal AND P.Estatus=''ALTA''
	JOIN COMERCIALIZADORA.DBO.Departamento D WITH(NOLOCK) ON D.Departamento=P.Departamento
	JOIN COMERCIALIZADORA.DBO.Puesto PU WITH(NOLOCK) ON PU.Puesto=P.Puesto)T 
	WHERE'+@ConsultaWhere+' ORDER BY T.Personal ASC,T.FechaAplicacion ASC,T.HoraRegistro ASC')	
	
	INSERT INTO #Universo(Nombre,Nomina,Departamento,Puesto,Registro,HoraReg,FechaAplic,FechaIngreso)
	EXEC SP_EXECUTESQL @sql,N'@FechaD DATETIME,@FechaA DATETIME',@FechaD,@FechaA



--------Tabla #Pivotear. Se compone de la tabla #Universo, se realiza una partición (denominada Ord) por FechaAplic y Nomina, 
--------ordenado por las columnas antes mencionadas para poder convertir la columna HoraReg en 4 columnas.	
	SELECT ROW_NUMBER() OVER(PARTITION BY FechaAplic,Nomina ORDER BY FechaAplic,Nomina)Ord,Nomina,FechaAplic,HoraReg INTO #Pivotear FROM #Universo
	


--------Tabla #Pivote. Se realiza el Pivot de la columna HoraReg por medio de la columna particionada Ord, 
--------en esta parte la columna HoraReg se transforma en 4 columnas denominadas Checada1, Checada2, Checada3, Checada4. 
	INSERT INTO #Pivote(Nomina,FechaAplic,Checada1,Checada2,Checada3,Checada4)
	SELECT [Nomina],[FechaAplic],[1] AS Checada1,[2] AS Checada2,[3] AS Checada3,[4] AS Checada4
	FROM(SELECT * FROM #Pivotear PIVOT(MAX(HoraReg) FOR Ord IN ([1],[2],[3],[4]))pvt)A ORDER BY Nomina



--------Tabla #Reporte. Esta tabla será la que mostrará el reporte final.	
	INSERT INTO #Reporte(Nomina,FechaRegistro,Entrada)
	SELECT Nomina,FechaAplic,Checada1 FROM #Pivote



----------Actualiza Tabla #Reporte. Se actualiza la columna Salida cuando el día sea un Sábado, 
----------ya que dicho día solo se realizan dos checadas (Entrada y Salida).	
	UPDATE #Reporte SET Salida=P.Checada2 FROM #Reporte R JOIN #Pivote P ON R.Nomina=P.Nomina 
	AND R.FechaRegistro=P.FechaAplic WHERE DATENAME(WEEKDAY,P.FechaAplic)='Saturday' 



----------Actualiza Tabla #Reporte. Se actualiza la columna Salida cuando el día sea un Domingo, 
----------ya que dicho día solo se realizan dos checadas (Entrada y Salida).	
	UPDATE #Reporte SET Salida=P.Checada2 FROM #Reporte R JOIN #Pivote P ON R.Nomina=P.Nomina 
	AND R.FechaRegistro=P.FechaAplic WHERE DATENAME(WEEKDAY,P.FechaAplic)='Sunday' 

	

----------Actualiza Tabla #Reporte. Se actualiza la columna Salida cuando son días entre semana, 
----------ya que algunos departamentos solo se realizan dos checadas (Entrada y Salida).
	UPDATE #Reporte SET Salida=P.Checada2 FROM #Reporte R JOIN #Pivote P ON R.Nomina=P.Nomina 
	AND R.FechaRegistro=P.FechaAplic WHERE DATENAME(WEEKDAY,P.FechaAplic)<>'Saturday' AND DATENAME(WEEKDAY,P.FechaAplic)<>'Sunday'
	 AND DATEDIFF(HOUR,CONVERT(time,P.Checada1),CONVERT(time,P.Checada2))>8



----------Actualiza Tabla #Reporte. Se actualiza las columnas SalidaComida, RegresoComida, Salida cuando son días entre semana, 
----------esta validación es para cuando se realizaron sus cuatro checadas del día.
	UPDATE #Reporte SET SalidaComida=P.Checada2,RegresoComida=P.Checada3,Salida=P.Checada4 FROM #Reporte R JOIN #Pivote P ON R.Nomina=P.Nomina 
	AND R.FechaRegistro=P.FechaAplic WHERE DATENAME(WEEKDAY,P.FechaAplic)<>'Saturday' AND DATENAME(WEEKDAY,P.FechaAplic)<>'Sunday'
	AND DATEDIFF(HOUR,CONVERT(time,P.Checada1),CONVERT(time,P.Checada2))<8 



--------Actualiza Tabla #Reporte. Se actualizan las columas Entrada, SalidaComida, RegresoComida, Salida con la leyenda S/R 
--------cuando no se detecto alguna checada.
	UPDATE #Reporte SET Entrada='S/R' WHERE Entrada IS NULL
	UPDATE #Reporte SET SalidaComida='S/R' WHERE SalidaComida IS NULL
	UPDATE #Reporte SET RegresoComida='S/R' WHERE RegresoComida IS NULL
	UPDATE #Reporte SET Salida='S/R' WHERE Salida IS NULL



--------Actualiza Tabla #Reporte. Se actualizan las columnas Nombre, Departamento, Puesto y Fecha de Ingreso de la Tabla #Universo.
	UPDATE #Reporte SET Nombre=U.Nombre FROM #Universo U JOIN #Reporte R ON U.Nomina=R.Nomina
	UPDATE #Reporte SET Departamento=U.Departamento FROM #Universo U JOIN #Reporte R ON U.Nomina=R.Nomina
	UPDATE #Reporte SET Puesto=U.Puesto FROM #Universo U JOIN #Reporte R ON U.Nomina=R.Nomina
	UPDATE #Reporte SET FechaIngreso=U.FechaIngreso FROM #Universo U JOIN #Reporte R ON U.Nomina=R.Nomina


--------Tabla #Reporte. Se muestra el reporte completo, ordenado por Departamento, Puesto, Nomina y FechaRegistro; este ultimo de forma descendente.
	SELECT * FROM #Reporte ORDER BY Departamento,Puesto,Nomina,FechaRegistro DESC


IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Universo') AND TYPE='U')
	DROP TABLE #Universo
IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Pivote') AND TYPE='U')
	DROP TABLE #Pivote
IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Pivotear') AND TYPE='U')
	DROP TABLE #Pivotear
IF EXISTS(SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID=OBJECT_ID('tempdb..#Reporte') AND TYPE='U')
  DROP TABLE #Reporte
END