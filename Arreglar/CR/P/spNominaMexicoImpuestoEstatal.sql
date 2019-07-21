SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaMexicoImpuestoEstatal
@Empresa                          char(5),
@SucursalTrabajo                  int,
@Personal                         char(10),
@NomTipo                          varchar(50),
@DiasNaturales                    float,
@SMZ                              float,
@PrimerDiaBimestre                datetime,
@PrimerDiaMes                     datetime,
@SucursalTrabajoEstado            varchar(50),
@ImpuestoEstatalExento            Float ,
@ImpuestoEstatalBase              float,
@ImpuestoEstatal                  float,
@PersonalPercepciones             float,
@FechaA                           datetime,
@FechaD                           datetime,
@ImpuestoEstatalPct               float ,
@ImpuestoEstatalGastoOperacionPct float ,
@AcreedorImpuestoEstatal          varchar(50),
@ImpuestoEstatalVencimiento       datetime,
@CalcImporte                      float,
@Estacion                         int,
@id                               int,
@Ok                               int    OUTPUT,
@OkRef                            varchar(255)  OUTPUT

AS BEGIN
DECLARE
@Importe                       float,
@ImporteP                      float,
@ImporteLista                  float,
@ImporteListaPersonal          float,
@ImpuestoEstatalBaseGrava      float,
@ImpuestoEstatalGastoOperacion float,
@Cantidad                      int,
@ImpuestoEstatalExentoT        money,
@Porcentaje                    float,
@Categoria                     varchar(10),
@Puesto                        varchar(10),
@TasaAdicionalImpuestoEstatal  float,
@TasaAdicionalImp              float
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# SM ImpuestoEstatalExento'    ,  @ImpuestoEstatalExento OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% TasaAdicionalImpuestoEstatal',  @TasaAdicionalImpuestoEstatal OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'GastosOperacionImpuestoEstatal',  @ImpuestoEstatalGastoOperacion OUTPUT
IF @NomTipo = 'Impuesto Estatal'
BEGIN
SELECT @PrimerDiaMes = DATEADD(day, 1-DAY(@FechaA), @FechaA)
SELECT @Importe = 0.0 , @Cantidad =0.0
SELECT @Importe = ISNULL(SUM(ISNULL(d.Importe,0)), 0.0)
FROM Nomina n, NominaD d, MovTipo mt,Cfgnominaconcepto c, Personal p, sucursal s
WHERE n.ID = d.ID
AND n.Estatus in('CONCLUIDO')
AND n.Empresa = @Empresa
AND n.FechaA BETWEEN @PrimerDiaMes AND @FechaA AND mt.Clave IN ('NOM.N', 'NOM.NE','NOM.NA')
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND d.Concepto = c.Descripcion
AND d.personal = p.personal
AND c.claveinterna ='ImpuestoEstatal/Base'
AND p.SucursalTrabajo = s.sucursal  
AND s.estado = @SucursalTrabajoEstado  
SELECT @ImpuestoEstatalBase = @Importe
SELECT @ImporteLista = ISNULL(SUM(ISNULL(d.Importe,0)), 0.0)
FROM Nomina n,
NominaD d,
MovTipo mt,
Cfgnominaconcepto c,
Personal p,
Sucursal s
WHERE n.ID              = d.ID
AND n.Estatus in('CONCLUIDO')
AND n.Empresa         = @Empresa
AND n.FechaA          BETWEEN @PrimerDiaMes AND @FechaA AND mt.Clave IN ('NOM.N', 'NOM.NE','NOM.NA')
AND n.Mov             = mt.Mov
AND mt.Modulo         = 'NOM'
AND d.Concepto        = c.Descripcion
AND d.personal        = p.Personal
AND c.claveinterna    = 'ImpuestoEstatal/Base'
AND p.SucursalTrabajo = s.Sucursal
AND s.Estado          = @SucursalTrabajoEstado
AND d.Personal in(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
SELECT @ImporteLista = ISNULL(@ImporteLista,1)
SELECT @Cantidad = COUNT(PERSONAL)
FROM Personal p, sucursal s
WHERE p.SucursalTrabajo = s.sucursal
AND s.estado = @SucursalTrabajoEstado
AND PERSONAL IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
SELECT @ImporteP =  ISNULL(SUM(ISNULL(d.Importe,0)), 0.0)
FROM Nomina n, NominaD d, MovTipo mt,Cfgnominaconcepto c, Personal p, sucursal s
WHERE n.ID = d.ID
AND n.Estatus in('CONCLUIDO')
AND n.Empresa = @Empresa
AND n.FechaA BETWEEN @PrimerDiaMes AND @FechaA AND mt.Clave IN ('NOM.N', 'NOM.NE','NOM.NA')
AND n.Mov = mt.Mov
AND mt.Modulo = 'NOM'
AND d.Concepto = c.Descripcion
AND d.personal = p.personal
AND c.claveinterna ='ImpuestoEstatal/Base'
AND p.SucursalTrabajo = s.sucursal
AND s.estado = @SucursalTrabajoEstado
AND d.personal = @Personal
SELECT @Cantidad = ISNULL(@Cantidad,0.0)
IF @Cantidad=0 SELECT @Cantidad=0.0
SELECT @ImporteP = isnull(@ImporteP,0.0)
IF @ImporteP=0 SELECT @ImporteP=0.0
SELECT @ImpuestoEstatalExento = ISNULL(@ImpuestoEstatalExento,0.0)
IF ISNULL(@ImpuestoEstatalPct,0)=0 SELECT @ImpuestoEstatalPct=0.0
IF ISNULL(@ImporteLista,0) =0 SELECT @ImporteLista=1.0
IF UPPER(@SucursalTrabajoEstado) IS NOT NULL
BEGIN
SELECT @ImpuestoEstatalExento = @ImpuestoEstatalExento * (@SMZ * 30.4)
SELECT @ImpuestoEstatalExentoT = @ImpuestoEstatalExento
SELECT @ImpuestoEstatal = (@ImpuestoEstatalBase - @ImpuestoEstatalExento) * (@ImpuestoEstatalPct/100.0)
SELECT @ImporteListaPersonal =  @ImporteP/@ImporteLista
SELECT @ImpuestoEstatalBaseGrava = @ImpuestoEstatal * @ImporteListaPersonal
SELECT @ImpuestoEstatalExento = @ImpuestoEstatalExento *  @ImporteListaPersonal
SELECT @Porcentaje = ((@ImporteP*100.0)/@ImporteLista)/100.0
SELECT @TasaAdicionalImp = @ImpuestoEstatalBaseGrava * (@TasaAdicionalImpuestoEstatal/100.0)
SELECT @ImporteP=(@ImpuestoEstatalBase - @ImpuestoEstatalExento) * @ImporteListaPersonal
IF ISNULL(@Cantidad,0)<>0
BEGIN
SELECT @Cantidad = ISNULL(@Cantidad,0.0) * 1.00
SELECT @ImpuestoEstatalGastoOperacion = ISNULL(@ImpuestoEstatalGastoOperacion,0.0) * 1.00
IF NOT EXISTS(SELECT * FROM ImpuestoEstatalGastoOperacion WHERE ID = @ID AND Sucursal = @SucursalTrabajo)
INSERT ImpuestoEstatalGastoOperacion(ID , GastoOperacion, Sucursal)   VALUES(@ID, @ImpuestoEstatalGastoOperacion, @SucursalTrabajo)
SELECT @CalcImporte = @ImpuestoEstatalGastoOperacion/@Cantidad
SELECT @CalcImporte = ROUND(@CalcImporte,7)
END
ELSE
SELECT @CalcImporte = 0.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ImpuestoEstatal',         @Empresa, @Personal,@Cantidad=1, @Importe = @ImpuestoEstatalBaseGrava ,                    @Cuenta     = @AcreedorImpuestoEstatal, @Vencimiento = @ImpuestoEstatalVencimiento
IF ISNULL(@ImpuestoEstatalExento,0) <>0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ImpuestoEstatal/Exento',         @Empresa, @Personal,@Cantidad=1, @Importe = @ImpuestoEstatalExento,                    @Cuenta     = @AcreedorImpuestoEstatal, @Vencimiento = @ImpuestoEstatalVencimiento
IF ISNULL(@ImpuestoEstatalBaseGrava,0) <>0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ImpuestoEstatal/Base',                @Empresa, @Personal,@Cantidad=1, @Importe = @ImporteP,                 @Cuenta     = @AcreedorImpuestoEstatal, @Vencimiento = @ImpuestoEstatalVencimiento
IF ISNULL(@TasaAdicionalImp,0) <>0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ImpuestoEstatal/TasaAdicional',  @Empresa, @Personal,@Cantidad=1, @Importe = @TasaAdicionalImp,                        @Cuenta     = @AcreedorImpuestoEstatal, @Vencimiento = @ImpuestoEstatalVencimiento
IF ISNULL(@CalcImporte,0) <>0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ImpuestoEstatal/GastoOperacion', @Empresa, @Personal,@Cantidad=1, @Importe = @CalcImporte,           @Cuenta     = @AcreedorImpuestoEstatal, @Vencimiento = @ImpuestoEstatalVencimiento
END
END
RETURN
END

