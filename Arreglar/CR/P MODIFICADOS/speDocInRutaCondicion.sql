SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInRutaCondicion
@XML                    varchar(max),
@Operando1              varchar(max),
@Operador               varchar(50),
@Operando2              varchar(max),
@Origen                 varchar(max),
@Empresa                varchar(5),
@Existe                 bit = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
IF @Operador = 'ES EL NODO PRINCIPAL'
BEGIN
EXEC speDocInNodoPrincipal @XML,@Operando1,@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'SI EXISTE'
BEGIN
EXEC speDocInAtributoExiste @XML,@Operando1,@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES IGUAL A'
BEGIN
EXEC speDocInAtributoValorVerificar @XML,@Operando1,@Operando2,'IGUAL QUE',@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES MAYOR QUE'
BEGIN
EXEC speDocInAtributoValorVerificar @XML,@Operando1,@Operando2,'MAYOR QUE',@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES MENOR QUE'
BEGIN
EXEC speDocInAtributoValorVerificar @XML,@Operando1,@Operando2,'MENOR QUE',@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES MAYOR O IGUAL QUE'
BEGIN
EXEC speDocInAtributoValorVerificar @XML,@Operando1,@Operando2,'MAYOR O IGUAL QUE',@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES DIFERENTE QUE'
BEGIN
EXEC speDocInAtributoValorVerificar @XML,@Operando1,@Operando2,'DIFERENTE QUE',@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES MENOR O IGUAL QUE'
BEGIN
EXEC speDocInAtributoValorVerificar @XML,@Operando1,@Operando2,'MENOR O IGUAL QUE',@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'CONTIENE EL TEXTO'
BEGIN
EXEC speDocInTextoVerificar @XML,@Operando1,@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES EL NAME SPACE POR OMISION'
BEGIN
EXEC speDocInNSOmision @XML,@Operando1,@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'ES UN NAMESPACE VALIDO'
BEGIN
EXEC speDocInNSValido @XML,@Operando1,@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'DENTRO DE LA TABLA'
BEGIN
EXEC speDocInDentroTabla @XML,@Operando1,@Operando2, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Operador = 'CFD VALIDO'
BEGIN
EXEC speDocInCFDValido @XML,@Operando1, @Origen, @Empresa, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Existe = 0
SELECT @Ok = 72362, @OkRef =  '('+@Origen+') '
END
IF @Operador = 'XML VALIDO'
BEGIN
EXEC speDocINXMLValido  @XML,@Operando1,@Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NOT NULL SET @OkRef =  '('+@Operador+') ' +@OkRef
END

