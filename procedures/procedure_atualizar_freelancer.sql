-- PROCEDURE: public.atualizar_freelancer(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, text, character varying, character varying, character varying[])

-- DROP PROCEDURE IF EXISTS public.atualizar_freelancer(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, text, character varying, character varying, character varying[]);

CREATE OR REPLACE PROCEDURE public.atualizar_freelancer(
	IN in_idfreelancer integer,
	IN in_telefone character varying,
	IN in_logradouro character varying,
	IN in_numero character varying,
	IN in_complemento character varying,
	IN in_bairro character varying,
	IN in_cidade character varying,
	IN in_cep character varying,
	IN in_estado character varying,
	IN in_pais character varying,
	IN in_descricao text,
	IN in_disponibilidade character varying,
	IN in_status character varying,
	IN in_habilidades character varying[])
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    endereco_id INT;
BEGIN
    -- Verifica se o freelancer com o id fornecido existe
    IF NOT EXISTS (SELECT 1 FROM Freelancer WHERE idFreelancer = in_idFreelancer) THEN
        RAISE EXCEPTION 'ID de Freelancer % não encontrado.', in_idFreelancer;
    END IF;

    -- Atualiza os dados básicos do freelancer
    UPDATE Freelancer
    SET telefone = in_telefone,
        descricao = in_descricao,
        disponibilidade = in_disponibilidade,
        status = in_status
    WHERE idFreelancer = in_idFreelancer;

    -- Obtém o id do endereço do freelancer
    SELECT enderecoId INTO endereco_id FROM Freelancer WHERE idFreelancer = in_idFreelancer;

    -- Atualiza os dados do endereço
    UPDATE Endereco
    SET logradouro = in_logradouro,
        numero = in_numero,
        complemento = in_complemento,
        bairro = in_bairro,
        cidade = in_cidade,
        cep = in_cep,
        estado = in_estado,
        pais = in_pais
    WHERE idEndereco = endereco_id;

    -- Remove as habilidades atuais do freelancer
    DELETE FROM HabilidadeFreelancer WHERE freelancerId = in_idFreelancer;

    -- Insere as novas habilidades
    IF array_length(in_habilidades, 1) IS NOT NULL THEN
        INSERT INTO HabilidadeFreelancer (habilidade, freelancerId)
        SELECT unnest(in_habilidades), in_idFreelancer;
    END IF;

    RAISE NOTICE 'ID de Freelancer % atualizado com sucesso.', in_idFreelancer;
END;
$BODY$;
ALTER PROCEDURE public.atualizar_freelancer(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, text, character varying, character varying, character varying[])
    OWNER TO postgres;
