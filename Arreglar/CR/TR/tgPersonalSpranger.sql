SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPersonalSpranger
ON PersonalSpranger
FOR INSERT, UPDATE
AS
BEGIN
DECLARE
@Grupo		char(30),
@Mensaje	char(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
CREATE TABLE #PersonalSpranger(
Concepto		char(30)	COLLATE Database_Default,
Grupo			char(30)	COLLATE Database_Default,
Valor			int)
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Liderazgo', 'Intereses Personales', Liderazgo FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Justicia', 'Intereses Personales', Justicia FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Cultura', 'Intereses Personales', Cultura FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Dinero', 'Intereses Personales', Dinero FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Servicio', 'Intereses Personales', Servicio FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Conocimientos', 'Intereses Personales', Conocimientos FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'DirigirPersonas', 'Motivadores Personales', DirigirPersonas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'ContinuarEstudiando', 'Motivadores Personales', ContinuarEstudiando FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'CristalizarSueños', 'Motivadores Personales', CristalizarSueños FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'AyudarOtros', 'Motivadores Personales', AyudarOtros FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'IncrementarRiquezas', 'Motivadores Personales', IncrementarRiquezas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'ParticiparArte', 'Motivadores Personales', ParticiparArte FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Caritativos', 'Pasatiempos Favoritos', Caritativos FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Estudios', 'Pasatiempos Favoritos', Estudios FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Politica', 'Pasatiempos Favoritos', Politica FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Inversiones', 'Pasatiempos Favoritos', Inversiones FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Museos', 'Pasatiempos Favoritos', Museos FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Meditacion', 'Pasatiempos Favoritos', Meditacion FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Artisticas', 'Metas Profesionales', Artisticas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Cientificas', 'Metas Profesionales', Cientificas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Empresariales', 'Metas Profesionales', Empresariales FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'PoliticaStatus', 'Metas Profesionales', PoliticaStatus FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Justicia2', 'Metas Profesionales', Justicia2 FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Servicio2', 'Metas Profesionales', Servicio2 FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'CrecimientoEspiritual', 'Autodesarrollo', CrecimientoEspiritual FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'RelacionesInterpersonales', 'Autodesarrollo', RelacionesInterpersonales FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'HabilidadesLiderazgo', 'Autodesarrollo', HabilidadesLiderazgo FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'FinanzasPersonales', 'Autodesarrollo', FinanzasPersonales FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'ContinuacionEstudios', 'Autodesarrollo', ContinuacionEstudios FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'DesarrolloArtistico', 'Autodesarrollo', DesarrolloArtistico FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'CienciasFisicas', 'Intereses Educacionales', CienciasFisicas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'CienciasPoliticas', 'Intereses Educacionales', CienciasPoliticas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Teologia', 'Intereses Educacionales', Teologia FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Artes', 'Intereses Educacionales', Artes FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Finanzas', 'Intereses Educacionales', Finanzas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Sociologia', 'Intereses Educacionales', Sociologia FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Poderoso', 'Reputacion Deseada', Poderoso FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Bondadoso', 'Reputacion Deseada', Bondadoso FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Capitalista', 'Reputacion Deseada', Capitalista FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Mediador', 'Reputacion Deseada', Mediador FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Artista', 'Reputacion Deseada', Artista FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Intelectual', 'Reputacion Deseada', Intelectual FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Filantropo', 'Papel En la Sociedad', Filantropo FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Empresario', 'Papel En la Sociedad', Empresario FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'LiderPolitico', 'Papel En la Sociedad', LiderPolitico FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'PatrocinadorArte', 'Papel En la Sociedad', PatrocinadorArte FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'LiderIntelectual', 'Papel En la Sociedad', LiderIntelectual FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'ConsejeroEspiritual', 'Papel En la Sociedad', ConsejeroEspiritual FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Humanitarias', 'Metas Personales', Humanitarias FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Economicas', 'Metas Personales', Economicas FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Cientificas2', 'Metas Personales', Cientificas2 FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'SerLider', 'Metas Personales', SerLider FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'SerErudito', 'Metas Personales', SerErudito FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'ReformadorSocial', 'Metas Personales', ReformadorSocial FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Enseñanza', 'Vocacion', Enseñanza FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Drama', 'Vocacion', Drama FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'TrabajoSocial', 'Vocacion', TrabajoSocial FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Negocios', 'Vocacion', Negocios FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Deportes', 'Vocacion', Deportes FROM Inserted
INSERT INTO #PersonalSpranger(Concepto, Grupo, Valor) SELECT 'Religion', 'Vocacion', Religion FROM Inserted
IF EXISTS(SELECT Grupo FROM #PersonalSpranger GROUP BY Grupo, Valor Having Count(Valor) > 1)
BEGIN
SELECT @Grupo = Grupo FROM #PersonalSpranger GROUP BY Grupo, Valor Having Count(Valor) > 1
SELECT @Mensaje = 'Existen valores repetidos en el Grupo ' + RTRIM(@Grupo)
RAISERROR (@Mensaje,16,-1)
END
RETURN
END

