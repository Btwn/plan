SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContRegSinOrigen
@Empresa char(5),
@ContID	int = NULL

AS BEGIN
DECLARE
@Ok   		int,
@OkRef  		varchar(255),
@ContMov  		varchar(20),
@ContMovID		varchar(20),
@ContMovTipo	varchar(20),
@Modulo  		varchar(10),
@ID   		int,
@Mov  		varchar(20),
@MovID  		varchar(20),
@Conteo		int
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
DECLARE crCont CURSOR FOR
SELECT ID, Mov, MovID
FROM Cont
WHERE Empresa = @Empresa AND Estatus = 'CONCLUIDO' AND NULLIF(RTRIM(OrigenID), '') IS NULL AND ID = ISNULL(@ContID, ID)
OPEN crCont
FETCH NEXT FROM crCont INTO @ContID, @ContMov, @ContMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT @ContMovTipo = NULL
SELECT @ContMovTipo = mt.Clave FROM MovTipo mt WHERE Modulo = 'CONT' AND Mov = @ContMov
IF @@FETCH_STATUS <> -2 AND @ContMovTipo IN ('CONT.P', 'CONT.C') AND @Ok IS NULL
BEGIN
DELETE ContReg WHERE ID = @ContID
DELETE MovReg  WHERE Modulo = 'CONT' AND ID = @ContID
EXEC spMovReg 'CONT', @ContID
INSERT ContReg (
ID, Empresa,  Sucursal,         Modulo,  ModuloID, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe, Haber)
SELECT ID, @Empresa, SucursalContable, 'CONT',  @ContID,  Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe, Haber
FROM ContD
WHERE ID = @ContID
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crCont INTO @ContID, @ContMov, @ContMovID
END
CLOSE crCont
DEALLOCATE crCont
SELECT CONVERT(varchar, @Conteo)+' Polizas Modificadas'
RETURN
END

