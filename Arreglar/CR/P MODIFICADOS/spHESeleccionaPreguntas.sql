SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHESeleccionaPreguntas
@Curso			varchar(50),
@Nivel			varchar(15),
@NPreguntas		int,
@Nivel1			varchar(15)=NULL,
@NPreguntas1	int=-1,
@Nivel2			varchar(15)=NULL,
@NPreguntas2	int=-1,
@Personal		varchar(10),
@Aleatorio		char(2)='Si'

AS
BEGIN
SET NOCOUNT ON
DECLARE @NPregunta int,
@Aux  int,
@Fecha  datetime,
@IDExamen int,
@PassWord varchar(5)
SELECT @Fecha=CONVERT(datetime,CONVERT(varchar(4),YEAR(GETDATE()))+RIGHT('00'+CONVERT(varchar(2),MONTH(GETDATE())),2)+
RIGHT('00'+CONVERT(varchar(2),DAY(GETDATE())),2))
SELECT @Aux=COUNT(0) FROM Personal with (nolock ) WHERE Personal=@Personal
IF @Aux=0
BEGIN
RAISERROR('El Personal No existe o no esta dado de ALTA',16,1)
RETURN -1
END
SELECT @Aux=COUNT(0) FROM heExamenCurso with (nolock ) WHERE Curso=@Curso AND Estatus='ALTA'
IF @Aux=0
BEGIN
RAISERROR('El Curso No existe o no esta dado de ALTA',16,1)
RETURN -1
END
SELECT @Aux=COUNT(0) FROM heExamen with (nolock ) WHERE Curso=@Curso AND Nivel=(CASE @Nivel WHEN 'TODOS' THEN Nivel ELSE @Nivel END) AND Estatus='ALTA'
IF @NPreguntas=0 SELECT @NPreguntas=COUNT(0) FROM heExamen with (nolock ) WHERE Curso=@Curso AND Nivel=(CASE @Nivel WHEN 'TODOS' THEN Nivel ELSE @Nivel END) AND Estatus='ALTA'
IF @NPreguntas>@Aux
BEGIN
RAISERROR('No existen preguntas suficientes este curso en este nivel',16,1)
RETURN -1
END
IF @NPreguntas1>-1
BEGIN
SELECT @Aux=COUNT(0) FROM heExamen with (nolock ) WHERE Curso=@Curso AND Nivel=(CASE @Nivel1 WHEN 'TODOS' THEN Nivel ELSE @Nivel1 END) AND Estatus='ALTA'
IF @NPreguntas1=0 SELECT @NPreguntas1=COUNT(0) FROM heExamen with (nolock ) WHERE Curso=@Curso AND Nivel=(CASE @Nivel1 WHEN 'TODOS' THEN Nivel ELSE @Nivel1 END) AND Estatus='ALTA'
IF @NPreguntas1>@Aux
BEGIN
RAISERROR('No existen preguntas suficientes este curso en este nivel1',16,1)
RETURN -1
END
END
IF @NPreguntas2>-1
BEGIN
SELECT @Aux=COUNT(0) FROM heExamen with (nolock ) WHERE Curso=@Curso AND Nivel=(CASE @Nivel2 WHEN 'TODOS' THEN Nivel ELSE @Nivel2 END) AND Estatus='ALTA'
IF @NPreguntas2=0 SELECT @NPreguntas2=COUNT(0) FROM heExamen with (nolock ) WHERE Curso=@Curso AND Nivel=(CASE @Nivel2 WHEN 'TODOS' THEN Nivel ELSE @Nivel2 END) AND Estatus='ALTA'
IF @NPreguntas2>@Aux
BEGIN
RAISERROR('No existen preguntas suficientes este curso en este nivel2',16,1)
RETURN -1
END
END
SELECT @IDExamen=ISNULL(MAX(IDExamen),0)+1 FROM heExamenPersonal with (nolock )
EXEC spHECreaPassWord @PassWord OUTPUT
WHILE @NPreguntas>0
BEGIN
SELECT @NPregunta=NPregunta
FROM heExamenCurso c
 WITH(NOLOCK) JOIN heExamen e  WITH(NOLOCK) ON e.Curso=C.Curso
