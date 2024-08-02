
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
