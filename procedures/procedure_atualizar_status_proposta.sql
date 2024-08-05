-- PROCEDURE: public.atualizastatusproposta(integer, character varying)

-- DROP PROCEDURE IF EXISTS public.atualizastatusproposta(integer, character varying);

CREATE OR REPLACE PROCEDURE public.atualizastatusproposta(
	IN idproposta integer,
	IN novostatus character varying)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Verificar se a proposta existe
    IF NOT EXISTS (SELECT 1 FROM Proposta WHERE propostaId = idProposta) THEN
        RAISE EXCEPTION 'Proposta com id % não existe', idProposta;
    END IF;

    -- Verificar se o status é "ACEITA"
    IF novoStatus = 'ACEITA' THEN
        -- Verificar se o projeto já tem um freelancer associado
        IF (SELECT freelancerId FROM Projeto WHERE idProjeto = (SELECT projetoId FROM Proposta WHERE propostaId = idProposta)) IS NOT NULL THEN
            RAISE EXCEPTION 'Projeto já possui um freelancer associado';
        ELSE
            -- Atualizar o status do projeto para "ANDAMENTO"
            UPDATE Projeto
            SET status = 'ANDAMENTO',
                freelancerId = (
                    SELECT freelancerId
                    FROM Proposta
                    WHERE propostaId = idProposta
                )
            WHERE idProjeto = (
                SELECT projetoId
                FROM Proposta
                WHERE propostaId = idProposta
            );

            -- Atualizar o status da proposta para "ACEITA"
            UPDATE Proposta
            SET status = 'ACEITA'
            WHERE propostaId = idProposta;
        END IF;
    ELSE
        -- Verificar se a proposta já foi aceita
        IF (SELECT status FROM Proposta WHERE propostaId = idProposta) = 'ACEITA' THEN
            RAISE EXCEPTION 'Proposta já foi aceita e não pode ser recusada';
        ELSE
            -- Atualizar o status da proposta para "RECUSADA"
            UPDATE Proposta
            SET status = 'RECUSADA'
            WHERE propostaId = idProposta;
        END IF;
    END IF;
END;
$BODY$;
ALTER PROCEDURE public.atualizastatusproposta(integer, character varying)
    OWNER TO postgres;
