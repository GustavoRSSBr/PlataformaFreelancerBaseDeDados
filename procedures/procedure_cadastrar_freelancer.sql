-- PROCEDURE: public.cadastrar_freelancer(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[])

-- DROP PROCEDURE IF EXISTS public.cadastrar_freelancer(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[]);

CREATE OR REPLACE PROCEDURE public.cadastrar_freelancer(
	IN p_email character varying,
	IN p_senha character varying,
	IN p_tipo_usuario character varying,
	IN p_logradouro character varying,
	IN p_numero character varying,
	IN p_complemento character varying,
	IN p_bairro character varying,
	IN p_cidade character varying,
	IN p_cep character varying,
	IN p_estado character varying,
	IN p_pais character varying,
	IN p_nome character varying,
	IN p_cpf character varying,
	IN p_data_nascimento character varying,
	IN p_telefone character varying,
	IN p_descricao character varying,
	IN p_disponibilidade character varying,
	IN p_data_criacao character varying,
	IN p_status character varying,
	IN p_habilidades character varying[])
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_usuario_id INT;
    v_endereco_id INT;
    v_freelancer_id INT;
    habilidade VARCHAR;
BEGIN
    -- Verificar se o e-mail já existe
    IF EXISTS (SELECT 1 FROM Usuario WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % já está cadastrado', p_email;
    END IF;

    -- Verificar se o CPF já existe
    IF EXISTS (SELECT 1 FROM Freelancer WHERE cpf = p_cpf) THEN
        RAISE EXCEPTION 'CPF % já está cadastrado', p_cpf;
    END IF;

    -- Inserir um novo usuário
    INSERT INTO Usuario (email, senha, tipoUsuario)
    VALUES (p_email, p_senha, p_tipo_usuario)
    RETURNING idUsuario INTO v_usuario_id;

    -- Inserir um novo endereço
    INSERT INTO Endereco (logradouro, numero, complemento, bairro, cidade, cep, estado, pais)
    VALUES (p_logradouro, p_numero, p_complemento, p_bairro, p_cidade, p_cep, p_estado, p_pais)
    RETURNING idEndereco INTO v_endereco_id;

    -- Inserir um novo freelancer
    INSERT INTO Freelancer (usuarioId, nome, cpf, dataNascimento, telefone, enderecoId, descricao, disponibilidade, dataCriacao, status)
    VALUES (v_usuario_id, p_nome, p_cpf, p_data_nascimento, p_telefone, v_endereco_id, p_descricao, p_disponibilidade, p_data_criacao, p_status)
    RETURNING idFreelancer INTO v_freelancer_id;

    -- Inserir habilidades do freelancer
    IF p_habilidades IS NOT NULL THEN
        FOREACH habilidade IN ARRAY p_habilidades
        LOOP
            INSERT INTO HabilidadeFreelancer (habilidade, freelancerId)
            VALUES (habilidade, v_freelancer_id);
        END LOOP;
    END IF;
END;
$BODY$;
ALTER PROCEDURE public.cadastrar_freelancer(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[])
    OWNER TO postgres;
