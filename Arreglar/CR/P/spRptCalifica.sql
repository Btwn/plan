SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRptCalifica
@Personal	varchar(10),
@Curso		varchar(50),
@IDExamen	int

AS
BEGIN
CREATE TABLE #Calificacion (
NPregunta			int,
CorrectaIncorrecta	varchar(15),
Personal			varchar(10),
Curso				varchar(50))
DECLARE @NPregunta			int,
@Respuesta1			varchar(2),
@Respuesta2			varchar(2),
@Respuesta3			varchar(2),
@Respuesta4			varchar(2),
@Respuesta5			varchar(2),
@CorrectaIncorrecta	varchar(15)
SELECT CASE WHEN ep.R1=e.CresPuesta1 THEN 'OK' ELSE CONVERT(varchar(2),ep.R1) END Respuesta1,
CASE WHEN ep.R2=e.CresPuesta2 THEN 'OK' ELSE CONVERT(varchar(2),ep.R2) END Respuesta2,
CASE WHEN ep.R3=e.CresPuesta3 THEN 'OK' ELSE CONVERT(varchar(2),ep.R3) END Respuesta3,
CASE WHEN ep.R4=e.CresPuesta4 THEN 'OK' ELSE CONVERT(varchar(2),ep.R4) END Respuesta4,
CASE WHEN ep.R5=e.CresPuesta5 THEN 'OK' ELSE CONVERT(varchar(2),ep.R5) END Respuesta5,
ep.Npregunta
INTO #ParaCursor
FROM heExamenPersonal ep
JOIN heExamen e ON e.NPregunta=ep.NPregunta AND e.Curso=ep.Curso
WHERE ep.Personal=@Personal AND e.Tipo='CERRADA' AND ep.Curso=@Curso /*AND ep.Fecha=@Fecha*/ AND ep.IDExamen=@IDExamen
DECLARE heCalifica CURSOR
FOR SELECT Respuesta1,Respuesta2,Respuesta3,Respuesta4,Respuesta5,NPregunta
FROM #ParaCursor
OPEN heCalifica
FETCH NEXT FROM heCalifica INTO @Respuesta1,@Respuesta2,@Respuesta3,@Respuesta4,@Respuesta5,@NPregunta
WHILE @@FETCH_STATUS=0
BEGIN
IF (@Respuesta1='OK' AND @Respuesta2='OK') AND (@Respuesta3='OK' AND @Respuesta4='OK') AND @Respuesta5='OK' SET @CorrectaIncorrecta='CORRECTA'
ELSE SET @CorrectaIncorrecta='INCORRECTA'
INSERT #Calificacion VALUES (@NPregunta,@CorrectaIncorrecta,@Personal,@Curso)
FETCH NEXT FROM heCalifica INTO @Respuesta1,@Respuesta2,@Respuesta3,@Respuesta4,@Respuesta5,@NPregunta
END
CLOSE heCalifica
DEALLOCATE heCalifica
INSERT #Calificacion
SELECT ep.NPregunta,CASE WHEN ep.R1=1 THEN 'CORRECTA' ELSE 'INCORRECTA' END,@Personal,@Curso
FROM heExamenPersonal ep
JOIN heExamen e ON e.NPregunta=ep.NPregunta AND e.Curso=ep.Curso
WHERE ep.Personal=@Personal AND e.Tipo='ABIERTA' AND ep.Curso=@Curso /*AND ep.Fecha=@Fecha*/ AND ep.IDExamen=@IDExamen
SELECT @Personal Personal,@Curso Curso,#Calificacion.NPregunta,p.ApellidoPaterno,p.ApellidoMaterno,p.Nombre,#Calificacion.CorrectaIncorrecta,
CASE WHEN #Calificacion.CorrectaIncorrecta='CORRECTA' THEN ISNULL(m.Ponderacion,1) ELSE 0 END Calificacion
FROM #Calificacion
JOIN heExamen m ON m.Curso=#Calificacion.Curso AND m.Npregunta=#Calificacion.NPregunta
JOIN Personal p ON p.Personal=#Calificacion.Personal
ORDER BY #Calificacion.NPregunta
DROP TABLE #ParaCursor
DROP TABLE #Calificacion
END

