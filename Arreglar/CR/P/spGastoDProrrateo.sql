SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoDProrrateo
@Empresa		char(5),
@Sucursal		int,
@ID			int,
@Renglon		float,
@RenglonSub		int,
@Concepto		varchar(50),
@Importe		money,
@ContUso		varchar(20),
@Espacio		char(10),
@Ok			int		= NULL OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT,
@ContUso2		varchar(20)	= NULL,
@ContUso3		varchar(20)	= NULL

AS BEGIN
DECLARE
@Total		float,
@RedondeoMonetarios int,
@Clase		varchar(50),
@SubClase		varchar(50)
SELECT @Clase = Clase, @SubClase = NULLIF(RTRIM(SubClase), '') FROM Gasto WHERE ID = @ID
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @ContUso  = NULLIF(RTRIM(@ContUso), ''),
@ContUso2 = NULLIF(RTRIM(@ContUso2), ''),
@ContUso3 = NULLIF(RTRIM(@ContUso3), ''),
@Espacio  = NULLIF(RTRIM(@Espacio), '')
IF @ContUso  = '0' SELECT @ContUso  = NULL
IF @ContUso2 = '0' SELECT @ContUso2 = NULL
IF @ContUso3 = '0' SELECT @ContUso3 = NULL
IF @Espacio  = '0' SELECT @Espacio  = NULL
IF NOT EXISTS(SELECT * FROM GastoDProrrateo WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Concepto = @Concepto)
BEGIN
INSERT GastoDProrrateo (
Sucursal,  ID,  Renglon,  RenglonSub,  Concepto,  ContUso,                       ContUso2,                        ContUso3,                        VIN,          Espacio,                            SucursalProrrateo, Proyecto,          UEN,          Actividad,          AFArticulo,          AFSerie,          Porcentaje)
SELECT @Sucursal, @ID, @Renglon, @RenglonSub, @Concepto, ISNULL(CCProrrateo, @ContUso), ISNULL(CC2Prorrateo, @ContUso2), ISNULL(CC3Prorrateo, @ContUso3), VINProrrateo, ISNULL(EspacioProrrateo, @Espacio), SucursalProrrateo, ProyectoProrrateo, UENProrrateo, ActividadProrrateo, AFArticuloProrrateo, AFSerieProrrateo, Porcentaje
FROM ConceptoProrrateo
WHERE Modulo = 'GAS' AND Concepto = @Concepto AND NULLIF(RTRIM(UPPER(EmpresaProrrateo)), '') IN (NULL, '(TODAS)', @Empresa)
IF @@ROWCOUNT = 0
INSERT GastoDProrrateo (
Sucursal,  ID,  Renglon,  RenglonSub,  Concepto,  ContUso,                       ContUso2,                        ContUso3,                        VIN,          Espacio,                            SucursalProrrateo, Proyecto,          UEN,          Actividad,          AFArticulo,          AFSerie,          Porcentaje)
SELECT @Sucursal, @ID, @Renglon, @RenglonSub, @Concepto, ISNULL(CCProrrateo, @ContUso), ISNULL(CC2Prorrateo, @ContUso2), ISNULL(CC3Prorrateo, @ContUso3), VINProrrateo, ISNULL(EspacioProrrateo, @Espacio), SucursalProrrateo, ProyectoProrrateo, UENProrrateo, ActividadProrrateo, AFArticuloProrrateo, AFSerieProrrateo, Porcentaje
FROM ClaseProrrateo
WHERE Modulo = 'GAS' AND Clase = @Clase AND ISNULL(SubClase, '') = ISNULL(@SubClase, '') AND NULLIF(RTRIM(UPPER(EmpresaProrrateo)), '') IN (NULL, '(TODAS)', @Empresa)
END
UPDATE GastoDProrrateo
SET Importe = NULLIF(ROUND(@Importe*(Porcentaje/100.0), @RedondeoMonetarios), 0)
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Concepto = @Concepto
SELECT @Total = 0.0
SELECT @Total = ROUND(SUM(Porcentaje), @RedondeoMonetarios) FROM GastoDProrrateo WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Concepto = @Concepto
IF @Total NOT IN (0.0, 100.0) SELECT @Ok = 30520, @OkRef = @Concepto
RETURN
END

