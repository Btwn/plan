SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHCreaIDSE
@ID          AS INT,           
@RP          AS CHAR(10),      
@Estacion    AS INT            

AS BEGIN
DECLARE @RegistroPatronal AS CHAR(11),
@IMSS             AS CHAR(11),
@ApellidoPaterno  AS CHAR(27),
@ApellidoMaterno  AS CHAR(27),
@Nombre           AS CHAR(27),
@SDI              AS MONEY,
@TipoContrato     AS CHAR(1),
@TipoSueldo       AS CHAR(1),
@Jornada          AS CHAR(1),
@FechaEmision     AS DATETIME,
@UMF              AS INT,
@TipoMovimiento   AS CHAR(2),
@TipoMovStr       AS CHAR(25),
@Personal         AS CHAR(10),
@CausaBaja        AS CHAR(1),
@Curp             AS CHAR(18),
@Cadena           AS VARCHAR(200),
@NoRegistros      AS INT,
@CampoFinal       AS VARCHAR(MAX),
@TotaldeRegs      AS CHAR(6),
@FechaCreacion    AS DATETIME,
@SDIStr           AS CHAR(6),
@IDRH             AS INT,
@RenglonRH        AS FLOAT,
@Pad              AS CHAR(2),
@UMFStr           AS CHAR(3),
@Guia             AS CHAR(5),
@Sucursal         AS INT,
@Renglon          AS VARCHAR(255),
@RegPatronal      AS CHAR(11),
@Personal2           varchar(10),
@Empresa2            varchar(5),
@Sucursal2           int,
@Categoria2          varchar(50),
@Departamento2       varchar(50),
@Puesto2             varchar(20),
@Valor              varchar(255)
DELETE FROM LISTAST WHERE ESTACION=@Estacion
SELECT @Sucursal        =Cuenta FROM PersonalPropValor WHERE Propiedad='# Guia' AND Rama='SUC'
SELECT @Guia            =Valor  FROM PersonalPropValor WHERE Propiedad='Registro Patronal'            AND Cuenta=@Sucursal AND Rama='SUC'
DECLARE BarridoMovsIDSE CURSOR FOR
SELECT
ISNULL(@RP,                       '')           AS REGPATRONAL,
ISNULL(Personal.Registro3        ,'')           AS IMSS ,            
ISNULL(Personal.ApellidoPaterno  ,'')           AS ApellidoPaterno , 
ISNULL(Personal.ApellidoMaterno  ,'')           AS ApellidoMaterno,  
ISNULL(Personal.Nombre           ,'')           AS Nombre,           
ISNULL(Personal.SDI              ,0)*100        AS SDI ,             
CASE Personal.TipoContrato
WHEN 'Trab. Permanente'  THEN '1'
WHEN 'Trab. Ev. Ciudad'  THEN '2'
WHEN 'Trab. Ev. Constrn' THEN '3'
WHEN 'Eventual'          THEN '2'
WHEN 'Construccion'      THEN '3'
WHEN 'Permanente'        THEN '1'
/*      WHEN 'Ev. Campo'         THEN '4'*/
ELSE '1'
END                                           AS TipoContrato,     
CASE Personal.TipoSueldo
WHEN 'Fijo'     THEN '0'
WHEN 'Variable' THEN '1'
WHEN 'Mixto'    THEN '2'
ELSE '0'
END                                           AS TipoSueldo,       
CASE Personal.Jornada
WHEN 'Horario Completo' THEN '0'
WHEN 'Un Dia' THEN           '1'
WHEN 'Dos Dias' THEN         '2'
WHEN 'Tres Dias' THEN        '3'
WHEN 'Cuatro Dias' THEN      '4'
WHEN 'Cinco Dias' THEN       '5'
WHEN 'Jornada Reducida' THEN '6'
ELSE  '0'
END                                           AS Jornada,          
RH.FechaEmision                               AS FechaEmision,     
ISNULL(UnidadMedica,0)                        AS UMF,              
CASE RH.Mov
WHEN 'Modificaciones' THEN '07'
WHEN 'Altas'          THEN '08'
WHEN 'Bajas'          THEN '02'
END                                           AS TipoMovimiento,   
RH.Mov                                          AS TipoMovStr,       
ISNULL(Personal.Personal,'')                    AS Personal,         
CASE RH.Concepto
WHEN 'Termino de Contrato'      THEN '1'
WHEN 'Separ. Voluntaria'        THEN '2'
WHEN 'Abandono de Empleo'       THEN '3'
WHEN 'Defuncion'                THEN '4'
WHEN 'Clausura'                 THEN '5'
WHEN 'Otras'                    THEN '6'
/*      WHEN 'Ausentismo'               THEN '7'
WHEN 'Rescision de contrato'    THEN '8'
WHEN 'Jubilacion'               THEN '9'
WHEN 'Pension'                  THEN 'A'*/
ELSE '1'
END                                           AS CausaBaja,        
Personal.Registro                               AS Curp,             
RHD.Renglon                                     AS Renglon,          
RHD.ID                                          AS IDRH              
FROM RH
JOIN RHD ON RH.ID = RHD.ID
JOIN Personal ON RHD.Personal = Personal.Personal
WHERE RH.Estatus='Concluido'
AND ( (RH.Concepto = 'Sueldo' AND RH.Mov='Modificaciones') OR (RH.Mov IN ('Altas','Bajas')))
AND RHD.ID=@ID
AND (RHD.IDSEConciliado IS NULL OR  RHD.IDSEConciliado=0)
/*SUBSTRING(PersonalPropValor.Valor, 1, 10)  =@RP*/ 
SET @NoRegistros=0  
SET @CampoFinal=''  
SET @Pad='  '       
OPEN BarridoMovsIDSE
FETCH NEXT FROM BarridoMovsIDSE INTO
@RegPatronal,
@IMSS,
@ApellidoPaterno,
@ApellidoMaterno,
@Nombre,
@SDI,
@TipoContrato,
@TipoSueldo,
@Jornada,
@FechaEmision,
@UMF,
@TipoMovimiento,
@TipoMovStr,
@Personal,
@CausaBaja,
@Curp,
@RenglonRH,
@IDRH
SET @FechaCreacion=GETDATE()
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Personal2      = r.Personal,
@Empresa2       = p.Empresa,
@Sucursal2      = r.SucursalTrabajo,
@Categoria2     = r.Categoria,
@Departamento2  = r.Departamento,
@Puesto2        = r.Puesto
FROM RHD r
JOIN Personal p ON r.Personal = p.Personal
WHERE r.ID = @ID AND r.Renglon = @RenglonRH
EXEC spPersonalPropValor @Empresa2, @Sucursal2, @Categoria2, @Puesto2, @Personal2, 'Registro Patronal', @Valor OUTPUT
if SUBSTRING(@Valor,1,10)=@RP
BEGIN
SET @NoRegistros=@NoRegistros+1 
SET @SDIStr=CAST(CAST(ROUND(@SDI,0) AS INT) AS CHAR(6))  
SET @SDIStr=REPLICATE('0',6-LEN(@SDIStr))+@SDIStr
SET @UMFStr=CAST(CAST(ROUND(@UMF,0) AS INT) AS CHAR(3))  
SET @UMFStr=REPLICATE('0',3-LEN(@UMFStr))+@UMFStr
SET @Cadena=
@RP+                     
@IMSS+                   
@ApellidoPaterno+        
@ApellidoMaterno+        
@Nombre+                 
CASE @TipoMovimiento
WHEN '02' THEN REPLICATE('0',6)
ELSE @SDIStr
END+                   
CASE @TipoMovimiento
WHEN '02' THEN REPLICATE('0',6)
ELSE SPACE(6)
END+                   
CASE @TipoMovimiento
WHEN '02' THEN '0'
ELSE @TipoContrato
END+                   
CASE @TipoMovimiento
WHEN '02' THEN '0'
ELSE @TipoSueldo
END+                   
CASE @TipoMovimiento
WHEN '02' THEN '0'
ELSE @Jornada          
END+
RIGHT('0'+LTRIM(DATEPART(dd,@FechaEmision)),2)
+RIGHT('0'+LTRIM(DATEPART(mm,@FechaEmision)),2)
+LTRIM(DATEPART(yyyy,@FechaEmision))+
CASE @TipoMovimiento
WHEN '08' THEN +@UMFStr
ELSE SPACE(3)
END+                   
@Pad+                    
@TipoMovimiento+         
@Guia+                   
@Personal+               
CASE @TipoMovimiento
WHEN '02' THEN @CausaBaja
ELSE ' '
END+                   
@Curp+                   
'9'
INSERT INTO LISTAST (ESTACION,CLAVE) VALUES (@Estacion,@Cadena)
SET @CampoFinal=@CampoFinal+@Cadena
END
FETCH NEXT FROM BarridoMovsIDSE INTO
@RegPatronal,
@IMSS,
@ApellidoPaterno,
@ApellidoMaterno,
@Nombre,
@SDI,
@TipoContrato,
@TipoSueldo,
@Jornada,
@FechaEmision,
@UMF,
@TipoMovimiento,
@TipoMovStr,
@Personal,
@CausaBaja,
@Curp,
@RenglonRH,
@IDRH
END
CLOSE BarridoMovsIDSE
DEALLOCATE BarridoMovsIDSE
/*Aquí genero el último renglón del archivo de lote*/
IF (@NoRegistros>0)
BEGIN
SET @TotaldeRegs=CAST(@NoRegistros AS CHAR(6))
SET @TotaldeRegs=REPLICATE('0',6-LEN(@TotaldeRegs))+@TotaldeRegs
SET @Cadena=REPLICATE('*', 13)+SPACE(43)+@TotaldeRegs+SPACE(71)+@Guia+SPACE(29)+'9'
INSERT INTO LISTAST (ESTACION,CLAVE) VALUES (@Estacion,@Cadena)
SET @CampoFinal=@CampoFinal+@Cadena
END
END

