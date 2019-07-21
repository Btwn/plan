SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIGenerarNomina
@Empresa        varchar(5),
@TablaPeriodo	varchar(10),
@Usuario     	varchar(10),
@Estacion       int,
@Mov            varchar(20)

AS BEGIN
DECLARE
@ID                int,
@EmpresaNOI        varchar(2),
@Concepto          varchar(50),
@ConceptoDIN       varchar(50),
@Mon               varchar(10),
@Tipo              varchar(20),
@Fecha             datetime,
@FechaNomina       datetime,
@FechaD            datetime,
@FechaA            datetime,
@Sucursal          int,
@Renglon           float,
@Plaza             varchar(20),
@Personal          varchar(10),
@Cuenta            varchar(10),
@CuentaContable    varchar(20),
@Importe           float,
@NominaConcepto    varchar(10),
@Movimiento        varchar(20),
@Beneficiario      varchar(100),
@FormaPago         varchar(50),
@BaseNOI           varchar(50),
@SQL               varchar(max),
@Mensaje           bit,
@Ok                int,
@OkRef             varchar(100)
SELECT @Mensaje = NULL
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @FechaNomina = CONVERT(datetime,SUBSTRING(@TablaPeriodo,1,2)+'/'+SUBSTRING(@TablaPeriodo,3,2)+'/'++SUBSTRING(@TablaPeriodo,5,2))
SELECT @EmpresaNOI = EmpresaAspel,@Sucursal = SucursalIntelisis,@BaseNOI = '['+Servidor +'].'+BaseDatosNombre
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SELECT @Mon = Moneda, @Tipo = TipoPeriodo,@ConceptoDIN = ConceptoDIN, @Concepto = Concepto
FROM InterfaseAspelNOI WHERE  Empresa = @Empresa
IF @Mov IS NULL
SELECT @Mov = MovNomina
FROM InterfaseAspelNOI WHERE  Empresa = @Empresa
SELECT @FechaD = FechaD ,@FechaA = FechaA  FROM NOITablaPeriodo WHERE Nomina = @TablaPeriodo AND Estacion = @Estacion
IF EXISTS (SELECT * FROM NOINomina WHERE Verificado = 0 AND EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo   AND Estacion = @Estacion AND @Ok <> 30100)
BEGIN
SELECT @Ok = 1,@OkRef= 'Hay Personal No Validado'
END
IF  EXISTS(SELECT NominaConcepto FROM NOINominaConcepto WHERE Estacion = @Estacion AND Nomina = @TablaPeriodo  EXCEPT SELECT  NominaConcepto FROM  NominaConcepto)
BEGIN
SELECT @OK = 1,@OkRef='Es Necesario Importar Los Conceptos'
END
IF @Ok IS NULL
EXEC spNOIGenerarPersonal  @Empresa, @TablaPeriodo, @Usuario, @Estacion,1,@Mensaje   OUTPUT ,@Ok  OUTPUT, @OkRef  OUTPUT
SET @Renglon = 2048.0
IF @Ok IS NULL
INSERT Nomina(Empresa,  Mov,  FechaEmision, Concepto,  Moneda, TipoCambio, Usuario, Estatus,     PeriodoTipo, FechaD,  FechaA,  Sucursal,  FechaOrigen, NOI)
SELECT        @Empresa, @Mov, @Fecha,       @Concepto, @Mon,   1,          @Usuario, 'BORRADOR', @Tipo,       @FechaD, @FechaA, @Sucursal, @Fecha,      1
SELECT @ID = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
DECLARE crNomina CURSOR FOR
SELECT p.Plaza,RTRIM(LTRIM(d.Personal)),d.Valor,n.Concepto, d.NominaConcepto,n.Movimiento, n.Cuenta
FROM NOINominaD d JOIN Personal p ON RTRIM(LTRIM(d.Personal)) = RTRIM(LTRIM(p.Personal))
JOIN NominaConcepto n ON n.NominaConcepto = d.NominaConcepto
WHERE d.EmpresaNOI = @EmpresaNOI AND d.Nomina = @TablaPeriodo   AND d.Estacion = @Estacion
AND d.Valor > 0.0
OPEN crNomina
FETCH NEXT FROM crNomina INTO @Plaza, @Personal, @Importe, @Concepto, @NominaConcepto, @Movimiento, @Cuentacontable
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT NominaD (ID,  Sucursal,  Renglon, Modulo,    Personal,  NominaConcepto,   Movimiento,    Concepto,   Importe,  CuentaContable, ContUso,Cuenta)
SELECT @ID, @Sucursal,@Renglon,    nc.Modulo,     @Personal, @NominaConcepto, nc.Movimiento, nc.Concepto, @Importe, @Cuentacontable,(SELECT CentroCostos FROM Personal WHERE Personal = @Personal),AcreedorDef
FROM NominaConcepto nc
WHERE nc.NominaConcepto = @NominaConcepto
IF @@ERROR <> 0 SET  @Ok = 1
SET @Renglon = @Renglon + 2048.0
FETCH NEXT FROM crNomina INTO @Plaza, @Personal, @Importe, @Concepto, @NominaConcepto, @Movimiento, @Cuentacontable
END
CLOSE crNomina
DEALLOCATE crNomina
END
IF @Ok IS NULL
BEGIN
DECLARE crNomina2 CURSOR FOR
SELECT p.Plaza,RTRIM(LTRIM(d.Personal)),p.CtaDinero,d.NetoPagado,p.ApellidoPaterno+' '+p.ApellidoMaterno+' '+p.Nombre,p.FormaPago,f.MovEgresos
FROM NOINomina d JOIN Personal p ON RTRIM(LTRIM(d.Personal)) = RTRIM(LTRIM(p.Personal))
JOIN FormaPago f ON p.FormaPago = f.FormaPago
WHERE d.EmpresaNOI = @EmpresaNOI AND d.Nomina = @TablaPeriodo AND d.Estacion = @Estacion AND d.NetoPagado >= 0.0
SELECT @Renglon = MAX(ISNULL(Renglon,0))+2048.0 FROM NominaD WHERE ID = @ID
SELECT @Renglon = ISNULL(@Renglon,2048.0)
OPEN crNomina2
FETCH NEXT FROM crNomina2 INTO @Plaza, @Personal, @Cuenta,@Importe, @Beneficiario, @FormaPago, @Movimiento
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT NominaD(ID, Sucursal,   Renglon,  Modulo, Plaza, Personal,  Cuenta,     Importe,   Beneficiario,  FormaPago,  Movimiento, Concepto,NominaConcepto, CuentaContable, ContUso)
SELECT         @ID, @Sucursal, @Renglon, Modulo, @Plaza, @Personal,AcreedorDef,@Importe, @Beneficiario, @FormaPago, Movimiento, Concepto ,@ConceptoDIN, dbo.fnNominaCuentaContable (CuentaBase, Cuenta, @Personal, NominaConcepto, @Cuenta, @Empresa), (SELECT CentroCostos FROM Personal WHERE Personal = @Personal)
FROM NominaConcepto
WHERE  NominaConcepto = @ConceptoDIN
IF @@ERROR <> 0 SET  @Ok = 1
SET @Renglon = @Renglon + 2048.0
FETCH NEXT FROM crNomina2 INTO @Plaza, @Personal, @Cuenta,@Importe, @Beneficiario, @FormaPago, @Movimiento
END
CLOSE crNomina2
DEALLOCATE crNomina2
END
IF @Ok IS NULL
BEGIN
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL =' UPDATE ' + @BaseNOI + '.dbo.INTELISIS' + @EmpresaNOI +' SET  INTELISIS = 1 WHERE FECH_NOM_INI = '+CHAR(39)+dbo.fnFormatearFecha(@FechaD,'DD/MM/AAAA')+CHAR(39)+' AND FECH_NOM_FIN = '+CHAR(39)+dbo.fnFormatearFecha(@FechaA,'DD/MM/AAAA')+CHAR(39)
EXEC (@SQL)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @OkRef IS NULL AND @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NULL
BEGIN
IF @Mensaje IS NULL
SELECT 'Se Generaron Los Movimientos En El Modulo De Nomina '
ELSE
SELECT 'Se Generaron Los Movimientos En Los Modulos De Nomina y RH '
DELETE   NOINomina
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion AND Nomina = @TablaPeriodo
DELETE   NOINominaD
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion AND Nomina = @TablaPeriodo
END
ELSE
SELECT @OkRef
END