WHERE c.Estatus='ALTA' AND c.Curso=@Curso AND e.Nivel=(CASE @Nivel WHEN 'TODOS' THEN e.Nivel ELSE @Nivel END) AND
NPregunta=CASE WHEN @Aleatorio='Si' THEN (FLOOR(RAND()*200)) ELSE Npregunta END AND e.Estatus='ALTA'
AND NPregunta NOT IN(SELECT heExamenPersonal.NPregunta FROM heExamenPersonal
 WITH(NOLOCK) JOIN heExamen  WITH(NOLOCK) ON heExamenPersonal.Curso=heExamen.Curso AND heExamenPersonal.Npregunta=heExamen.NPregunta
WHERE Personal=@Personal AND heExamenPersonal.Curso=@Curso AND Fecha=@Fecha AND IDExamen=@IDExamen
AND heExamen.Nivel=(CASE @Nivel WHEN 'TODOS' THEN e.Nivel ELSE @Nivel END))
ORDER BY NPregunta
IF @@ROWCOUNT>0
BEGIN
SELECT @Aux=COUNT(0)
FROM heExamenPersonal
WITH(NOLOCK) WHERE Personal=@Personal AND Curso=@Curso AND NPregunta=@NPregunta AND Fecha=@Fecha AND IDExamen=@IDExamen
IF @Aux=0
BEGIN
INSERT heExamenPersonal VALUES(@IDExamen,@Personal,@PassWord,@Curso,@NPregunta,@Fecha,'SIN AFECTAR',0,'',0,0,0,0)
SET @NPreguntas=@NPreguntas-1
END
END
END
WHILE @NPreguntas1>0
BEGIN
SELECT @NPregunta=NPregunta
FROM heExamenCurso c
 WITH(NOLOCK) JOIN heExamen e  WITH(NOLOCK) ON e.Curso=C.Curso
WHERE c.Estatus='ALTA' AND c.Curso=@Curso AND e.Nivel=(CASE @Nivel1 WHEN 'TODOS' THEN e.Nivel ELSE @Nivel1 END) AND
NPregunta=CASE WHEN @Aleatorio='Si' THEN (FLOOR(RAND()*200)) ELSE Npregunta END AND e.Estatus='ALTA'
AND NPregunta NOT IN(SELECT heExamenPersonal.NPregunta FROM heExamenPersonal
 WITH(NOLOCK) JOIN heExamen  WITH(NOLOCK) ON heExamenPersonal.Curso=heExamen.Curso AND heExamenPersonal.Npregunta=heExamen.NPregunta
WHERE Personal=@Personal AND heExamenPersonal.Curso=@Curso AND Fecha=@Fecha AND IDExamen=@IDExamen
AND heExamen.Nivel=(CASE @Nivel1 WHEN 'TODOS' THEN e.Nivel ELSE @Nivel1 END))
ORDER BY NPregunta
IF @@ROWCOUNT>0
BEGIN
SELECT @Aux=COUNT(0)
FROM heExamenPersonal
WITH(NOLOCK) WHERE Personal=@Personal AND Curso=@Curso AND NPregunta=@NPregunta AND Fecha=@Fecha AND IDExamen=@IDExamen
IF @Aux=0
BEGIN
INSERT heExamenPersonal VALUES(@IDExamen,@Personal,@PassWord,@Curso,@NPregunta,@Fecha,'SIN AFECTAR',0,'',0,0,0,0)
SET @NPreguntas1=@NPreguntas1-1
END
END
END
WHILE @NPreguntas2>0
BEGIN
SELECT @NPregunta=NPregunta
FROM heExamenCurso c
 WITH(NOLOCK) JOIN heExamen e  WITH(NOLOCK) ON e.Curso=C.Curso
WHERE c.Estatus='ALTA' AND c.Curso=@Curso AND e.Nivel=(CASE @Nivel2 WHEN 'TODOS' THEN e.Nivel ELSE @Nivel2 END) AND
NPregunta=CASE WHEN @Aleatorio='Si' THEN (FLOOR(RAND()*200)) ELSE Npregunta END AND e.Estatus='ALTA'
AND NPregunta NOT IN(SELECT heExamenPersonal.NPregunta FROM heExamenPersonal
 WITH(NOLOCK) JOIN heExamen  WITH(NOLOCK) ON heExamenPersonal.Curso=heExamen.Curso AND heExamenPersonal.Npregunta=heExamen.NPregunta
WHERE Personal=@Personal AND heExamenPersonal.Curso=@Curso AND Fecha=@Fecha AND IDExamen=@IDExamen
AND heExamen.Nivel=(CASE @Nivel2 WHEN 'TODOS' THEN e.Nivel ELSE @Nivel2 END))
ORDER BY NPregunta
IF @@ROWCOUNT>0
BEGIN
SELECT @Aux=COUNT(0)
FROM heExamenPersonal
WITH(NOLOCK) WHERE Personal=@Personal AND Curso=@Curso AND NPregunta=@NPregunta AND Fecha=@Fecha AND IDExamen=@IDExamen
IF @Aux=0
BEGIN
INSERT heExamenPersonal VALUES(@IDExamen,@Personal,@PassWord,@Curso,@NPregunta,@Fecha,'SIN AFECTAR',0,'',0,0,0,0)
SET @NPreguntas2=@NPreguntas2-1
END
END
END
SELECT COUNT(0) FROM heExamenPersonal with (nolock ) WHERE Personal=@Personal AND Curso=@Curso AND Fecha=@Fecha AND IDExamen=@IDExamen
END

