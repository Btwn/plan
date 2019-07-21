SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDFlexMonitorVista
(
@Modulo				varchar(5),
@ModuloID			Int,
@Empresa			varchar(20)
)
RETURNS bit

AS BEGIN
DECLARE
@Continuar			bit,
@OrigenTipo			varchar(200),
@Origen				varchar(200),
@MovID				varchar(200)
IF @Modulo IN ('VTAS', 'COMS', 'GAS')
Select @Continuar = 1
IF @Modulo = 'CXC'
Begin
SELECT @OrigenTipo = OrigenTipo, @Origen = Origen, @MovID = OrigenID FROM CXC WITH (NOLOCK) WHERE ID = @ModuloID AND Empresa = @Empresa
IF @OrigenTipo is null
Select @Continuar = 1
ELSE
Begin
IF (Select Timbrado From CFDFlex WITH (NOLOCK) Where Modulo = @OrigenTipo And MovID = @MovID) = 1
Select @Continuar = 0
ELSE
Select @Continuar = 1
End
End
IF @Modulo = 'CXP'
Begin
SELECT @OrigenTipo = OrigenTipo, @Origen = Origen, @MovID = OrigenID FROM CXP WITH (NOLOCK) WHERE ID = @ModuloID AND Empresa = @Empresa
IF @OrigenTipo is null
Select @Continuar = 1
ELSE
Begin
IF (Select Timbrado From CFDFlex WITH (NOLOCK) Where Modulo = @OrigenTipo And MovID = @MovID) = 1
Select @Continuar = 0
ELSE
Select @Continuar = 1
End
End
RETURN (@Continuar)
END

