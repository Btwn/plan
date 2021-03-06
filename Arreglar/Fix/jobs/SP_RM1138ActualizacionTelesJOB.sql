SET DATEFIRST 7
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT - 1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
-- ====================================================================================================
-- NOMBRE SP:
-- Autor: Lisset López
-- Fecha Creacion: 10/08/2016
-- Descripcion: Union temporal de RegistroCte,bitacora_cambiosdom,SID_HOJA_VERDE,SID_CAMBIOS_DOMICILIO,
-- SID_ACTUALIZA_POR_COBRO,CampoExtra con cliente,nombre, telefono y fecha de captura 
-- EXEC SP_RM1138ActualizacionTelesJOB
-- ====================================================================================================
-- Nombre: Victor Alain Sanabria Castañon
-- Fecha: 13-Abril-2017
-- Descripcion: Se agregaron mejoras a validaciones de los telefonos, se optimizaron las consultas a cada tabla 
-- para reducir tiempo de ejecucion del SP, se corrijio la extracción de algunos datos como el nombre de cada cliente 
-- ====================================================================================================
ALTER PROCEDURE [dbo].[SP_RM1138ActualizacionTelesJOB]
AS
BEGIN

  DECLARE @Fecha datetime
  SET @Fecha = GETDATE()

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#TelRegistroCte')
    AND TYPE = 'U')
    DROP TABLE #TelRegistroCte

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#Telefonos')
    AND TYPE = 'U')
    DROP TABLE #Telefonos

  ----- tabla que almacena los telefons ingresados del cuestionario dinamido de RegistroCte
  CREATE TABLE #TelRegistroCte (
    Codigo varchar(10) NULL,
    Respuestas varchar(255) NULL
  )
  INSERT INTO #TelRegistroCte
    SELECT
      Codigo,
      LTRIM(RTRIM(Respuesta1))
    FROM RegistroCte WITH (NOLOCK)
    WHERE Pregunta1 = 'NUMERO TELEFONICO DE SU CASA'
    AND LEN(Respuesta1) BETWEEN 7 AND 13
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  INSERT INTO #TelRegistroCte
    SELECT
      Codigo,
      LTRIM(RTRIM(Respuesta2))
    FROM RegistroCte WITH (NOLOCK)
    WHERE Pregunta2 = 'NUMERO TELEFONICO DE SU CASA'
    AND LEN(Respuesta2) BETWEEN 7 AND 13
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  INSERT INTO #TelRegistroCte
    SELECT
      Codigo,
      LTRIM(RTRIM(Respuesta3))
    FROM RegistroCte WITH (NOLOCK)
    WHERE Pregunta3 = 'NUMERO TELEFONICO DE SU CASA'
    AND LEN(Respuesta3) BETWEEN 7 AND 13
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  INSERT INTO #TelRegistroCte
    SELECT
      Codigo,
      LTRIM(RTRIM(Respuesta4))
    FROM RegistroCte WITH (NOLOCK)
    WHERE Pregunta4 = 'NUMERO TELEFONICO DE SU CASA'
    AND LEN(Respuesta4) BETWEEN 7 AND 13
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  INSERT INTO #TelRegistroCte
    SELECT
      Codigo,
      LTRIM(RTRIM(Respuesta5))
    FROM RegistroCte WITH (NOLOCK)
    WHERE Pregunta5 = 'NUMERO TELEFONICO DE SU CASA'
    AND LEN(Respuesta5) BETWEEN 7 AND 13
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  -------- Tabla temporal que junta las informacion de todas la tablas necesaria para insertarlo en la tabla fisica RM1138PendientesxValidar

  CREATE TABLE #Telefonos (
    Cuenta varchar(10) NULL,
    NombreCliente varchar(100) NULL,
    IngresadoEn varchar(50) NULL,
    Telefono bigint NULL,
    FechaCaptura datetime NULL
  )

  -- [PregSegSHM] --
  INSERT INTO #Telefonos
    -------- Los datos dinamicos y demás campos de RegistroCte
    SELECT
      *
    FROM (SELECT
      P.Codigo,
      P.Nombre,
      P.IngresadoEn,
      CONVERT(bigint, P.Telefono) Telefono,
      P.Fecha
    FROM (SELECT DISTINCT
      R.Codigo,
      R.Nombre,
      IngresadoEn = 'PregSegSHM',
      LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(T.Respuestas, '_', ''), '.', ''), ',', ''), '/', ''), '-', ''))) Telefono,
      Fecha
    FROM RegistroCte R WITH (NOLOCK)
    INNER JOIN #TelRegistroCte T WITH (NOLOCK)
      ON R.Codigo = T.Codigo
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON C.Cliente = R.Codigo
    WHERE SUBSTRING(R.Codigo, 1, 1) = 'C'
    AND Categoria IN ('Credito Menudeo', 'Asociados')
    AND T.Respuestas <> ''
    AND T.Respuestas <> ' '
    AND T.Respuestas IS NOT NULL
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha) P
    WHERE SUBSTRING(P.Telefono, 1, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
    AND ISNUMERIC(P.Telefono) = 1) X
    WHERE LEN(X.Telefono) BETWEEN 7 AND 13

  -- [PregSegSHM] --
  INSERT INTO #Telefonos
    --------- Información con el telefono 'Fijo', de RegistroCte
    SELECT DISTINCT
      R.Codigo,
      R.Nombre,
      IngresadoEn = 'PregSegSHM',
      LTRIM(RTRIM(F.TelefonoFijo)) Telefono,
      Fecha
    FROM Cte_Final F WITH (NOLOCK)
    INNER JOIN RegistroCte R WITH (NOLOCK)
      ON R.Nombre = (F.ApellidoPaterno + ' ' + F.ApellidoMaterno + ' ' + F.Nombre)
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON C.Cliente = R.Codigo
    WHERE SUBSTRING(R.Codigo, 1, 1) = 'C'
    AND Categoria IN ('Credito Menudeo', 'Asociados')
    AND LEN(F.TelefonoFijo) BETWEEN 7 AND 13
    AND F.TelefonoFijo IS NOT NULL
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  -- [PregSegSHM] --
  INSERT INTO #Telefonos
    --------- informacion con el telefono Celular de RegistroCte
    SELECT DISTINCT
      R.Codigo,
      R.Nombre,
      IngresadoEn = 'PregSegSHM',
      LTRIM(RTRIM(F.TelefonoCelular)) AS Telefono,
      Fecha
    FROM Cte_Final F WITH (NOLOCK)
    INNER JOIN RegistroCte R WITH (NOLOCK)
      ON R.Nombre = (ApellidoPaterno + ' ' + ApellidoMaterno + ' ' + F.Nombre)
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON C.Cliente = R.Codigo
    WHERE SUBSTRING(R.Codigo, 1, 1) = 'C'
    AND Categoria IN ('Credito Menudeo', 'Asociados')
    AND LEN(F.TelefonoCelular) BETWEEN 7 AND 13
    AND F.TelefonoCelular IS NOT NULL
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  -- [PrelimCobro] --
  INSERT INTO #Telefonos
    ------------  Datos de Tabla Preliminar de Cobro 
    SELECT
      *
    FROM (SELECT
      m.Cuenta,
      m.nombre,
      IngresadoEn = 'PrelimCobro',
      CONVERT(bigint, REPLACE(Telefono, '.', '')) AS Telefono,
      Fecha
    FROM
    --OPENQUERY(websqlp, 'select Cuenta,nombre,telefono,fecha from bitacora_cambiosdom.registro where Telefono <> '' '' and telefono <> 0') m
    OPENQUERY(webmysql, 'select Cuenta,nombre,telefono,fecha from bitacora_cambiosdom.registro where Telefono <> '' '' and telefono <> 0') m
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON C.Cliente = m.Cuenta
    WHERE SUBSTRING(M.Cuenta, 1, 1) = 'C'
    AND Categoria IN ('Credito Menudeo', 'Asociados')
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha) X
    WHERE LEN(X.Telefono) BETWEEN 7 AND 13
    AND X.Telefono IS NOT NULL

  -- [PrelimCobro] --
  INSERT INTO #Telefonos
    ------------  Datos de Tabla Preliminar de cobro con telefono de Empleo
    SELECT
      *
    FROM (SELECT
      Y.Cuenta,
      Y.Nombre,
      Y.IngresadoEn,
      CONVERT(bigint, Y.Telefono) AS Telefono,
      Y.Fecha
    FROM (SELECT DISTINCT
      m.Cuenta,
      m.nombre,
      IngresadoEn = 'PrelimCobro',
      LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(telefono_empleo, '_', ''), '.', ''), ',', ''), '/', ''), '-', ''))) AS Telefono,
      Fecha
    FROM OPENQUERY(webmysql, 'select Cuenta,nombre,telefono_empleo,fecha from bitacora_cambiosdom.registro where Telefono <> '' '' and telefono <> 0') m
    --OPENQUERY(websqlp, 'select Cuenta,nombre,telefono_empleo,fecha from bitacora_cambiosdom.registro where Telefono <> '' '' and telefono <> 0') m
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON C.Cliente = m.Cuenta
    WHERE SUBSTRING(m.Cuenta, 1, 1) = 'C'
    AND Categoria IN ('Credito Menudeo', 'Asociados')
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha) Y
    WHERE SUBSTRING(Y.Telefono, 1, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
    AND ISNUMERIC(Y.Telefono) = 1
    AND LEN(Y.Telefono) BETWEEN 7 AND 13) X

  -- [DatosHV] --
  INSERT INTO #Telefonos
    ----------- Informacion de Tabla Datos De Hoja Verde
    SELECT
      NumProspecto,
      CteNombre,
      IngresadoEn = 'DatosHV',
      CteTelefono,
      Fecha
    FROM MaviAndroid01.SID.dbo.SID_HOJA_VERDE V WITH (NOLOCK)
    --SELECT NumProspecto,CteNombre,IngresadoEn='DatosHV',CteTelefono,Fecha FROM SID.dbo.SID_HOJA_VERDE V WITH (NOLOCK)
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON V.NumProspecto = C.Cliente
    WHERE SUBSTRING(NumProspecto, 1, 1) = 'C'
    AND Categoria IN ('Credito Menudeo', 'Asociados')
    AND LEN(CteTelefono) BETWEEN 7 AND 13
    AND CteTelefono IS NOT NULL
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  -- [CamDomSHM] --
  INSERT INTO #Telefonos
    ----------- Informacion De Tabla Cambios Domicilio
    SELECT
      s.Cuenta,
      Cte.Nombre,
      IngresadoEn = 'CamDomSHM',
      Telefono,
      Fecha
    FROM MaviAndroid01.SID.dbo.SID_CAMBIOS_DOMICILIO s WITH (NOLOCK)
    --SELECT s.Cuenta,Cte.Nombre,IngresadoEn='CamDomSHM',Telefono,Fecha FROM SID.dbo.SID_CAMBIOS_DOMICILIO s WITH (NOLOCK)  
    INNER JOIN Cte WITH (NOLOCK)
      ON Cte.Cliente = s.Cuenta
    INNER JOIN CteEnviarA c WITH (NOLOCK)
      ON s.Cuenta = c.Cliente
    WHERE SUBSTRING(s.Cuenta, 1, 1) = 'C'
    AND c.Categoria IN ('credito menudeo', 'Asociados')
    AND LEN(Telefono) BETWEEN 7 AND 13
    AND Telefono IS NOT NULL
    AND Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  -- [ActPorCobroSHM] -- 
  INSERT INTO #Telefonos
    ---------- Informacion de Tabla Actualizacion Por Cobro
    SELECT
      A.Cuenta,
      A.Nombre,
      IngresadoEn = 'ActPorCobroSHM',
      Telefono,
      F.FechaCaptura
    FROM MaviAndroid01.SID.dbo.SID_ACTUALIZA_POR_COBRO A WITH (NOLOCK)
    --SELECT Cuenta, A.Nombre,IngresadoEn='ActPorCobroSHM',Telefono,F.FechaCaptura FROM SID.dbo.SID_ACTUALIZA_POR_COBRO A WITH (NOLOCK) 
    INNER JOIN Fingerprints F WITH (NOLOCK)
      ON A.Cuenta = F.FingerID
    INNER JOIN CteEnviarA C WITH (NOLOCK)
      ON C.Cliente = A.Cuenta
    WHERE SUBSTRING(A.Cuenta, 1, 1) = 'C'
    AND Categoria IN ('CREDITO MENUDEO', 'ASOCIADOS')
    AND LEN(Telefono) BETWEEN 7 AND 13
    AND Telefono IS NOT NULL
    AND F.FechaCaptura BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  -- [CampoExtra] --
  INSERT INTO #Telefonos
    -------- Información de Tabla Campos Extra
    SELECT
      *
    FROM (SELECT
      Cliente,
      Nombre,
      IngresadoEn,
      CONVERT(bigint, (P.Telefono)) Telefono,
      FechaEmision
    FROM (SELECT DISTINCT
      V.Cliente,
      C.Nombre,
      IngresadoEn = 'CampoExtra',
      LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(VALOR, '_', ''), '.', ''), ',', ''), '/', ''), '-', ''))) Telefono,
      V.FechaEmision
    FROM MovCampoExtra M WITH (NOLOCK)
    INNER JOIN Venta V WITH (NOLOCK)
      ON M.ID = V.ID
    INNER JOIN Cte C WITH (NOLOCK)
      ON V.Cliente = C.Cliente
    INNER JOIN CteEnviarA A WITH (NOLOCK)
      ON A.Cliente = v.Cliente
    WHERE M.CampoExtra = 'SC_TELEFONO'
    AND SUBSTRING(V.Cliente, 1, 1) = 'C'
    AND A.Categoria IN ('CREDITO MENUDEO', 'ASOCIADOS')
    AND LEN(Valor) BETWEEN 7 AND 13
    AND Valor <> ''
    AND Valor <> ' '
    AND Valor IS NOT NULL
    AND V.FechaEmision BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha) P
    WHERE SUBSTRING(P.Telefono, 1, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
    AND ISNUMERIC(P.Telefono) = 1) X
    WHERE LEN(X.Telefono) BETWEEN 7 AND 13

  -- [ValidacionTel] --	
  INSERT INTO #Telefonos --Informacion de Tabla DM0305VALIDACIONTEL Actualizacion en Venta/CXC desde Preliminar Cobro  o modulos de Intelisis
    SELECT
      t.Cliente,
      c.Nombre,
      IngresadoEn = 'ValidacionTel',
      t.Telefono,
      t.Fecha
    FROM DM0305VALIDACIONTEL T WITH (NOLOCK)
    INNER JOIN Cte C WITH (NOLOCK)
      ON C.Cliente = t.Cliente
    WHERE t.Estatus IN ('PENDIENTE', 'EN VALIDACION')
    AND SinTelefono = 0
    AND t.Fecha BETWEEN DATEADD(DAY, -1, @Fecha) AND @Fecha

  DELETE #Telefonos
  WHERE Telefono LIKE '%00000%'
    OR Telefono LIKE '%11111%'
    OR Telefono LIKE '%22222%'
    OR Telefono LIKE '%33333%'
    OR Telefono LIKE '%44444%'
    OR Telefono LIKE '%55555%'
    OR Telefono LIKE '%66666%'
    OR Telefono LIKE '%77777%'
    OR Telefono LIKE '%88888%'
    OR Telefono LIKE '%99999%'

  UPDATE T
  SET T.NombreCliente = C.Nombre
  FROM #Telefonos T
  INNER JOIN Cte C WITH (NOLOCK)
    ON C.Cliente = T.Cuenta

  -- INSERCION EN RM1138PendientesxValidar PARA TENER TODOS LOS TELEFONOS CANDIDATOS A VALIDAR
  INSERT INTO RM1138PendientesxValidar (Cuenta, NombreCliente, IngresadoEn, Telefono, FechaCaptura)
    SELECT
      Cuenta,
      NombreCliente,
      IngresadoEn,
      Telefono,
      FechaCaptura
    FROM #Telefonos WITH (NOLOCK)
    ORDER BY Cuenta, FechaCaptura ASC

  UPDATE RM1138PendientesxValidar WITH (ROWLOCK)
  SET Tipo = c.Tipo
  FROM CteTel c WITH (NOLOCK)
  INNER JOIN RM1138PendientesxValidar p
    ON c.Cliente = p.Cuenta
    AND CAST(p.Telefono AS varchar(15)) = c.Telefono
  UPDATE RM1138PendientesxValidar WITH (ROWLOCK)
  SET Tipo = 'Otro'
  WHERE Tipo = 'Organizacion'
  OR Tipo = 'Telex'
  OR Tipo = 'Localizador'
  OR Tipo = 'Asistente'
  OR Tipo = 'Automovil'
  OR Tipo = 'Radio'
  OR Tipo = 'Fax Trabajo'
  OR Tipo = 'Fax Particular'
  UPDATE RM1138PendientesxValidar WITH (ROWLOCK)
  SET Tipo = 'Movil'
  WHERE Tipo = 'Celular'
  UPDATE RM1138PendientesxValidar WITH (ROWLOCK)
  SET Tipo = 'Particular'
  WHERE Tipo = 'Particular 2'
  UPDATE RM1138PendientesxValidar WITH (ROWLOCK)
  SET Tipo = 'Trabajo'
  WHERE Tipo = 'Trabajo 2'

  --INSERCION EN RM1138ValidacionesPendientes PARA TENER UN RESUMEN DE LOS TELEFONOS POTENCIALES POR CLIENTE
  INSERT INTO RM1138ValidacionesPendientes (Cuenta, NombreCliente, ValidacionesPendientes, FechaCaptura)
    SELECT
      Cuenta,
      NombreCliente,
      COUNT(Cuenta) ValidacionesPendientes,
      MIN(FechaCaptura) FechaCaptura
    FROM #Telefonos WITH (NOLOCK)
    GROUP BY Cuenta,
             NombreCliente
    ORDER BY Cuenta, FechaCaptura ASC

  --ESTE DELETE PERMITE IR REALIZANDO LIMPIEZA DE LA TABLA CONFORME SE CORRIJAN NUMEROS TELEFONICOS 
  DELETE RM1138PendientesxValidar
  WHERE FechaValidacion < DATEADD(YEAR, -1, @Fecha)
    AND Resultado IS NOT NULL
    AND Busqueda = 1

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#TelRegistroCte')
    AND TYPE = 'U')
    DROP TABLE #TelRegistroCte

  IF EXISTS (SELECT
      *
    FROM TEMPDB.SYS.SYSOBJECTS
    WHERE ID = OBJECT_ID('Tempdb.dbo.#Telefonos')
    AND TYPE = 'U')
    DROP TABLE #Telefonos
END