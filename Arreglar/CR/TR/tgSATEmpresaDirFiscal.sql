SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSATEmpresaDirFiscal ON Empresa

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Empresa          varchar(5),
@ClaveCP          varchar(5),
@ClavePais        varchar(3),
@ClaveEstado      varchar(3),
@ClaveMunicipio   varchar(3),
@ClaveLocalidad   varchar(2),
@ClaveColonia     varchar(4)
IF UPDATE(Delegacion) OR UPDATE(Colonia) OR UPDATE(CodigoPostal) OR UPDATE(Poblacion) OR UPDATE(Estado) OR UPDATE(Pais)
BEGIN
SELECT @Empresa = i.Empresa, @ClavePais = ClavePais FROM SATPais p JOIN inserted i ON p.Descripcion = i.Pais
SELECT @ClaveEstado = e.ClaveEstado FROM SATEstado e JOIN SATPais p ON e.ClavePais = p.ClavePais
JOIN inserted i ON p.Descripcion = i.Pais AND e.Descripcion = i.Estado
IF ISNULL(@ClavePais,'') = 'MEX'
SELECT
@ClaveCP = SATCatCP.ClaveCP,
@ClavePais = SATPais.ClavePais,
@ClaveEstado = SATCatCP.ClaveEstado,
@ClaveMunicipio = SATCatCP.ClaveMunicipio,
@ClaveLocalidad = SATCatCP.ClaveLocalidad,
@ClaveColonia = SATColonia.ClaveColonia
FROM SATCatCP
LEFT OUTER JOIN SATEstado ON SATCatCP.ClaveEstado=SATEstado.ClaveEstado
LEFT OUTER JOIN SATPais ON SATEstado.ClavePais = SATPais.ClavePais
LEFT OUTER JOIN SATMunicipio ON SATCatCP.ClaveMunicipio=SATMunicipio.ClaveMunicipio AND SATCatCP.ClaveEstado=SATMunicipio.ClaveEstado
LEFT OUTER JOIN SATLocalidad ON SATCatCP.ClaveLocalidad=SATLocalidad.ClaveLocalidad AND SATCatCP.ClaveEstado=SATLocalidad.ClaveEstado
LEFT OUTER JOIN SATColonia ON SATCatCP.ClaveCP = SATColonia.ClaveCP
JOIN inserted i ON ISNULL(SATCatCP.ClaveCP,'') = i.CodigoPostal
AND ISNULL(SATEstado.Descripcion,'') = i.Estado
AND ISNULL(SATPais.Descripcion,'') = i.Pais
AND ISNULL(SATMunicipio.Descripcion,'') = i.Delegacion
AND ISNULL(SATColonia.Descripcion,'') = i.Colonia
AND ISNULL(SATLocalidad.Descripcion,'') = i.Poblacion
UPDATE EmpresaDireccionFiscal SET Icono = 434, Mapeado = 1, ClaveCP = @ClaveCP, ClavePais = @ClavePais, ClaveEstado = @ClaveEstado, ClaveMunicipio = @ClaveMunicipio,
ClaveLocalidad = @ClaveLocalidad, ClaveColonia = @ClaveColonia WHERE Empresa = @Empresa
IF @@ROWCOUNT = 0 AND ISNULL(@Empresa,'') <> ''
INSERT INTO EmpresaDireccionFiscal(Empresa,  Icono, Mapeado, ClaveCP,  ClavePais,  ClaveEstado,   ClaveMunicipio,  ClaveLocalidad, ClaveColonia)
SELECT @Empresa, 434,   1,       @ClaveCP, @ClavePais, @ClaveEstado, @ClaveMunicipio, @ClaveLocalidad, @ClaveColonia
END
END

