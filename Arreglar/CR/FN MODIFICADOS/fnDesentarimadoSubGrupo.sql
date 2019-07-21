SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDesentarimadoSubGrupo (@Aplica varchar(20), @AplicaID varchar(20), @Empresa char(5), @Mov varchar(20), @Grupo varchar(20), @SubGrupo varchar(20))
RETURNS varchar(20)
AS
BEGIN
DECLARE
@WMS			bit,
@MovTipo		varchar(20),
@IDAplica		varchar(20),
@Aplica2		varchar(20),
@AplicaID2		varchar(20),
@IDAplica2		varchar(20)
SELECT @WMS = WMS FROM Alm WITH(NOLOCK) WHERE Almacen = @Grupo
SELECT @MovTipo = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'INV' AND Mov = @Mov
IF @WMS = 1 AND @MovTipo = 'INV.TMA' AND ISNULL(@SubGrupo,'') = ''
BEGIN
SELECT @IDAplica = ID FROM Inv WITH(NOLOCK) WHERE Mov = @Aplica AND MovID = @AplicaID AND Empresa = @Empresa
SELECT @Aplica2 = Origen, @AplicaID2 = OrigenID FROM Inv WITH(NOLOCK) WHERE ID = @IDAplica
SELECT @IDAplica2 = ID FROM Inv WITH(NOLOCK) WHERE Mov = @Aplica2 AND MovID = @AplicaID2 AND Empresa = @Empresa
SELECT @SubGrupo = ISNULL(Tarima,@SubGrupo) FROM InvD WITH(NOLOCK) WHERE ID = @IDAplica2 AND NULLIF(Tarima,'') IS NOT NULL
END
RETURN (@SubGrupo)
END

