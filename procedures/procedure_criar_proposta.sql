-- PROCEDURE: public.criar_proposta(integer, integer, character varying, character varying, character varying, text)

-- DROP PROCEDURE IF EXISTS public.criar_proposta(integer, integer, character varying, character varying, character varying, text);

CREATE OR REPLACE PROCEDURE public.criar_proposta(
	IN p_freelancerid integer,
	IN p_projetoid integer,
	IN p_valor character varying,
	IN p_datacriacao character varying,
	IN p_status character varying,
	IN p_observacao text)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_freelancer_exists BOOLEAN;
    v_projeto_exists BOOLEAN;
BEGIN
    -- Verificar se o freelancerId existe
    SELECT EXISTS (SELECT 1 FROM Freelancer WHERE idFreelancer = p_freelancerId) INTO v_freelancer_exists;
    IF NOT v_freelancer_exists THEN
        RAISE EXCEPTION 'ID de Freelancer % não existe', p_freelancerId;
    END IF;

    -- Verificar se o projetoId existe
    SELECT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = p_projetoId) INTO v_projeto_exists;
    IF NOT v_projeto_exists THEN
        RAISE EXCEPTION 'ID de Projeto % não existe', p_projetoId;
    END IF;

    -- Inserir uma nova proposta
    INSERT INTO Proposta (freelancerId, projetoId, valor, dataCriacao, status, observacao)
    VALUES (p_freelancerId, p_projetoId, p_valor, p_dataCriacao, p_status, p_observacao);
END;
$BODY$;
ALTER PROCEDURE public.criar_proposta(integer, integer, character varying, character varying, character varying, text)
    OWNER TO postgres;
