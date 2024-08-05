-- PROCEDURE: public.atualizar_projeto(integer, character varying, text, character varying, character varying, character varying[])

-- DROP PROCEDURE IF EXISTS public.atualizar_projeto(integer, character varying, text, character varying, character varying, character varying[]);

CREATE OR REPLACE PROCEDURE public.atualizar_projeto(
	IN in_idprojeto integer,
	IN in_titulo character varying,
	IN in_descricao text,
	IN in_orcamento character varying,
	IN in_prazo character varying,
	IN in_habilidades character varying[])
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Verifica se o projeto com o id fornecido existe
    IF NOT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = in_idProjeto) THEN
        RAISE EXCEPTION 'ID de Projeto % não encontrado.', in_idProjeto;
    END IF;

    -- Atualiza os dados básicos do projeto
    UPDATE Projeto
    SET titulo = in_titulo,
        descricao = in_descricao,
        orcamento = in_orcamento,
        prazo = in_prazo
    WHERE idProjeto = in_idProjeto;

    -- Remove as habilidades atuais do projeto
    DELETE FROM HabilidadeProjeto WHERE projetoId = in_idProjeto;

    -- Insere as novas habilidades
    IF array_length(in_habilidades, 1) IS NOT NULL THEN
        INSERT INTO HabilidadeProjeto (habilidade, projetoId)
        SELECT unnest(in_habilidades), in_idProjeto;
    END IF;

    RAISE NOTICE 'Projeto de id % atualizado com sucesso.', in_idProjeto;
END;
$BODY$;
ALTER PROCEDURE public.atualizar_projeto(integer, character varying, text, character varying, character varying, character varying[])
    OWNER TO postgres;
