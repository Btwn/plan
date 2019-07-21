SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPersonalCleaver
ON PersonalCleaver
FOR INSERT, UPDATE
AS
BEGIN
DECLARE
@Concepto	char(30),
@GrupoM		char(2),
@GrupoL		char(2),
@Clave		char(1),
@Seccion	char(1),
@Mensaje	char(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
CREATE TABLE #PersonalCleaver(
Concepto		char(30)	COLLATE Database_Default,
Grupo			char(30)	COLLATE Database_Default,
ValorM			bit		NULL,
ValorL			bit		NULL)
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PersuasivoM', 'A1', PersuasivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PersuasivoL', 'A1', PersuasivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'GentilM', 'A1', GentilM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'GentilL', 'A1', GentilL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'HumildeM', 'A1', HumildeM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'HumildeL', 'A1', HumildeL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'OriginalM', 'A1', OriginalM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'OriginalL', 'A1', OriginalL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AgresivoM', 'A2', AgresivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AgresivoL', 'A2', AgresivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AlmaFiestaM', 'A2', AlmaFiestaM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AlmaFiestaL', 'A2', AlmaFiestaL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ComodinoM', 'A2', ComodinoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ComodinoL', 'A2', ComodinoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'TemerosoM', 'A2', TemerosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'TemerosoL', 'A2', TemerosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AgradableM', 'A3', AgradableM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AgradableL', 'A3', AgradableL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'TemerosoDiosM', 'A3', TemerosoDiosM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'TemerosoDiosL', 'A3', TemerosoDiosL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'TenazM', 'A3', TenazM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'TenazL', 'A3', TenazL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AtractivoM', 'A3', AtractivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AtractivoL', 'A3', AtractivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'CautelosoM', 'A4', CautelosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'CautelosoL', 'A4', CautelosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DeterminadoM', 'A4', DeterminadoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DeterminadoL', 'A4', DeterminadoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConvincenteM', 'A4', ConvincenteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConvincenteL', 'A4', ConvincenteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'BonachonM', 'A4', BonachonM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'BonachonL', 'A4', BonachonL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DocilM', 'A5', DocilM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DocilL', 'A5', DocilL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AtrevidoM', 'A5', AtrevidoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AtrevidoL', 'A5', AtrevidoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'LealM', 'A5', LealM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'LealL', 'A5', LealL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'EncantadorM', 'A5', EncantadorM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'EncantadorL', 'A5', EncantadorL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DispuestoM', 'A6', DispuestoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DispuestoL', 'A6', DispuestoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DeseosoM', 'A6', DeseosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DeseosoL', 'A6', DeseosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConsecuenteM', 'A6', ConsecuenteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConsecuenteL', 'A6', ConsecuenteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'EntusiastaM', 'A6', EntusiastaM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'EntusiastaL', 'A6', EntusiastaL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'FuerzaVoluntadM', 'B1', FuerzaVoluntadM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'FuerzaVoluntadL', 'B1', FuerzaVoluntadL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'MenteAbiertaM', 'B1', MenteAbiertaM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'MenteAbiertaL', 'B1', MenteAbiertaL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ComplacienteM', 'B1', ComplacienteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ComplacienteL', 'B1', ComplacienteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AnimosoM', 'B1', AnimosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AnimosoL', 'B1', AnimosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConfiadoM', 'B2', ConfiadoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConfiadoL', 'B2', ConfiadoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'SimpatizadorM', 'B2', SimpatizadorM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'SimpatizadorL', 'B2', SimpatizadorL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ToleranteM', 'B2', ToleranteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ToleranteL', 'B2', ToleranteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AfirmativoM', 'B2', AfirmativoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AfirmativoL', 'B2', AfirmativoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'EcuanimeM', 'B3', EcuanimeM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'EcuanimeL', 'B3', EcuanimeL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PrecisoM', 'B3', PrecisoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PrecisoL', 'B3', PrecisoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'NerviosoM', 'B3', NerviosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'NerviosoL', 'B3', NerviosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'JovialM', 'B3', JovialM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'JovialL', 'B3', JovialL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DisciplinadoM', 'B4', DisciplinadoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DisciplinadoL', 'B4', DisciplinadoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'GenerosoM', 'B4', GenerosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'GenerosoL', 'B4', GenerosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'Animoso2M', 'B4', Animoso2M FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'Animoso2L', 'B4', Animoso2L FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PersistenteM', 'B4', PersistenteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PersistenteL', 'B4', PersistenteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'CompetitivoM', 'B5', CompetitivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'CompetitivoL', 'B5', CompetitivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AlegreM', 'B5', AlegreM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AlegreL', 'B5', AlegreL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConsideradoM', 'B5', ConsideradoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConsideradoL', 'B5', ConsideradoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ArmoniosoM', 'B5', ArmoniosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ArmoniosoL', 'B5', ArmoniosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AdmirableM', 'B6', AdmirableM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AdmirableL', 'B6', AdmirableL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'BondadosoM', 'B6', BondadosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'BondadosoL', 'B6', BondadosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ResignadoM', 'B6', ResignadoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ResignadoL', 'B6', ResignadoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'CaracterM', 'B6', CaracterM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'CaracterL', 'B6', CaracterL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ObedienteM', 'C1', ObedienteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ObedienteL', 'C1', ObedienteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'QuisquillosoM', 'C1', QuisquillosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'QuisquillosoL', 'C1', QuisquillosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'InconquistableM', 'C1', InconquistableM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'InconquistableL', 'C1', InconquistableL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'JuguetonM', 'C1', JuguetonM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'JuguetonL', 'C1', JuguetonL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'RespetuosoM', 'C2', RespetuosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'RespetuosoL', 'C2', RespetuosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'EmprendedorM', 'C2', EmprendedorM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'EmprendedorL', 'C2', EmprendedorL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'OptimistaM', 'C2', OptimistaM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'OptimistaL', 'C2', OptimistaL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ServicialM', 'C2', ServicialM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ServicialL', 'C', ServicialL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ValienteM', 'C3', ValienteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ValienteL', 'C3', ValienteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'InspiradorM', 'C3', InspiradorM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'InspiradorL', 'C3', InspiradorL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'SumisoM', 'C3', SumisoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'SumisoL', 'C3', SumisoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'TimidoM', 'C3', TimidoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'TimidoL', 'C3', TimidoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AdaptableM', 'C4', AdaptableM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AdaptableL', 'C4', AdaptableL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DisputadorM', 'C4', DisputadorM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DisputadorL', 'C4', DisputadorL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'IndiferenteM', 'C4', IndiferenteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'IndiferenteL', 'C4', IndiferenteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'SangreLivianaM', 'C4', SangreLivianaM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'SangreLivianaL', 'C4', SangreLivianaL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AmigueroM', 'C5', AmigueroM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AmigueroL', 'C5', AmigueroL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PacienteM', 'C5', PacienteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PacienteL', 'C5', PacienteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConfianzaMismoM', 'C5', ConfianzaMismoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConfianzaMismoL', 'C5', ConfianzaMismoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'MesuradoHablarM', 'C5', MesuradoHablarM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'MesuradoHablarL', 'C5', MesuradoHablarL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConformeM', 'C6', ConformeM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConformeL', 'C6', ConformeL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConfiableM', 'C6', ConfiableM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConfiableL', 'C6', ConfiableL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PacificoM', 'C6', PacificoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PacificoL', 'C6', PacificoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PositivoM', 'C6', PositivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PositivoL', 'C6', PositivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AventureroM', 'D1', AventureroM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AventureroL', 'D1', AventureroL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ReceptivoM', 'D1', ReceptivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ReceptivoL', 'D1', ReceptivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'CordialM', 'D1', CordialM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'CordialL', 'D1', CordialL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ModeradoM', 'D1', ModeradoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ModeradoL', 'D1', ModeradoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'IndulgenteM', 'D2', IndulgenteM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'IndulgenteL', 'D2', IndulgenteL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'EstetaM', 'D2', EstetaM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'EstetaL', 'D2', EstetaL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'VigorosoM', 'D2', VigorosoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'VigorosoL', 'D2', VigorosoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'SociableM', 'D2', SociableM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'SociableL', 'D2', SociableL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ParlanchinM', 'D3', ParlanchinM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ParlanchinL', 'D3', ParlanchinL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ControladoM', 'D3', ControladoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ControladoL', 'D3', ControladoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ConvencionalM', 'D3', ConvencionalM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ConvencionalL', 'D3', ConvencionalL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DecisivoM', 'D3', DecisivoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DecisivoL', 'D3', DecisivoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'CohibidoM', 'D4', CohibidoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'CohibidoL', 'D4', CohibidoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'ExactoM', 'D4', ExactoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'ExactoL', 'D4', ExactoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'FrancoM', 'D4', FrancoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'FrancoL', 'D4', FrancoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'BuenCompañeroM', 'D4', BuenCompañeroM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'BuenCompañeroL', 'D4', BuenCompañeroL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DiplomaticoM', 'D5', DiplomaticoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DiplomaticoL', 'D5', DiplomaticoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'AudazM', 'D5', AudazM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'AudazL', 'D5', AudazL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'RefinadoM', 'D5', RefinadoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'RefinadoL', 'D5', RefinadoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'SatisfechoM', 'D5', SatisfechoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'SatisfechoL', 'D5', SatisfechoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'InquietoM', 'D6', InquietoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'InquietoL', 'D6', InquietoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'PopularM', 'D6', PopularM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'PopularL', 'D6', PopularL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'BuenVecinoM', 'D6', BuenVecinoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'BuenVecinoL', 'D6', BuenVecinoL FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorM) SELECT 'DevotoM', 'D6', DevotoM FROM Inserted
INSERT INTO #PersonalCleaver(Concepto, Grupo, ValorL) SELECT 'DevotoL', 'D6', DevotoL FROM Inserted
SELECT @GrupoM = NULL, @GrupoL = NULL
SELECT @GrupoM = Grupo FROM #PersonalCleaver WHERE ISNULL(ValorM,0) = 1 GROUP BY Grupo HAVING Count(Grupo) > 1
SELECT @GrupoL = Grupo FROM #PersonalCleaver WHERE ISNULL(ValorL,0) = 1 GROUP BY Grupo HAVING Count(Grupo) > 1
IF @GrupoM is not null
BEGIN
SELECT @Clave = SUBSTRING(@GrupoM, 1, 1), @Seccion = SUBSTRING(@GrupoM, 2, 2)
SELECT @Mensaje = 'Existe mas de una valor en la columna de la izquierda del grupo ' + @Clave + ' Sección ' + @Seccion
RAISERROR(@Mensaje, 16, 1)
RETURN
END
ELSE
IF @GrupoL is not null
BEGIN
SELECT @Clave = SUBSTRING(@GrupoL, 1, 1), @Seccion = SUBSTRING(@GrupoL, 2, 2)
SELECT @Mensaje = 'Existe mas de una valor en la columna de la derecha del grupo ' + @Clave + ' Sección ' + @Seccion
RAISERROR(@Mensaje, 16, 1)
RETURN
END
ELSE
BEGIN
SELECT @GrupoM = Grupo FROM #PersonalCleaver WHERE ValorM = 0 GROUP BY Grupo HAVING Count(Grupo) >= 4
SELECT @GrupoL = Grupo FROM #PersonalCleaver WHERE ValorL = 0 GROUP BY Grupo HAVING Count(Grupo) >= 4
IF @GrupoM is not null
BEGIN
SELECT @Clave = SUBSTRING(@GrupoM, 1, 1), @Seccion = SUBSTRING(@GrupoM, 2, 2)
SELECT @Mensaje = 'No se seleccionó el campo de la izquierda para el Grupo ' + @Clave + ' Sección ' + @Seccion
RAISERROR(@Mensaje, 16, 1)
RETURN
END
ELSE
IF @GrupoL is not null
BEGIN
SELECT @Clave = SUBSTRING(@GrupoL, 1, 1), @Seccion = SUBSTRING(@GrupoL, 2, 2)
SELECT @Mensaje = 'No se seleccionó el campo de la derecha para el Grupo ' + @Clave + ' Sección ' + @Seccion
RAISERROR(@Mensaje, 16, 1)
RETURN
END
ELSE
BEGIN
SELECT @Concepto = NULL
SELECT @Concepto = SUBSTRING(c1.Concepto, 1, Len(c1.Concepto)-1), @GrupoL = c1.Grupo
FROM #PersonalCleaver c1, #PersonalCleaver c2
WHERE c1.ValorM = 1 and c2.ValorL = 1
AND SUBSTRING(c1.Concepto, 1, Len(c1.Concepto)-1) = SUBSTRING(c2.Concepto, 1, Len(c2.Concepto)-1)
IF @Concepto is not null
BEGIN
SELECT @Clave = SUBSTRING(@GrupoL, 1, 1), @Seccion = SUBSTRING(@GrupoL, 2, 2)
SELECT @Mensaje = 'No debe de seleccionar ambos campos del Punto ' + RTRIM(@Concepto) + ', Grupo ' + @Clave + ' Sección' + @Seccion
RAISERROR(@Mensaje, 16, 1)
RETURN
END
END
END
RETURN
END

