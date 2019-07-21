SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovSituacionBinariaParsearCondUsuario
@Modulo				varchar(5),
@ID					int,
@Mov				varchar(20),
@Estatus			varchar(15),
@Situacion			varchar(50),
@SituacionID		int,
@Cajero				varchar(10),
@Causa				varchar(50),
@Clase				varchar(50),
@Concepto			varchar(50),
@Condicion			varchar(50),
@Contacto			varchar(10),
@CtaDinero			varchar(10),
@Ejercicio			int,
@Empresa			varchar(5),
@EnviarA			int,
@FechaCancelacion	datetime,
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FormaEnvio			varchar(50),
@Importe			money,
@Impuestos			money,
@Moneda				varchar(10),
@MovID				varchar(20),
@Observaciones		varchar(100),
@Origen				varchar(20),
@OrigenID			varchar(20),
@OrigenTipo			varchar(10),
@Periodo			int,
@Proyecto			varchar(50),
@RamaID				int,
@Referencia			varchar(50),
@Retenciones		money,
@SubClase			varchar(50),
@Sucursal			int,
@TipoCambio			float,
@Total				money,
@UEN				int,
@Usuario			varchar(10),
@Vencimiento		datetime,
@ZonaImpuesto		varchar(30),
@CondicionUsuario	varchar(max)	OUTPUT

AS BEGIN
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<ID>','@ID')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Cajero>','@Cajero')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Causa>','@Causa')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Clase>','@Clase')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Concepto>','@Concepto')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Condicion>','@Concepto')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Contacto>','@Contacto')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<CtaDinero>','@CtaDinero')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Ejercicio>','@Ejercicio')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Empresa>','@Empresa')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<EnviarA>','@EnviarA')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<FechaCancelacion>','@FechaCancelacion')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<FechaEmision>','@FechaEmision')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<FechaRegistro>','@FechaRegistro')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<FormaEnvio>','@FormaEnvio')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Importe>','@Importe')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Impuestos>','@Impuestos')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Moneda>','@Moneda')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<MovID>','@MovID')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Observaciones>','@Observaciones')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Origen>','@Origen')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<OrigenID>','@OrigenID')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<OrigenTipo>','@OrigenTipo')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Perdiodo>','@Perdiodo')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<RamaID>','@RamaID')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Referencia>','@Referencia')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Retenciones>','@Retenciones')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<SubClase>','@SubClase')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<TipoCambio>','@TipoCambio')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Total>','@Total')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Vencimiento>','@Vencimiento')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<ZonaImpuesto>','@ZonaImpuesto')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Sucursal>','@Sucursal')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Proyecto>','@Proyecto')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<UEN>','@UEN')
SET @CondicionUsuario = REPLACE(@CondicionUsuario,'<Usuario>','@Usuario')
END

