SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxAutoAplicacion
@Sucursal			int,
@Empresa			char(5),
@Modulo			char(5),
@ID				int,
@Mov			char(20),
@MovID			varchar(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@Contacto			char(10),
@ContactoMoneda		char(10),
@ContactoFactor		float,
@ContactoTipoCambio		float,
@ImporteTotal		money,
@Accion			char(20),
@FechaEmision		datetime,
@Referencia			varchar(50),
@Condicion			varchar(50),
@Vencimiento		datetime,
@Proyecto			varchar(50),
@Usuario			char(15),
@CfgAplicaAutoOrden		char(20),
@CfgMovCargoDiverso		char(20),
@CfgMovCreditoDiverso	char(20),
@Ok 			int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@AplicaMov     	char(20),
@AplicaMovTipo	char(20),
@AplicaMovID	varchar(20),
@Saldo		money,
@Suma		money,
@Requiere		money,
@Obtenido		money,
@Efectivo		money,
@DiversoID		int,
@DiversoMov		char(20),
@DiversoMovID	varchar(20),
@DiversoEfectivo	money,
@IDGenerar		int,
@Renglon		float,
@ContactoEfectivo	money
IF @Modulo = 'CXC'
BEGIN
IF @CfgAplicaAutoOrden = 'FECHA VENCIMIENTO' DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxcPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Cliente = @Contacto ORDER BY Vencimiento ASC
IF @CfgAplicaAutoOrden = 'FECHA EMISION'     DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxcPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Cliente = @Contacto ORDER BY FechaEmision ASC
IF @CfgAplicaAutoOrden = 'CONSECUTIVO'       DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxcPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Cliente = @Contacto ORDER BY Mov, MovID ASC
IF @CfgAplicaAutoOrden = 'SALDO MENOR'       DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxcPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Cliente = @Contacto ORDER BY Saldo ASC
IF @CfgAplicaAutoOrden = 'SALDO MAYOR'       DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxcPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Cliente = @Contacto ORDER BY Saldo DESC
END ELSE
IF @Modulo = 'CXP'
BEGIN
IF @CfgAplicaAutoOrden = 'FECHA VENCIMIENTO' DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxpPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Proveedor = @Contacto ORDER BY Vencimiento ASC
IF @CfgAplicaAutoOrden = 'FECHA EMISION'     DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxpPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Proveedor = @Contacto ORDER BY FechaEmision ASC
IF @CfgAplicaAutoOrden = 'CONSECUTIVO'       DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxpPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Proveedor = @Contacto ORDER BY Mov, MovID ASC
IF @CfgAplicaAutoOrden = 'SALDO MENOR'       DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxpPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Proveedor = @Contacto ORDER BY Saldo ASC
IF @CfgAplicaAutoOrden = 'SALDO MAYOR'       DECLARE crCxAutoAplicaRen CURSOR FOR SELECT NULLIF(RTRIM(Mov), ''), MovID, ISNULL(Saldo, 0.0) FROM CxpPendiente WHERE Empresa = @Empresa AND Moneda = @ContactoMoneda AND Proveedor = @Contacto ORDER BY Saldo DESC
END
SELECT @Suma = 0.0, @Renglon = 0
OPEN crCxAutoAplicaRen
FETCH NEXT FROM crCxAutoAplicaRen INTO @AplicaMov, @AplicaMovID, @Saldo
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT @AplicaMovTipo = Clave FROM MovTipo WHERE Mov = @AplicaMov AND Modulo = @Modulo
IF @@FETCH_STATUS <> -2 AND @Saldo > 0.0 AND @AplicaMovTipo NOT IN ('CXC.A','CXC.DP','CXC.NC','CXC.NCD','CXC.NCF','CXC.DV','CXC.NCP','CXC.SD','CXC.SCH', 'CXP.A','CXP.DP','CXP.NC','CXP.NCD','CXP.NCF','CXP.NCP','CXP.SD','CXP.SCH')
BEGIN
SELECT @Saldo = @Saldo * @ContactoFactor
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Requiere = @ImporteTotal - @Suma
IF @Requiere < @Saldo
SELECT @Obtenido = @Requiere  	
ELSE
SELECT @Obtenido = @Saldo	
IF @Obtenido > 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048
IF @Modulo = 'CXC' INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe) VALUES (@Sucursal, @ID, @Renglon, 0, @AplicaMov, @AplicaMovID, @Obtenido) ELSE
IF @Modulo = 'CXP' INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe) VALUES (@Sucursal, @ID, @Renglon, 0, @AplicaMov, @AplicaMovID, @Obtenido)
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Suma = @Suma + @Obtenido
IF @Suma = @ImporteTotal BREAK
END
END 
FETCH NEXT FROM crCxAutoAplicaRen INTO @AplicaMov, @AplicaMovID, @Saldo
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crCxAutoAplicaRen
DEALLOCATE crCxAutoAplicaRen
RETURN
END

