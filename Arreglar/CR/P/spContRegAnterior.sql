SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContRegAnterior
@Empresa char(5),
@ContID	int = NULL
 
AS BEGIN
DECLARE
@Ok   		int,
@OkRef  		varchar(255),
@ContMov  		varchar(20),
@ContMovID		varchar(20),
@ContMovTipo	varchar(20),
@Ejercicio		int,
@Periodo		int,
@Modulo  		varchar(10),
@ID   		int,
@Mov  		varchar(20),
@MovID  		varchar(20),
@Conteo		int,
@Contacto		varchar(10),
@ContactoTipo	varchar(20)
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
DECLARE crCont CURSOR FOR
SELECT ID, Mov, MovID, Ejercicio, Periodo, OrigenTipo, Origen, NULLIF(RTRIM(OrigenID), ''), NULLIF(RTRIM(Contacto), ''), NULLIF(RTRIM(ContactoTipo), '')
FROM Cont
WHERE Empresa = @Empresa AND Estatus = 'CONCLUIDO' AND OrigenID IS NOT NULL AND ID = ISNULL(@ContID, ID)
OPEN crCont
FETCH NEXT FROM crCont INTO @ContID, @ContMov, @ContMovID, @Ejercicio, @Periodo, @Modulo, @Mov, @MovID, @Contacto, @ContactoTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT @ContMovTipo = NULL
SELECT @ContMovTipo = mt.Clave FROM MovTipo mt WHERE Modulo = 'CONT' AND Mov = @ContMov
IF @@FETCH_STATUS <> -2 AND @ContMovTipo IN ('CONT.P', 'CONT.C') AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM ContReg WHERE ID = @ContID)
BEGIN
SELECT @ID = NULL
SELECT @ID =  dbo.fnModuloIDContRegAnterior(@Empresa, @Modulo, @Mov, @MovID, @Ejercicio, @Periodo)
IF @ID IS NOT NULL
BEGIN
IF @Modulo = 'DIN' AND @Contacto IS NOT NULL AND @ContactoTipo IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM Dinero WHERE ID = @ID AND Contacto IS NULL AND ContactoTipo IS NULL)
UPDATE Dinero SET Contacto = @Contacto, ContactoTipo = @ContactoTipo WHERE ID = @ID
END
EXEC spMovReg @Modulo, @ID
INSERT ContReg (
ID, Empresa,  Sucursal,         Modulo,  ModuloID, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe, Haber)
SELECT ID, @Empresa, SucursalContable, @Modulo, @ID,      Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe, Haber
FROM ContD
WHERE ID = @ContID
SELECT @Conteo = @Conteo + 1
END
END
END
FETCH NEXT FROM crCont INTO @ContID, @ContMov, @ContMovID, @Ejercicio, @Periodo, @Modulo, @Mov, @MovID, @Contacto, @ContactoTipo
END
CLOSE crCont
DEALLOCATE crCont
SELECT CONVERT(varchar, @Conteo)+' Polizas Modificadas'
RETURN
END

