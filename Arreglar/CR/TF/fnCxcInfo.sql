SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fnCxcInfo] (
	@Empresa CHAR(5)
   ,@ClienteD CHAR(10)
   ,@ClienteA CHAR(10)
	)
RETURNS @Resultado TABLE (
	ID INT NULL
   ,Empresa CHAR(5) NULL
   ,Moneda CHAR(10) NULL
   ,TipoCambio FLOAT NULL
   ,Cliente CHAR(10) NULL
   ,ClienteEnviarA INT NULL
   ,Mov VARCHAR(20) NULL
   ,MovID VARCHAR(20) NULL
   ,FechaEmision DATETIME NULL
   ,Vencimiento DATETIME NULL
   ,DiasMoratorios INT NULL
   ,Saldo MONEY NULL
   ,Concepto VARCHAR(50) NULL
   ,Referencia VARCHAR(50)
   ,Estatus VARCHAR(15) NULL
   ,Situacion VARCHAR(50) NULL
   ,SituacionFecha DATETIME NULL
   ,SituacionUsuario VARCHAR(10) NULL
   ,SituacionNota VARCHAR(100) NULL
   ,Proyecto VARCHAR(50) NULL
   ,UEN INT NULL
)
AS
BEGIN
	INSERT @Resultado (ID, Empresa, Moneda, TipoCambio, Cliente, ClienteEnviarA, Mov, MovID, FechaEmision, Vencimiento, DiasMoratorios, Saldo, Concepto, Referencia, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proyecto, UEN)
		SELECT p.ID
			  ,p.Empresa
			  ,p.Moneda
			  ,p.TipoCambio
			  ,p.Cliente
			  ,p.ClienteEnviarA
			  ,p.Mov
			  ,p.MovID
			  ,p.FechaEmision
			  ,p.Vencimiento
			  ,DiasMoratorios = dbo.FnDiasVencidosCxcMavi(P.ID)
			  ,"Saldo" =
			   CASE
				   WHEN mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.DAC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.SCH') THEN -p.Saldo
				   ELSE p.Saldo
			   END
			  ,p.Concepto
			  ,p.Referencia
			  ,p.Estatus
			  ,p.Situacion
			  ,p.SituacionFecha
			  ,p.SituacionUsuario
			  ,p.SituacionNota
			  ,p.Proyecto
			  ,p.UEN
		FROM CxcAplica p
		JOIN MovTipo mt
			ON p.Mov = mt.Mov
			AND mt.Modulo = 'CXC'
		JOIN Version v
			ON 1 = 1
		WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
		AND p.Estatus = 'PENDIENTE'
		AND p.Empresa = @Empresa
		AND p.Cliente BETWEEN @ClienteD AND @ClienteA
	INSERT @Resultado (Empresa, Moneda, TipoCambio, Cliente, Mov, Saldo, Estatus)
		SELECT p.Empresa
			  ,p.Moneda
			  ,m.TipoCambio
			  ,p.Cliente
			  ,CASE
				   WHEN ROUND(p.Saldo, v.RedondeoMonetarios) <= 0 THEN 'Saldo a Favor'
				   ELSE 'Saldo en Contra'
			   END
			  ,p.Saldo
			  ,'PENDIENTE'
		FROM CxcEfectivo p
		JOIN Mon m
			ON m.Moneda = p.Moneda
		JOIN Version v
			ON 1 = 1
		WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
		AND p.Empresa = @Empresa
		AND p.Cliente BETWEEN @ClienteD AND @ClienteA
	INSERT @Resultado (Empresa, Moneda, TipoCambio, Cliente, Mov, Saldo, Estatus)
		SELECT p.Empresa
			  ,p.Moneda
			  ,m.TipoCambio
			  ,p.Cliente
			  ,'Consumos por Facturar'
			  ,p.Saldo
			  ,'PENDIENTE'
		FROM CxcConsumo p
		JOIN Mon m
			ON m.Moneda = p.Moneda
		JOIN Version v
			ON 1 = 1
		WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
		AND p.Empresa = @Empresa
		AND p.Cliente BETWEEN @ClienteD AND @ClienteA
	INSERT @Resultado (Empresa, Moneda, TipoCambio, Cliente, Mov, Saldo, Estatus)
		SELECT p.Empresa
			  ,p.Moneda
			  ,m.TipoCambio
			  ,p.Cliente
			  ,'Vales en Circulacion'
			  ,p.Saldo
			  ,'PENDIENTE'
		FROM CxcVale p
		JOIN Mon m
			ON m.Moneda = p.Moneda
		JOIN Version v
			ON 1 = 1
		WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
		AND p.Empresa = @Empresa
		AND p.Cliente BETWEEN @ClienteD AND @ClienteA
	INSERT @Resultado (Empresa, Moneda, TipoCambio, Cliente, Mov, Saldo, Estatus)
		SELECT p.Empresa
			  ,p.Moneda
			  ,m.TipoCambio
			  ,p.Cliente
			  ,'Redondeo'
			  ,p.Saldo
			  ,'PENDIENTE'
		FROM CxcRedondeo p
		JOIN Mon m
			ON m.Moneda = p.Moneda
		JOIN Version v
			ON 1 = 1
		WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
		AND p.Empresa = @Empresa
		AND p.Cliente BETWEEN @ClienteD AND @ClienteA
	RETURN
END

