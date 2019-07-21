SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPersonalABC ON Personal

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@PersonalDup	varchar(10),
@PersonalI 		varchar(10),
@PersonalD 		varchar(10),
@NombreNuevo	varchar(100),
@NombreAnterior	varchar(100),
@RFCNuevo		varchar(20),
@RFCAnterior	varchar(20),
@CURPNuevo		varchar(30),
@CURPAnterior	varchar(30),
@Mensaje   		varchar(255),
@Registro  		varchar(30),
@Registro2 		varchar(50),
@Registro3 		varchar(50),
@RegistroDup	varchar(50),
@SDINuevo		money,
@SDIAnterior	money,
@EmpresaNuevo	varchar(5),
@EmpresaAnterior	varchar(5),
@PaisNuevo		varchar(50),
@PaisAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @PersonalI = Personal, @NombreNuevo    = ISNULL(RTRIM(ApellidoPaterno), '')+' '+ISNULL(RTRIM(ApellidoMaterno), '')+' '+ISNULL(RTRIM(Nombre), ''), @RFCNuevo = Registro2,    @CURPNuevo = Registro,    @SDINuevo = SDI,    @Registro = NULLIF(NULLIF(RTRIM(Registro), ''), '0'), @Registro2 = NULLIF(NULLIF(RTRIM(Registro2), ''), '0'), @Registro3 = NULLIF(NULLIF(RTRIM(Registro3), ''), '0'), @EmpresaNuevo = Empresa  FROM Inserted
SELECT @PersonalD = Personal, @NombreAnterior = ISNULL(RTRIM(ApellidoPaterno), '')+' '+ISNULL(RTRIM(ApellidoMaterno), '')+' '+ISNULL(RTRIM(Nombre), ''), @RFCAnterior = Registro2, @CURPAnterior = Registro, @SDIAnterior = SDI, @EmpresaAnterior = Empresa   FROM Deleted
/*IF @NombreNuevo <> @NombreAnterior OR @RFCNuevo <> @RFCAnterior OR @CURPNuevo <> @CURPAnterior*/
SELECT @PaisNuevo    = Pais FROM Empresa WHERE Empresa = @EmpresaNuevo
SELECT @PaisAnterior = Pais FROM Empresa WHERE Empresa = @EmpresaAnterior
IF @PaisNuevo = 'México' SELECT @PaisNuevo ='Mexico'
IF @PaisAnterior = 'México' SELECT @PaisAnterior ='Mexico'
IF EXISTS (SELECT Pais FROM PersonalPropPais WHERE Pais = 'México')
UPDATE PersonalPropPais SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Empresa WHERE Pais = 'México')
UPDATE Empresa SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Sucursal WHERE Pais = 'México')
UPDATE Sucursal SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Personal WHERE Pais = 'México')
UPDATE Personal SET Pais = 'Mexico'
IF @SDINuevo<>@SDIAnterior AND @SDIAnterior IS NOT NULL AND @PersonalI IS NOT NULL
UPDATE Personal SET SDIAnterior = @SDIAnterior WHERE Personal = @PersonalI
IF @PersonalI IS NOT NULL AND exists(select * from empresa where Empresa=@EmpresaNuevo AND Pais='Mexico')
BEGIN
SELECT @PersonalDup = NULL
IF @Registro  IS NOT NULL
BEGIN
SELECT @PersonalDup = MIN(Personal) FROM Personal WHERE Registro  = @Registro  AND Personal <> @PersonalI
IF @PersonalDup IS NOT NULL SELECT @RegistroDup = 'CURP - '+@Registro
END
IF @Registro2 IS NOT NULL
BEGIN
SELECT @PersonalDup = MIN(Personal) FROM Personal WHERE Registro2 = @Registro2 AND Personal <> @PersonalI
IF @PersonalDup IS NOT NULL SELECT @RegistroDup = 'RFC - '+@Registro2
END
IF @Registro3 IS NOT NULL
BEGIN
SELECT @PersonalDup = MIN(Personal) FROM Personal WHERE Registro3 = @Registro3 AND Personal <> @PersonalI
IF @PersonalDup IS NOT NULL SELECT @RegistroDup = 'IMSS - '+@Registro3
END
IF @PersonalDup IS NOT NULL
BEGIN
SELECT @Mensaje = 'Error al Actualizar a "'+@PersonalI+'", la clave del "'+@RegistroDup+'", ya Existe en la Persona "'+LTRIM(RTRIM(@PersonalDup))+ '".'
RAISERROR (@Mensaje,16,-1)
END
END
IF @PersonalI = @PersonalD AND @PaisNuevo <> @PaisAnterior
BEGIN
DELETE PersonalPropValor WHERE Rama = 'PER' AND Cuenta = @PersonalI
INSERT PersonalPropValor (Propiedad, Rama, Cuenta) SELECT p.Propiedad, 'PER', @PersonalI FROM PersonalProp p JOIN PersonalPropPais pp ON pp.Propiedad = p.Propiedad AND pp.Pais = @PaisNuevo WHERE p.NivelPersonal = 1
END
IF @PersonalI = @PersonalD RETURN
IF @PersonalD IS NULL
BEGIN
DELETE PersonalPropValor WHERE Rama = 'PER' AND Cuenta = @PersonalI
INSERT PersonalPropValor (Propiedad, Rama, Cuenta, Valor) SELECT p.Propiedad, 'PER', @PersonalI, p.PorOmision FROM PersonalProp p JOIN PersonalPropPais pp ON pp.Propiedad = p.Propiedad AND pp.Pais = @PaisNuevo WHERE p.NivelPersonal = 1
INSERT PersonalCfg (Personal) VALUES (@PersonalI)
END ELSE
IF @PersonalI IS NULL
BEGIN
DELETE PersonalPropValor  WHERE Rama = 'PER' AND Cuenta = @PersonalD
DELETE PersonalTarjeta    WHERE Personal = @PersonalD
DELETE PersonalUltimoPago WHERE Personal = @PersonalD
DELETE PersonalSuc 	      WHERE Personal = @PersonalD
DELETE PersonalAcceso     WHERE Personal = @PersonalD
DELETE PersonalCfg        WHERE Personal = @PersonalD
DELETE CtoCampoExtra      WHERE Tipo     = 'Personal' AND Clave = @PersonalD
DELETE FormaExtraValor    WHERE Aplica   = 'Personal' AND AplicaClave = @PersonalD
DELETE FormaExtraD        WHERE Aplica   = 'Personal' AND AplicaClave = @PersonalD
END ELSE
IF @PersonalI <> @PersonalD AND @PersonalI IS NOT NULL
BEGIN
UPDATE PersonalPropValor  SET Cuenta   = @PersonalI WHERE Rama = 'PER' AND Cuenta = @PersonalD
UPDATE PersonalTarjeta    SET Personal = @PersonalI WHERE Personal = @PersonalD
UPDATE PersonalUltimoPago SET Personal = @PersonalI WHERE Personal = @PersonalD
UPDATE PersonalSuc 	      SET Personal = @PersonalI WHERE Personal = @PersonalD
UPDATE PersonalAcceso     SET Personal = @PersonalI WHERE Personal = @PersonalD
UPDATE PersonalCfg        SET Personal = @PersonalI WHERE Personal = @PersonalD
UPDATE CtoCampoExtra	  SET Clave   = @PersonalI WHERE Clave   = @PersonalD AND Tipo='Personal'
UPDATE FormaExtraValor	  SET AplicaClave   = @PersonalI WHERE AplicaClave   = @PersonalD AND Aplica='Personal'
UPDATE FormaExtraD	      SET AplicaClave   = @PersonalI WHERE AplicaClave   = @PersonalD AND Aplica='Personal'
END ELSE RETURN
END

