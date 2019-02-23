-- =============================================
-- Author:		Carlos Alberto Diaz Jimenez
-- Create date: 15-Enero-2019
-- Description:	Funcion que se ingresa el menu o el acceso y retorna a que perfiles esta colgado
-- Ejemplo:		SELECT * FROM mg.FnDesarrolloAQuien('Herramienta.AgrupadorDeAlmacenes')
-- =============================================
ALTER FUNCTION mg.FnDesarrolloAQuien(@Desarrollo VARCHAR(100))
RETURNS TABLE
AS
RETURN(
SELECT U.GrupoTrabajo,U.Acceso,M.item,U.Usuario,P.Propiedad,E.Nombre,E.ApellidoPaterno,E.ApellidoMaterno,E.Estatus,D.Departamento,D.Descripcion
FROM UsuarioMenuPrincipal M
LEFT JOIN Usuario U ON M.Usuario=U.Acceso
LEFT JOIN Prop P ON U.Usuario=P.Cuenta
LEFT JOIN Comercializadora.dbo.Personal E ON P.Propiedad=E.Personal
LEFT JOIN Comercializadora.dbo.Departamento D ON E.Departamento=D.Departamento
WHERE M.item=@Desarrollo
	AND M.Usuario LIKE '%[_]%'
	AND U.Estatus = 'ALTA'
	AND Rama='USR'
ORDER BY M.Usuario OFFSET 0 ROWS
)

GO
SELECT * FROM mg.FnDesarrolloAQuien('Cubo.Servicios')


SELECT * FROM UsuarioMenuPrincipal WHERE Usuario='ADMIN_MAVI' AND item LIKE '%Usuario%'
SELECT * FROM UsuarioMovsEdicion WHERE Usuario='GERAD_GERA'

SELECT Usuario,MostrarCampos FROM Usuario WHERE Usuario LIKE 'DEMO'

SELECT Usuario,Acceso,GrupoTrabajo,Estatus
FROM Usuario
WHERE Usuario IN(
SELECT Usuario
FROM UsuarioMenuPrincipal
WHERE item='EXPDM0232Fotos')

SELECT Usuario,Estatus
FROM Usuario
WHERE Acceso='VENTI_GERA'

DECLARE @Ok VARCHAR(10)
SELECT 'OK' = @Ok
SELECT @Ok
SELECT @Ok = 'OK'
SELECT @Ok


SELECT *
FROM sys.objects
WHERE type='P'
	AND name NOT LIKE '%sp%'
	AND name NOT LIKE '%xp%'
	AND schema_id=1

SELECT *
FROM UsuarioMenuPrincipal
WHERE item LIKE '%DM0021%'


ProductividadEMBMAVI.frm

E052271 	bgbonales
E050608		ehparra

SELECT  
	DM0021SueldoGarantia.ID,
	DM0021SueldoGarantia.NoDQuincena,
        DM0021SueldoGarantia.Fecha
from 
	DM0021SueldoGarantia


SELECT *
FROM sys.objects
WHERE type!='P'
and name LIKE '%sp%'
AND schema_id=1
ORDER BY name
