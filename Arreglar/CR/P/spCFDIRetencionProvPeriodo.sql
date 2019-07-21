SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionProvPeriodo
@Estacion		int,
@CxID			int,
@Empresa		varchar(5),
@Proveedor		varchar(10),
@ConceptoSAT	varchar(50),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Ejerc		int,
@MesIni		int,
@MesFin		int,
@MesAux		int
SELECT @Ejerc = Ejercicio/*YEAR(FechaEmision)*/
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
SELECT @MesIni = MIN(Periodo)/*MIN(MONTH(FechaEmision))*/,
@MesFin = MAX(Periodo)/*MAX(MONTH(FechaEmision))*/,
@MesAux = MIN(Periodo)/*MIN(MONTH(FechaEmision))*/
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
WHILE(1=1)
BEGIN
IF @MesAux > @MesFin BREAK
INSERT INTO CFDIRetencionProvPeriodo(ID, Empresa, Proveedor, ConceptoSAT, Ejercicio, Periodo) SELECT @CxID, @Empresa, @Proveedor, @ConceptoSAT, @Ejerc, @MesAux
SELECT @MesAux = @MesAux + 1
END
RETURN
END

