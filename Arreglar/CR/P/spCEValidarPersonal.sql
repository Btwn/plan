SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCEValidarPersonal
@Empresa       varchar(5)

AS BEGIN
DECLARE
@EmpresaNOI  varchar(2),
@TipoPeriodo varchar(20),
@CtaDinero   varchar(10),
@Moneda      varchar(10),
@Sucursal    int,
@ZonaEconomica varchar(30),
@ConceptoDIN varchar(50),
@OK          varchar(200)
SELECT @EmpresaNOI = EmpresaAspel,@Sucursal =SucursalIntelisis
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SELECT @TipoPeriodo = TipoPeriodo,@CtaDinero = CtaDinero ,@Moneda = Moneda , @ConceptoDIN =ConceptoDIN
FROM InterfaseAspelNOI WHERE  Empresa = @Empresa
SELECT @ZonaEconomica = ZonaEconomica FROM Sucursal WHERE Sucursal = @Sucursal
SET @OK = NULL
IF  NULLIF(@ZonaEconomica,'') IS NULL
SELECT @OK = 'Es Necesario Asignar La Zona Economica De La Sucursal'
IF  @Sucursal IS NULL
SELECT @OK = 'Es Necesario Asignar La Sucursal'
IF  NULLIF(@TipoPeriodo,'') IS NULL
SELECT @OK = 'Es Necesario Asignar El Tipo Periodo'
IF  NULLIF(@Moneda,'') IS NULL
SELECT @OK = 'Es Necesario Asignar La Moneda'
IF  NULLIF(@CtaDinero,'') IS NULL
SELECT @OK = 'Es Necesario Asignar La Cuenta Dinero'
IF  NULLIF(@ConceptoDIN,'') IS NULL
SELECT @OK = 'Es Necesario Asignar El Concepto Tesoreria'
SELECT @OK
END

