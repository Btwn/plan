IF OBJECT_ID('mg.UsuarioConjuntos') IS NOT NULL
	DROP TABLE mg.UsuarioConjuntos

CREATE TABLE mg.UsuarioConjuntos(
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
		SELECT @NumAccesoA=COUNT(item)
		FROM UsuarioMenuPrincipal
		WHERE Usuario=@AccesoA
			AND item IS NOT NULL
			AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
		
		SELECT @NumAccesoB=COUNT(item)
		FROM UsuarioMenuPrincipal
		WHERE Usuario=@AccesoB
			AND item IS NOT NULL
			AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			

		;WITH Cte AS (
			SELECT item
			FROM UsuarioMenuPrincipal
			WHERE Usuario=@AccesoA
				AND item IS NOT NULL
				AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			INTERSECT
			SELECT item
			FROM UsuarioMenuPrincipal
			WHERE Usuario=@AccesoB
				AND item IS NOT NULL
				AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
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
			SELECT item
			FROM UsuarioMenuPrincipal
			WHERE Usuario=@AccesoA
				AND item IS NOT NULL
				AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			EXCEPT
			SELECT item
			FROM UsuarioMenuPrincipal
			WHERE Usuario=@AccesoB
				AND item IS NOT NULL
				AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
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
			SELECT item
			FROM UsuarioMenuPrincipal
			WHERE Usuario=@AccesoB
				AND item IS NOT NULL
				AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			EXCEPT
			SELECT item
			FROM UsuarioMenuPrincipal
			WHERE Usuario=@AccesoA
				AND item IS NOT NULL
				AND item NOT IN('REPMAVI','Herramienta.Calculadora','Herramienta.Calendario','Mov.Salir','Herramienta.DM0155InformacionMavi','Herramienta.CambiarUsuario')
			)
		SELECT @NumBmenosA=COUNT(item)
			,@BmenosA=STUFF((
				SELECT ', ' + D.item
				FROM Cte D
				ORDER BY D.item
				FOR XML PATH('')
				),1,2,'')
		FROM Cte C

		INSERT INTO mg.UsuarioConjuntos(AccesoA,NumAccesoA,AccesoB,NumAccesoB,Intercepcion,NumIntercepcion,AmenosB,NumAmenosB,BmenosA,NumBmenosA)
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
SELECT * FROM mg.UsuarioConjuntos

SELECT *
FROM mg.UsuarioConjuntos WITH(NOLOCK)
WHERE NumAccesoA=NumIntercepcion
	AND AccesoA LIKE 'MANSE%'
ORDER BY AccesoA,AccesoB

SELECT DISTINCT Perfil=SUBSTRING(Usuario,1,CHARINDEX('_',Usuario)-1)
FROM Usuario
WHERE Estatus='ALTA'
	AND Usuario LIKE '%[_]%'
ORDER BY 1
