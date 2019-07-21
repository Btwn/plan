SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarPersonalPropValorSucursal
@Sucursal	int

AS BEGIN
IF NOT EXISTS(SELECT * FROM PersonalPropValor with(nolock)  WHERE Rama = 'SUC' AND Cuenta = @Sucursal )
BEGIN
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'# Defunciones Anuales','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'# Guia','54400')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'# SM ImpuestoEstatalExento',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'% Gasto Operacion (Impuesto Estatal)','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'% Impuesto Estatal','2')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'% Impuesto Nomina','2')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'% IMSS Patron Riesgo','0.5')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'% TasaAdicionalImpuestoEstatal',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'Acreedor Impuesto Estatal','00022')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'GastosOperacionImpuestoEstatal',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'Labora Domingos (S/N)','S')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('SUC',@Sucursal,'Registro Patronal','Y5442782107')
END
RETURN
END

