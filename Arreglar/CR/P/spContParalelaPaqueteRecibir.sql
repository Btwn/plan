SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalelaPaqueteRecibir
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@IDEmpresa			int,
@CONTEsCancelacion	bit,
@Ok					int			 OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
BEGIN TRY
UPDATE #Cont
SET Transformada = 1
FROM #Cont
JOIN ContParalelaPoliza ON ContParalelaPoliza.ID = #Cont.ID AND ContParalelaPoliza.IDEmpresa = @IDEmpresa AND #Cont.Estatus = ContParalelaPoliza.Estatus
WHERE ContParalelaPoliza.CPPolizaID IS NOT NULL
DELETE ContParalelaPoliza
FROM ContParalelaPoliza
JOIN #Cont ON ContParalelaPoliza.ID = #Cont.ID AND ContParalelaPoliza.IDEmpresa = @IDEmpresa AND #Cont.Estatus = ContParalelaPoliza.Estatus
WHERE CPPolizaID IS NULL
DELETE ContParalelaPolizaD
FROM ContParalelaPolizaD
JOIN ContParalelaPoliza ON ContParalelaPolizaD.IDEmpresa = ContParalelaPoliza.IDEmpresa AND ContParalelaPolizaD.ID = ContParalelaPoliza.ID
JOIN #ContD ON ContParalelaPolizaD.ID = #ContD.ID AND ContParalelaPolizaD.IDEmpresa = @IDEmpresa
JOIN #Cont  ON #ContD.ID = #Cont.ID AND #Cont.Transformada = 0 AND #Cont.Estatus = ContParalelaPoliza.Estatus
DELETE ContParalelaPolizaOrigen
FROM ContParalelaPolizaOrigen
JOIN #Origen ON ContParalelaPolizaOrigen.ID = #Origen.ContID AND ContParalelaPolizaOrigen.IDEmpresa = @IDEmpresa
JOIN #Cont   ON #Origen.ContID = #Cont.ID AND #Cont.Transformada = 0
INSERT INTO ContParalelaPoliza(
IDEmpresa, ID, Empresa, Mov, MovID, FechaEmision, FechaContable, Concepto, Proyecto, UEN, Contacto, ContactoTipo, Moneda, TipoCambio, Usuario, Referencia, Estatus, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, Sucursal, Importe, RecepcionFecha, RecepcionMoneda, RecepcionTipoCambio, OrigenMoneda, OrigenTipoCambio,  CONTEsCancelacion)
SELECT @IDEmpresa, ID, Empresa, Mov, MovID, FechaEmision, FechaContable, Concepto, Proyecto, UEN, Contacto, ContactoTipo, Moneda, TipoCambio, Usuario, Referencia, Estatus, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, Sucursal, Importe, RecepcionFecha, RecepcionMoneda, RecepcionTipoCambio, OrigenMoneda, OrigenTipoCambio, @CONTEsCancelacion
FROM #Cont
WHERE Transformada = 0
INSERT INTO ContParalelaPolizaD(
IDEmpresa, ID,        Renglon,        RenglonSub,        Cuenta,        Debe,        Haber,         CONTEsCancelacion)
SELECT @IDEmpresa, #ContD.ID, #ContD.Renglon, #ContD.RenglonSub, #ContD.Cuenta, #ContD.Debe, #ContD.Haber, @CONTEsCancelacion
FROM #ContD
JOIN #Cont  ON #ContD.ID = #Cont.ID AND #Cont.Transformada = 0
INSERT INTO ContParalelaPolizaOrigen(
IDEmpresa, ID,             IDOrigen,   Mov,         MovID,         FechaEmision,         Concepto,         Proyecto,         UEN,         Moneda,         TipoCambio,         Usuario,         Referencia,         Estatus,         ContactoTipo,         Contacto,         Almacen,         Condicion,         Vencimiento,         Importe,         Impuestos,         Ejercicio,         Periodo,         MovTipo,         SubMovTipo,         Modulo)
SELECT @IDEmpresa, #Origen.ContID, #Origen.ID, #Origen.Mov, #Origen.MovID, #Origen.FechaEmision, #Origen.Concepto, #Origen.Proyecto, #Origen.UEN, #Origen.Moneda, #Origen.TipoCambio, #Origen.Usuario, #Origen.Referencia, #Origen.Estatus, #Origen.ContactoTipo, #Origen.Contacto, #Origen.Almacen, #Origen.Condicion, #Origen.Vencimiento, #Origen.Importe, #Origen.Impuestos, #Origen.Ejercicio, #Origen.Periodo, #Origen.MovTipo, #Origen.SubMovTipo, #Origen.Modulo
FROM #Origen
JOIN #Cont   ON #Origen.ContID = #Cont.ID AND #Cont.Transformada = 0
UPDATE ContParalelaPolizaContacto
SET Nombre				= #Contacto.Nombre,
Direccion			= #Contacto.Direccion,
DireccionNumero		= #Contacto.DireccionNumero,
DireccionNumeroInt	= #Contacto.DireccionNumeroInt,
EntreCalles			= #Contacto.EntreCalles,
Delegacion			= #Contacto.Delegacion,
Colonia				= #Contacto.Colonia,
Poblacion			= #Contacto.Poblacion,
Estado				= #Contacto.Estado,
Pais					= #Contacto.Pais,
CodigoPostal			= #Contacto.CodigoPostal,
RFC					= #Contacto.RFC,
CURP					= #Contacto.CURP,
Categoria			= #Contacto.Categoria,
Grupo				= #Contacto.Grupo,
Familia				= #Contacto.Familia
FROM ContParalelaPolizaContacto
JOIN #Contacto ON ContParalelaPolizaContacto.ContactoTipo = #Contacto.ContactoTipo AND ContParalelaPolizaContacto.Contacto = #Contacto.Contacto AND ContParalelaPolizaContacto.IDEmpresa = @IDEmpresa
INSERT INTO ContParalelaPolizaContacto(
IDEmpresa, ContactoTipo, Contacto, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, RFC, CURP, Categoria, Grupo, Familia)
SELECT @IDEmpresa, ContactoTipo, Contacto, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, RFC, CURP, Categoria, Grupo, Familia
FROM #Contacto
WHERE Contacto NOT IN(SELECT Contacto FROM ContParalelaPolizaContacto WHERE IDEmpresa = @IDEmpresa AND ContactoTipo = #Contacto.ContactoTipo)
UPDATE ContParalelaD
SET PolizaEstatus = 'Registrada'
FROM ContParalelaD
JOIN ContParalelaPoliza ON ContParalelaD.ContID = ContParalelaPoliza.ID AND ContParalelaPoliza.IDEmpresa = @IDEmpresa
WHERE ContParalelaD.ID = @ID
AND ContParalelaPoliza.CPPolizaID IS NULL
UPDATE ContParalelaD
SET PolizaEstatus = 'Transformada'
FROM ContParalelaD
JOIN ContParalelaPoliza ON ContParalelaD.ContID = ContParalelaPoliza.ID AND ContParalelaPoliza.IDEmpresa = @IDEmpresa
WHERE ContParalelaD.ID = @ID
AND ContParalelaPoliza.CPPolizaID IS NOT NULL
UPDATE ContParalelaD
SET PolizaEstatus = 'No Registrada'
WHERE ContParalelaD.ID = @ID
AND PolizaEstatus IS NULL
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
RETURN
END CATCH
RETURN
END

