SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWSRecibirCompraAutoEndoso
@ixml		int,
@Version	float,
@Accion		varchar(20),
@Ok 		int		OUTPUT,
@OkRef 		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@FechaRegistro		datetime,
@Mov			varchar(20),
@MovID			varchar(20),
@IDGenerar			int,
@EndosoID			int,
@Origen			varchar(20),
@OrigenID			varchar(20),
@Empresa			varchar(10),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@Cliente			varchar(10),
@Referencia 		varchar(50),
@ProvNombre 		varchar(100),
@ProvNombreCorto 		varchar(20),
@ProvDireccion 		varchar(100),
@ProvEntreCalles 		varchar(100),
@ProvPlano 			varchar(15),
@ProvObservaciones 		varchar(100),
@ProvDelegacion 		varchar(100),
@ProvColonia 		varchar(100),
@ProvPoblacion 		varchar(100),
@ProvEstado 		varchar(30),
@ProvZona 			varchar(30),
@ProvPais 			varchar(30),
@ProvCodigoPostal 		varchar(15),
@ProvTelefonos 		varchar(100),
@ProvFax			varchar(50),
@ProvContacto1 		varchar(50),
@ProvContacto2 		varchar(50),
@ProvExtencion1 		varchar(10),
@ProvExtencion2 		varchar(10),
@ProveMail1 		varchar(50),
@ProveMail2 		varchar(50),
@ProvRFC 			varchar(15),
@ProvCURP 			varchar(30),
@ProvBeneficiarioNombre 	varchar(100),
@ProvLeyendaCheque		varchar(100),
@ProvOrigen			varchar(20),
@ProvOrigenID		varchar(20)
SELECT @FechaRegistro = GETDATE()
SELECT @Empresa = Endoso, @Proveedor = Proveedor, @Cliente = Empresa, @Origen = Mov, @OrigenID = MovID
FROM OPENXML (@ixml, 'Intelisis/Movimiento')
WITH (Empresa varchar(10), Endoso varchar(10), Proveedor varchar(10), Mov varchar(20), MovID varchar(20))
SELECT @Sucursal = 0, @Mov = @Origen
SELECT @Mov = ISNULL(MovDestino, @Mov) FROM CteMapeoMov WHERE Cliente = @Cliente AND MovOrigen = @Mov
SELECT @ProvOrigen = @Cliente, @ProvOrigenID = @Proveedor
IF NOT EXISTS(SELECT * FROM Empresa WHERE Empresa = @Empresa AND Estatus = 'ALTA')
SELECT @Ok = 26070, @OkRef = @Empresa
IF @Ok IS NULL
BEGIN
SELECT @Usuario = DefUsuario FROM EmpresaGral WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM Usuario WHERE Usuario = @Usuario AND Estatus = 'ALTA')
SELECT @Ok = 71020, @OkRef = @Usuario
END
IF @Ok IS NULL
BEGIN
SELECT @ProvNombre = Nombre, @ProvNombreCorto = NombreCorto, @ProvDireccion = Direccion, @ProvEntreCalles = EntreCalles, @ProvPlano = Plano, @ProvObservaciones = Observaciones, @ProvDelegacion = Delegacion, @ProvColonia = Colonia, @ProvPoblacion = Poblacion,
@ProvEstado = Estado, @ProvZona = Zona, @ProvPais = Pais, @ProvCodigoPostal = CodigoPostal, @ProvTelefonos = Telefonos, @ProvFax = Fax,
@ProvContacto1 = Contacto1, @ProvContacto2 = Contacto2, @ProvExtencion1 = Extencion1, @ProvExtencion2 = Extencion2, @ProveMail1 = eMail1, @ProveMail2 = eMail2, @ProvRFC = RFC, @ProvCURP = CURP, @ProvBeneficiarioNombre = BeneficiarioNombre, @ProvLeyendaCheque = LeyendaCheque
FROM OPENXML (@ixml, 'Intelisis/Movimiento/Proveedor')
WITH (Nombre varchar(100), NombreCorto varchar(20), Direccion varchar(100), EntreCalles varchar(100), Plano varchar(15), Observaciones varchar(100), Delegacion varchar(100),
Colonia varchar(100), Poblacion varchar(100), Estado varchar(30), Zona varchar(30), Pais varchar(30), CodigoPostal varchar(15), Telefonos varchar(100), Fax varchar(50),
Contacto1 varchar(50), Contacto2 varchar(50), Extencion1 varchar(10), Extencion2 varchar(10), eMail1 varchar(50), eMail2 varchar(50), RFC varchar(15), CURP varchar(30),
BeneficiarioNombre varchar(100), LeyendaCheque varchar(100))
SELECT @Proveedor = NULL
SELECT @Proveedor = MIN(Proveedor)
FROM Prov
WHERE Origen = @ProvOrigen AND OrigenID = @ProvOrigenID
IF @Proveedor IS NULL
BEGIN
EXEC spConsecutivo @Cliente, 0, @Proveedor OUTPUT
IF @Proveedor IS NULL
SELECT @Ok = 53040, @OkRef = @Cliente
ELSE
INSERT Prov (
Proveedor,  Nombre,      NombreCorto,      Direccion,      EntreCalles,      Plano,      Observaciones,      Delegacion,      Colonia,      Poblacion,      Estado,      Zona,      Pais,      CodigoPostal,      Telefonos,      Fax,      Contacto1,      Contacto2,      Extencion1,      Extencion2,      eMail1,      eMail2,      RFC,      CURP,      BeneficiarioNombre,      LeyendaCheque,      Estatus, Origen,      OrigenID)
VALUES (@Proveedor, @ProvNombre, @ProvNombreCorto, @ProvDireccion, @ProvEntreCalles, @ProvPlano, @ProvObservaciones, @ProvDelegacion, @ProvColonia, @ProvPoblacion, @ProvEstado, @ProvZona, @ProvPais, @ProvCodigoPostal, @ProvTelefonos, @ProvFax, @ProvContacto1, @ProvContacto2, @ProvExtencion1, @ProvExtencion2, @ProveMail1, @ProveMail2, @ProvRFC, @ProvCURP, @ProvBeneficiarioNombre, @ProvLeyendaCheque, 'ALTA',  @ProvOrigen, @ProvOrigenID)
END ELSE
UPDATE Prov
SET Nombre = @ProvNombre,
NombreCorto = @ProvNombreCorto,
Direccion = @ProvDireccion,
EntreCalles = @ProvEntreCalles,
Plano = @ProvPlano,
Observaciones = @ProvObservaciones,
Delegacion = @ProvDelegacion,
Colonia = @ProvColonia,
Poblacion = @ProvPoblacion,
Estado = @ProvEstado,
Zona = @ProvZona,
Pais = @ProvPais,
CodigoPostal = @ProvCodigoPostal,
Telefonos = @ProvTelefonos,
Fax = @ProvFax,
Contacto1 = @ProvContacto1,
Contacto2 = @ProvContacto2,
Extencion1 = @ProvExtencion1,
Extencion2 = @ProvExtencion2,
eMail1 = @ProveMail1,
eMail2 = @ProveMail2,
RFC = @ProvRFC,
CURP = @ProvCURP,
BeneficiarioNombre = @ProvBeneficiarioNombre,
LeyendaCheque = @ProvLeyendaCheque
WHERE Proveedor = @Proveedor
END
IF @Ok IS NULL AND @Accion = 'AFECTAR'
BEGIN
IF EXISTS(SELECT * FROM Cxp WHERE Empresa = @Empresa AND Proveedor = @Proveedor AND OrigenTipo = 'ENDOSO' AND Origen = @Origen AND OrigenID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
SELECT @Ok = 20917, @OkRef = @Origen + ' ' + @OrigenID + ' (Cuentas por Pagar)'
ELSE
IF EXISTS(SELECT * FROM Cxc WHERE Empresa = @Empresa AND Cliente = @Cliente AND OrigenTipo = 'ENDOSO' AND Origen = @Origen AND OrigenID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
SELECT @Ok = 20917, @OkRef = @Origen + ' ' + @OrigenID + ' (Cuentas por Cobrar)'
END
IF @Ok IS NULL
BEGIN
SELECT @EndosoID = NULL
IF @Accion = 'CANCELAR'
SELECT @EndosoID = MIN(ID) FROM Cxp WHERE Empresa = @Empresa AND Proveedor = @Proveedor AND OrigenTipo = 'ENDOSO' AND Origen = @Origen AND OrigenID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE BEGIN
INSERT INTO Cxp
(Sucursal, Empresa, Mov, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus, UltimoCambio,
Proveedor, ProveedorMoneda, ProveedorTipoCambio, Condicion, Vencimiento, Importe, Impuestos, Retencion, Retencion2, Retencion3,
OrigenTipo, Origen, OrigenID, IVAFiscal, IEPSFiscal)
SELECT @Sucursal, @Empresa, @Mov, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, @Usuario, Referencia, Observaciones, 'SINAFECTAR', @FechaRegistro,
@Proveedor, Moneda, TipoCambio, '(Fecha)', Vencimiento, Importe, Impuestos, Retencion, Retencion2, Retencion3,
'ENDOSO', @Origen, @OrigenID, IVAFiscal, IEPSFiscal
FROM OPENXML (@ixml, 'Intelisis/Movimiento')
WITH (FechaEmision datetime, Concepto varchar(50), Referencia varchar(50), Proyecto varchar(50), Moneda varchar(10), TipoCambio float, Vencimiento datetime, Importe money, Impuestos money, Retencion money, Retencion2 money, Retencion3 money, IVAFiscal float, IEPSFiscal float, Observaciones varchar(100))
SELECT @EndosoID = SCOPE_IDENTITY()
END
IF @EndosoID IS NOT NULL
EXEC spCx @EndosoID, 'CXP', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @EndosoID = NULL
IF @Accion = 'CANCELAR'
SELECT @EndosoID = MIN(ID) FROM Cxc WHERE Empresa = @Empresa AND Cliente = @Cliente AND OrigenTipo = 'ENDOSO' AND Origen = @Origen AND OrigenID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE BEGIN
INSERT INTO Cxc
(Sucursal, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus, UltimoCambio,
Cliente, ClienteMoneda, ClienteTipoCambio, Condicion, Vencimiento, Importe, Impuestos, Retencion,
OrigenTipo, Origen, OrigenID, IVAFiscal, IEPSFiscal)
SELECT @Sucursal, @Empresa, @Mov, @MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, @Usuario, Referencia, Observaciones, 'SINAFECTAR', @FechaRegistro,
@Cliente, Moneda, TipoCambio, '(Fecha)', Vencimiento, Importe, Impuestos, Retencion,
'ENDOSO', @Origen, @OrigenID, IVAFiscal, IEPSFiscal
FROM OPENXML (@ixml, 'Intelisis/Movimiento')
WITH (FechaEmision datetime, Concepto varchar(50), Referencia varchar(50), Proyecto varchar(50), Moneda varchar(10), TipoCambio float, Vencimiento datetime, Importe money, Impuestos money, Retencion money, Retencion2 money, Retencion3 money, IVAFiscal float, IEPSFiscal float, Observaciones varchar(100))
SELECT @EndosoID = SCOPE_IDENTITY()
END
IF @EndosoID IS NOT NULL
EXEC spCx @EndosoID, 'CXC', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

