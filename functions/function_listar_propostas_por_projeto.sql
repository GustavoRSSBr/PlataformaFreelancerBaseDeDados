-- FUNCTION: public.listar_propostas_por_projeto(integer)

-- DROP FUNCTION IF EXISTS public.listar_propostas_por_projeto(integer);

CREATE OR REPLACE FUNCTION public.listar_propostas_por_projeto(
	projeto_id integer)
    RETURNS TABLE(propostaid integer, freelancernome character varying, freelancertelefone character varying, freelanceremail character varying, projetoid integer, valor character varying, datacriacao character varying, status character varying, observacao text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    -- Verifica se o projeto existe
    IF NOT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = projeto_id) THEN
        RAISE EXCEPTION 'Projeto com ID % não encontrado', projeto_id;
    END IF;

    -- Retorna as propostas relacionadas ao projeto
    RETURN QUERY
    SELECT 
        p.propostaId,
        f.nome AS freelancerNome,
        f.telefone AS freelancerTelefone,
        u.email AS freelancerEmail,
        p.projetoId,
        p.valor,
        p.dataCriacao,
        p.status,
        p.observacao
    FROM Proposta p
    JOIN Freelancer f ON p.freelancerId = f.idFreelancer
    JOIN Usuario u ON f.usuarioId = u.idUsuario
    WHERE p.projetoId = projeto_id;

    -- Caso não haja propostas, retorna null
    IF NOT FOUND THEN
        RETURN;
    END IF;
END;
$BODY$;

ALTER FUNCTION public.listar_propostas_por_projeto(integer)
    OWNER TO postgres;
