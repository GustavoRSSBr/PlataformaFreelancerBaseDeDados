-- PROCEDURE: public.enviar_avaliacao(integer, integer, integer, character varying, integer, text, character varying)

-- DROP PROCEDURE IF EXISTS public.enviar_avaliacao(integer, integer, integer, character varying, integer, text, character varying);

CREATE OR REPLACE PROCEDURE public.enviar_avaliacao(
	IN p_empresa_id integer,
	IN p_freelancer_id integer,
	IN p_projeto_id integer,
	IN p_avaliado character varying,
	IN p_nota integer,
	IN p_comentario text,
	IN p_data_avaliacao character varying)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Validar se o id do projeto existe
    IF NOT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = p_projeto_id) THEN
        RAISE EXCEPTION 'Projeto não existe';
    END IF;

    -- Validar se o idFreelancer existe
    IF NOT EXISTS (SELECT 1 FROM Freelancer WHERE idFreelancer = p_freelancer_id) THEN
        RAISE EXCEPTION 'Freelancer não existe';
    END IF;

    -- Validar se o id da empresa existe
    IF NOT EXISTS (SELECT 1 FROM Empresa WHERE idEmpresa = p_empresa_id) THEN
        RAISE EXCEPTION 'Empresa não existe';
    END IF;

    -- Validar se o freelancer está associado ao projeto
    IF NOT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = p_projeto_id AND freelancerId = p_freelancer_id) THEN
        RAISE EXCEPTION 'Freelancer não está associado ao projeto';
    END IF;

    -- Validar se a empresa está associada ao projeto
    IF NOT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = p_projeto_id AND empresaId = p_empresa_id) THEN
        RAISE EXCEPTION 'Empresa não está associada ao projeto';
    END IF;

    -- Validar se a nota é de 1 até 5
    IF p_nota < 1 OR p_nota > 5 THEN
        RAISE EXCEPTION 'Nota deve ser entre 1 e 5';
    END IF;

    -- Verificar se já existe uma avaliação do mesmo tipo no projeto
    IF EXISTS (
        SELECT 1 FROM Avaliacao 
        WHERE projetoId = p_projeto_id 
        AND freelancerId = p_freelancer_id 
        AND empresaId = p_empresa_id 
        AND avaliado = p_avaliado
    ) THEN
        RAISE EXCEPTION 'Avaliação já existe';
    END IF;

    -- Inserir a nova avaliação
    INSERT INTO Avaliacao (empresaId, freelancerId, projetoId, avaliado, nota, comentario, dataAvaliacao)
    VALUES (p_empresa_id, p_freelancer_id, p_projeto_id, p_avaliado, p_nota, p_comentario, p_data_avaliacao);

    -- Verificar se a quantidade de avaliações do projeto é igual a 2
    IF (SELECT COUNT(*) FROM Avaliacao WHERE projetoId = p_projeto_id) = 2 THEN
        -- Atualizar o status do projeto para "CONCLUIDO"
        UPDATE Projeto SET status = 'CONCLUIDO' WHERE idProjeto = p_projeto_id;
    END IF;
END;
$BODY$;
ALTER PROCEDURE public.enviar_avaliacao(integer, integer, integer, character varying, integer, text, character varying)
    OWNER TO postgres;
