-- FUNCTION: public.listar_todos_projetos()

-- DROP FUNCTION IF EXISTS public.listar_todos_projetos();

CREATE OR REPLACE FUNCTION public.listar_todos_projetos(
	)
    RETURNS TABLE(id_projeto integer, titulo character varying, descricao text, orcamento character varying, prazo character varying, status character varying, data_criacao character varying, empresa_id integer, freelancer_id integer, habilidades text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT
        p.idProjeto,
        p.titulo,
        p.descricao,
        p.orcamento,
        p.prazo,
        p.status,
        p.dataCriacao,
        p.empresaId,
        p.freelancerId,
        COALESCE(
            STRING_AGG(hp.habilidade, ','), ''
        ) AS habilidades
    FROM Projeto p
    LEFT JOIN HabilidadeProjeto hp ON p.idProjeto = hp.projetoId
    GROUP BY p.idProjeto;
END;
$BODY$;

ALTER FUNCTION public.listar_todos_projetos()
    OWNER TO postgres;
