IF OBJECT_ID('mg.UsuarioConjuntosMovEdicion') IS NOT NULL
	DROP TABLE mg.UsuarioConjuntosMovEdicion

CREATE TABLE mg.UsuarioConjuntosMovEdicion(
	AccesoA VARCHAR(10),
	NumAccesoA INT,
	AccesoB VARCHAR(10),
	NumAccesoB INT,
	Intercepcion VARCHAR(MAX),
	NumIntercepcion INT,
	AmenosB VARCHAR(MAX),
	NumAmenosB INT,
	BmenosA VARCHAR(MAX),
	NumBmenosA INT
	)

DECLARE
	@AccesoA VARCHAR(10),
	@NumAccesoA INT,
	@AccesoB VARCHAR(10),
	@NumAccesoB INT,
	@Intercepcion VARCHAR(MAX),
	@NumIntercepcion INT,
	@AmenosB VARCHAR(MAX),
	@NumAmenosB INT,
	@BmenosA VARCHAR(MAX),
	@NumBmenosA INT

DECLARE @MovExcluir VARCHAR(MAX) = ''--'REPMAVI,Herramienta.Calculadora,Herramienta.Calendario,Mov.Salir,Herramienta.DM0155InformacionMavi,Herramienta.CambiarUsuario,Ayuda.Acerca,Ayuda.Ayuda'
DECLARE @MovExcluirTable TABLE(item VARCHAR(100))

INSERT INTO @MovExcluirTable(item)
SELECT item
FROM mg.FnSplit(@MovExcluir,',')

--SELECT*-- @NumAccesoA=COUNT(U.item)
--		FROM UsuarioMenuPrincipal U
--		LEFT JOIN @MovExcluirTable X ON U.item=X.item
--		WHERE Usuario='INVEN_GERA'
--			AND U.item IS NOT NULL
--			AND X.item IS NULL

--SELECT * FROM @MovExcluirTable

DECLARE AccesoA CURSOR
FOR
SELECT Usuario
FROM Usuario
WHERE Estatus='ALTA'
	AND Usuario LIKE '%[_]%'
	--AND Usuario IN('MANSE_AUXA','MANSE_GERA','MANSE_GERB','SERVI_AUXA','SERVI_AUXB','SERVI_GERA')
ORDER BY Usuario

DECLARE AccesoB CURSOR
FOR
SELECT Usuario
FROM Usuario
WHERE Estatus='ALTA'
	AND Usuario LIKE '%[_]%'
	--AND Usuario IN('MANSE_AUXA','MANSE_GERA','MANSE_GERB','SERVI_AUXA','SERVI_AUXB','SERVI_GERA')
ORDER BY Usuario

OPEN AccesoA


FETCH NEXT FROM AccesoA INTO @AccesoA

WHILE @@FETCH_STATUS = 0
BEGIN
	OPEN AccesoB
	FETCH NEXT FROM AccesoB INTO @AccesoB

	WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM AccesoB INTO @AccesoB
		IF @AccesoA != @AccesoB
		BEGIN
		PRINT @AccesoA + ' | ' + @AccesoB

		------------------------------------------------------------
		SELECT @NumAccesoA=COUNT(U.item)
		FROM UsuarioMovsEdicion U
		LEFT JOIN @MovExcluirTable X ON U.item=X.item
		WHERE Usuario=@AccesoA
			AND U.item IS NOT NULL
			AND X.item IS NULL
			--AND U.item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
		
		SELECT @NumAccesoB=COUNT(U.item)
		FROM UsuarioMovsEdicion U
		LEFT JOIN @MovExcluirTable X ON U.item=X.item
		WHERE Usuario=@AccesoB
			AND U.item IS NOT NULL
			AND X.item IS NULL
			--AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			

		;WITH Cte AS (
			SELECT U.item
			FROM UsuarioMovsEdicion U
			LEFT JOIN @MovExcluirTable X ON U.item=X.item
			WHERE Usuario=@AccesoA
				AND U.item IS NOT NULL
				AND X.item IS NULL
				--AND U.item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			INTERSECT
			SELECT U.item
			FROM UsuarioMovsEdicion U
			LEFT JOIN @MovExcluirTable X ON U.item=X.item
			WHERE Usuario=@AccesoB
				AND U.item IS NOT NULL
				AND X.item IS NULL
				--AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			)
		SELECT @NumIntercepcion=COUNT(item)
			,@Intercepcion=STUFF((
				SELECT ', ' + D.item
				FROM Cte D
				ORDER BY D.item
				FOR XML PATH('')
				),1,2,'')
		FROM Cte C


		;WITH Cte AS (
			SELECT U.item
			FROM UsuarioMovsEdicion U
			LEFT JOIN @MovExcluirTable X ON U.item=X.item
			WHERE Usuario=@AccesoA
				AND U.item IS NOT NULL
				AND X.item IS NULL
				--AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			EXCEPT
			SELECT U.item
			FROM UsuarioMovsEdicion U
			LEFT JOIN @MovExcluirTable X ON U.item=X.item
			WHERE Usuario=@AccesoB
				AND U.item IS NOT NULL
				AND X.item IS NULL
				--AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			)
		SELECT @NumAmenosB=COUNT(item)
			,@AmenosB=STUFF((
				SELECT ', ' + D.item
				FROM Cte D
				ORDER BY D.item
				FOR XML PATH('')
				),1,2,'')
		FROM Cte C


		;WITH Cte AS (
			SELECT U.item
			FROM UsuarioMovsEdicion U
			LEFT JOIN @MovExcluirTable X ON U.item=X.item
			WHERE Usuario=@AccesoB
				AND U.item IS NOT NULL
				AND X.item IS NULL
				--AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			EXCEPT
			SELECT U.item
			FROM UsuarioMovsEdicion U
			LEFT JOIN @MovExcluirTable X ON U.item=X.item
			WHERE Usuario=@AccesoA
				AND U.item IS NOT NULL
				AND X.item IS NULL
				--AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			)
		SELECT @NumBmenosA=COUNT(item)
			,@BmenosA=STUFF((
				SELECT ', ' + D.item
				FROM Cte D
				ORDER BY D.item
				FOR XML PATH('')
				),1,2,'')
		FROM Cte C

		INSERT INTO mg.UsuarioConjuntosMovEdicion(AccesoA,NumAccesoA,AccesoB,NumAccesoB,Intercepcion,NumIntercepcion,AmenosB,NumAmenosB,BmenosA,NumBmenosA)
		VALUES(@AccesoA,@NumAccesoA,@AccesoB,@NumAccesoB,@Intercepcion,@NumIntercepcion,@AmenosB,@NumAmenosB,@BmenosA,@NumBmenosA)

		END
		------------------------------------------------------------

	END

	CLOSE AccesoB
	FETCH NEXT FROM AccesoA INTO @AccesoA
