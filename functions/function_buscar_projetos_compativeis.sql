-- FUNCTION: public.buscar_projetos_compatíveis(integer)

-- DROP FUNCTION IF EXISTS public."buscar_projetos_compatíveis"(integer);

CREATE OR REPLACE FUNCTION public."buscar_projetos_compatíveis"(
	func_idfreelancer integer)
    RETURNS TABLE(idprojeto integer, titulo character varying, descricao text, orcamento character varying, prazo character varying, status character varying, habilidades_compativeis text, habilidades_nao_compativeis text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    freelancer_exists BOOLEAN;
BEGIN
    -- Verifica se o freelancer existe
    SELECT EXISTS(SELECT 1 FROM Freelancer WHERE idFreelancer = func_idFreelancer) INTO freelancer_exists;
    IF NOT freelancer_exists THEN
        RAISE EXCEPTION 'ID de Freelancer % não encontrado', func_idFreelancer;
    END IF;

    -- Retorna os projetos compatíveis com as habilidades do freelancer
    RETURN QUERY
    SELECT 
        p.idProjeto, 
        p.titulo, 
        p.descricao, 
        p.orcamento, 
        p.prazo, 
        p.status,
        -- Habilidades compatíveis
        STRING_AGG(DISTINCT hp.habilidade, ', ') AS habilidades_compativeis,
        -- Habilidades não compatíveis
        STRING_AGG(DISTINCT hnp.habilidade, ', ') AS habilidades_nao_compativeis
    FROM Projeto p
    JOIN HabilidadeProjeto hp ON p.idProjeto = hp.projetoId
    -- Apenas habilidades compatíveis (que o freelancer possui)
    JOIN HabilidadeFreelancer hf ON hp.habilidade = hf.habilidade AND hf.freelancerId = func_idFreelancer
    -- Habilidades do projeto que o freelancer não possui
    LEFT JOIN HabilidadeProjeto hnp ON p.idProjeto = hnp.projetoId AND hnp.habilidade NOT IN (
        SELECT hf2.habilidade FROM HabilidadeFreelancer hf2 WHERE hf2.freelancerId = func_idFreelancer
    )
    WHERE p.status = 'ATIVO'
    GROUP BY p.idProjeto, p.titulo, p.descricao, p.orcamento, p.prazo, p.status;

    -- Verifica se nenhum projeto foi encontrado
    IF NOT FOUND THEN
        RAISE NOTICE 'Nenhum Projeto Compatível';
        RETURN;
    END IF;
END;
$BODY$;

ALTER FUNCTION public."buscar_projetos_compatíveis"(integer)
    OWNER TO postgres;
