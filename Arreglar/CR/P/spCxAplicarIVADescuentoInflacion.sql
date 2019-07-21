SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxAplicarIVADescuentoInflacion
@ID		  			int,
@Accion				char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo				char(5),
@Mov				char(20),
@MovID				varchar(20),
@MovTipo   			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Ok					int		OUTPUT,
@OkRef 				varchar(255)	OUTPUT
 
AS BEGIN
DECLARE
@TipoCambioLog						float,
@Renglon							float,
@RenglonSub							int,
@AplicaID							int,
@AplicaMov							char(20),
@AplicaMovID						varchar(20),
@AplicaTipoCambio					float,
@AplicaOrdinariosIVAInflacion		float,
@OrdinariosIVAInflacion 			float,
@Sucursal							int,
@Rama								varchar(5),
@SubMovTipo							varchar(20),
@AplicaMoneda						varchar(10),
@AplicaContacto						varchar(10),
@EsCargo							bit,
@Ejercicio							int,
@Periodo							int
SELECT @SubMovTipo = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @Movtipo = 'CXC.INT' AND @SubMovTipo = 'CXC.INM'
SET @Rama = 'CIM'
ELSE IF @Movtipo = 'CXC.INT' AND @SubMovTipo <> 'CXC.INM'
SET @Rama = 'CIO'
ELSE IF @Movtipo = 'CXP.INT' AND @SubMovTipo = 'CXP.INM'
SET @Rama = 'PIM'
ELSE IF @Movtipo = 'CXP.INT' AND @SubMovTipo <> 'CXP.INM'
SET @Rama = 'PIO'
ELSE
SET @Rama = @Modulo
IF @Modulo = 'CXC' SELECT @Ejercicio = Ejercicio, @Periodo = Periodo, @Sucursal = Sucursal FROM Cxc WHERE ID = @ID ELSE
IF @Modulo = 'CXP' SELECT @Ejercicio = Ejercicio, @Periodo = Periodo, @Sucursal = Sucursal FROM Cxp WHERE ID = @ID
IF @Modulo = 'CXC' DECLARE crCxDetalle CURSOR LOCAL FOR SELECT Renglon, RenglonSub, Aplica, AplicaID, InteresesOrdinariosIVADescInfl*@MovTipoCambio FROM CxcD WHERE ID = @ID ELSE
IF @Modulo = 'CXP' DECLARE crCxDetalle CURSOR LOCAL FOR SELECT Renglon, RenglonSub, Aplica, AplicaID, InteresesOrdinariosIVADescInfl*@MovTipoCambio FROM CxpD WHERE ID = @ID
OPEN crCxDetalle
FETCH NEXT FROM crCxDetalle INTO @Renglon, @RenglonSub, @AplicaMov, @AplicaMovID, @AplicaOrdinariosIVAInflacion
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @AplicaID = NULL
IF @Modulo = 'CXC' SELECT @AplicaContacto = Cliente,   @AplicaID = ID, @AplicaMoneda = Moneda, @AplicaTipoCambio = TipoCambio FROM Cxc WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE') ELSE
IF @Modulo = 'CXP' SELECT @AplicaContacto = Proveedor, @AplicaID = ID, @AplicaMoneda = Moneda, @AplicaTipoCambio = TipoCambio FROM Cxp WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
IF @AplicaID IS NOT NULL
BEGIN
SELECT @OrdinariosIVAInflacion  = ISNULL(@AplicaOrdinariosIVAInflacion / @AplicaTipoCambio, 0.0)
SET @EsCargo = 0
IF @Accion = 'CANCELAR' SELECT @EsCargo = ~@EsCargo
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @AplicaMoneda, @AplicaTipoCambio, @AplicaContacto, NULL, NULL, NULL, 
@Modulo, @ID, @Mov, @MovID, @EsCargo, @OrdinariosIVAInflacion, NULL, NULL,
@FechaEmision, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'AFECTAR' SET @OrdinariosIVAInflacion = -@OrdinariosIVAInflacion
IF @OrdinariosIVAInflacion <> 0.0
BEGIN
IF @Modulo = 'CXC'
UPDATE Cxc
SET SaldoInteresesOrdinariosIVA = NULLIF(ISNULL(SaldoInteresesOrdinariosIVA, 0.0) + @OrdinariosIVAInflacion, 0.0)
WHERE ID = @AplicaID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp
SET SaldoInteresesOrdinariosIVA = NULLIF(ISNULL(SaldoInteresesOrdinariosIVA, 0.0) + @OrdinariosIVAInflacion, 0.0)
WHERE ID = @AplicaID
END
END
END
FETCH NEXT FROM crCxDetalle INTO @Renglon, @RenglonSub, @AplicaMov, @AplicaMovID, @AplicaOrdinariosIVAInflacion 
END 
CLOSE crCxDetalle
DEALLOCATE crCxDetalle
RETURN
END