END

CLOSE AccesoA

DEALLOCATE AccesoA
DEALLOCATE AccesoB

GO
SELECT * FROM mg.UsuarioConjuntosMovEdicion

SELECT *
FROM mg.UsuarioConjuntosMovEdicion WITH(NOLOCK)
WHERE NumAccesoA=NumIntercepcion
	AND AccesoA LIKE 'COMPR%'
	AND AccesoB NOT LIKE 'ADMIN%'
ORDER BY AccesoA,AccesoB

SELECT Porcentaje = 100.00*NumIntercepcion/IIF(NumAccesoA=0,1,NumAccesoA)
	,AccesoA=AccesoA+'('+CONVERT(VARCHAR,NumAccesoA)+')'
	,AccesoB=AccesoB+' '+CONVERT(VARCHAR,100*NumIntercepcion/IIF(NumAccesoA=0,1,NumAccesoA))+'%(-'+CONVERT(VARCHAR,NumAmenosB)+')'
	,NumIntercepcion,NumAmenosB,NumBmenosA,AmenosB
FROM mg.UsuarioConjuntos
WHERE AccesoA LIKE 'AUDCC%'
	AND AccesoB NOT LIKE 'ADMIN%'
	AND AccesoB NOT LIKE 'SISIN%'
	AND 100.00*NumIntercepcion/IIF(NumAccesoA=0,1,NumAccesoA) > 70.00
	--AND AccesoA='ADMCO_AUXB'
ORDER BY 2,1 DESC,3


SELECT *
FROM mg.UsuarioConjuntosMovEdicion
WHERE AccesoA LIKE 'AUDCC%'






SELECT Porcentaje = 100.00*NumIntercepcion/NumAccesoA,*
FROM mg.UsuarioConjuntosMovEdicion
WHERE AccesoA = 'CREDI_LIMB' AND AccesoB = 'CREDI_GERA'
	OR AccesoA = 'CREDI_GERB' AND AccesoB = 'CREDI_LIMB'
ORDER BY AccesoA,1 DESC

SELECT Porcentaje = 100.00*NumIntercepcion/NumAccesoA,*
FROM mg.UsuarioConjuntosMovEdicion
ORDER BY AccesoA,1 DESC

SELECT DISTINCT Perfil=SUBSTRING(Usuario,1,CHARINDEX('_',Usuario)-1)
FROM Usuario
WHERE Estatus='ALTA'
	AND Usuario LIKE '%[_]%'
ORDER BY 1




SELECT Usuario,Orden,item
FROM (
	SELECT M.item,P.Usuario,A.Area,A.Orden,Primer=ROW_NUMBER() OVER(PARTITION BY M.item ORDER BY A.Orden)
	FROM (
		SELECT DISTINCT M.item
		FROM UsuarioMovsEdicion M
		WHERE M.item IS NOT NULL
			AND M.item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi')
		) M
	LEFT JOIN UsuarioMovsEdicion P ON M.item=P.item
	INNER JOIN UsuarioAreasMavi A ON P.Usuario=A.Usuario
	--ORDER BY P.item,A.Orden
	) T
WHERE Primer=1
ORDER BY Orden,Usuario,item

