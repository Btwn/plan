SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxAfectarClavePresupuestal
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Condicion			varchar(50),
@Vencimiento		datetime,
@FormaPago			varchar(50),
@ClienteProv		char(10),
@CPMoneda			char(10),
@CPFactor			float,
@CPTipoCambio		float,
@Importe			money,
@Impuestos			money,
@Saldo			money,
@CtaDinero			char(10),
@AplicaManual               bit,
@ConDesglose		bit,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@EstatusNuevo	      	char(15),
@MovAplica			char(20),
@MovAplicaID		varchar(20),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT,
@Estatus				varchar(15) = NULL

AS BEGIN
DECLARE
@OrigenTipo		char(5),
@Origen			varchar(20),
@Clave			varchar(20),
@OrigenID		varchar(20),
@IDOrigen		int,
@Proyecto		varchar(50),
@Concepto		varchar(50),
@Retencion 		money,
@Retencion2		money,
@Retencion3		money,
@ContUso		varchar(20),
@ContUso2		varchar(20),
@ContUso3		varchar(20)
IF @Modulo = 'CXC'
SELECT
@OrigenTipo	= OrigenTipo,
@Origen		= Origen,
@OrigenID		= OrigenID,
@Concepto		= Concepto,
@Retencion	= ISNULL(Retencion, 0.0),
@Retencion2	= ISNULL(Retencion2, 0.0),
@Retencion3	= ISNULL(Retencion3, 0.0),
@ContUso		= NULLIF(ContUso,''),
@ContUso2		= NULLIF(ContUso2,''),
@ContUso3		= NULLIF(ContUso3,'')
FROM Cxc
WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
SELECT
@OrigenTipo	= OrigenTipo,
@Origen		= Origen,
@OrigenID		= OrigenID,
@Concepto		= Concepto,
@Retencion	= ISNULL(Retencion, 0.0),
@Retencion2	= ISNULL(Retencion2, 0.0),
@Retencion3	= ISNULL(Retencion3, 0.0),
@ContUso		= NULLIF(ContUso,''),
@ContUso2		= NULLIF(ContUso2,''),
@ContUso3		= NULLIF(ContUso3,'')
FROM Cxp
WHERE ID = @ID
SELECT @Clave = Clave FROM MovTipo WHERE Modulo = @OrigenTipo AND Mov = @Origen
IF @OrigenTipo = 'NOM' AND @Clave = 'NOM.N'
BEGIN
SELECT @IDOrigen = ID FROM Nomina WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa
SELECT @Proyecto = Proyecto FROM Nomina WHERE ID = @IDOrigen
IF @Modulo = 'CXC'
UPDATE Cxc
SET Proyecto = @Proyecto
WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp
SET Proyecto = @Proyecto
WHERE ID = @ID
END
IF NOT EXISTS(SELECT * FROM MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID) AND @Ok IS NULL
INSERT MovImpuesto
(Modulo,  ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha,   Retencion1,                                Retencion2,                                Retencion3,                                Impuesto1,                                               Importe1,  SubTotal,  ContUso,  ContUso2,  ContUso3)
SELECT @Modulo, @ID,      @Modulo,      @ID,            @Concepto,      @FechaEmision, (@Retencion/NULLIF(@Importe, 0.0))*100.0, (@Retencion2/NULLIF(@Importe, 0.0))*100.0, (@Retencion3/NULLIF(@Importe, 0.0))*100.0,  ROUND(dbo.fnR3(NULLIF(@Importe, 0.0),100,@Impuestos),2), @Impuestos, @Importe, @ContUso, @ContUso2, @ContUso3
RETURN
END

