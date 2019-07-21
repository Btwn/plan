SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAviBuscaCxCVentaBonif
@MovIdCxc    varchar(20),
@MovCxc      varchar(20),
@IdMovResul  varchar(20) Output,
@MovResul    varchar(20) Output,
@IdOrigen    Int Output

AS BEGIN
DECLARE
@Tipo      Varchar(20),
@IdNvo     varchar(20),
@IdMovNvo  varchar(20),
@MovtipoNvo varchar(20),
@IdOrigenNvo  int,
@Aplica    varchar(20),
@AplicaID varchar(20),
@IDdetalle varchar(20),
@Contador  int ,
@ContadorD int
SELECT @Tipo = 'CxC', @IdNvo = @MovIdCxc, @IdMovNvo= @MovCxc, @Contador = 0, @ContadorD = 0, @MovtipoNvo = ''
WHILE @MovtipoNvo <> 'VTAS.F' AND @Contador < 10
BEGIN
SELECT @Tipo=OModulo, @IdMovNvo=OMov, @IdNvo=(OMovId),@IdOrigenNvo=mf.OID, @MovtipoNvo = Mt.Clave
FROM MovFlujo mf WITH(NOLOCK), Movtipo Mt WITH(NOLOCK) WHERE mf.OMov=Mt.Mov
AND mf.DMov = @IdMovNvo AND mf.DMovID = @IdNvo 
Order BY OMovId DESC
SELECT @Contador = @Contador + 1
END
IF @Contador > 10 SELECT @IdNvo = NULL, @IdMovNvo = NULL, @IdOrigenNvo = 0
SELECT @Aplica = Aplica, @AplicaID = AplicaID FROM CxcD WITH(NOLOCK) WHERE Id = @IdOrigen
IF NOT @AplicaID IS NULL
BEGIN
DECLARE crCxCCte CURSOR FOR
SELECT  Id FROM CXc WITH(NOLOCK) WHERE Mov = @Aplica AND MovId = @AplicaID
OPEN crCxCCte
FETCH NEXT FROM crCxCCte INTO @IdMovNvo
WHILE @MovtipoNvo <> 'VTAS.F'  AND @ContadorD < 10
BEGIN
SELECT @Tipo=OModulo, @IdMovNvo=OMov, @IdNvo=(OMovId),@IdOrigenNvo=mf.OID, @MovtipoNvo = Mt.Clave
FROM MovFlujo mf WITH(NOLOCK), Movtipo Mt WITH(NOLOCK)
WHERE mf.OMov = Mt.Mov
AND mf.DMov = @IdMovNvo AND mf.DMovID = @IdNvo
Order BY OMovId DESC
SELECT @ContadorD = @ContadorD + 1
FETCH NEXT FROM crCxCCte INTO @IdMovNvo
END
CLOSE crCxCCte
DEALLOCATE crCxCCte
END
SELECT @IdMovResul=@IdNvo, @MovResul=@IdMovNvo, @IdOrigen= @IdOrigenNvo
RETURN
End

