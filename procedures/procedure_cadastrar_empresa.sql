-- PROCEDURE: public.cadastrar_empresa(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP PROCEDURE IF EXISTS public.cadastrar_empresa(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE PROCEDURE public.cadastrar_empresa(
	IN p_email character varying,
	IN p_senha character varying,
	IN p_tipousuario character varying,
	IN p_cnpj character varying,
	IN p_nome character varying,
	IN p_telefone character varying,
	IN p_logradouro character varying,
	IN p_numero character varying,
	IN p_complemento character varying,
	IN p_bairro character varying,
	IN p_cidade character varying,
	IN p_cep character varying,
	IN p_estado character varying,
	IN p_pais character varying,
	IN p_nomeempresa character varying,
	IN p_ramoatuacao character varying,
	IN p_site character varying)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_usuarioId INT;
    v_enderecoId INT;
    v_empresaId INT;
    v_email_exists BOOLEAN;
    v_cnpj_exists BOOLEAN;
BEGIN
    -- Verificar se o e-mail já existe
    IF EXISTS (SELECT 1 FROM Usuario WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % já está cadastrado', p_email;
    END IF;

    -- Verificar se o CNPJ já existe
    IF EXISTS (SELECT 1 FROM Empresa WHERE cnpj = p_cnpj) THEN
        RAISE EXCEPTION 'CNPJ % já está cadastrado', p_cnpj;
    END IF;

    -- Inserir um novo usuário
    INSERT INTO Usuario (email, senha, tipoUsuario)
    VALUES (p_email, p_senha, p_tipoUsuario)
    RETURNING idUsuario INTO v_usuarioId;
    
    -- Inserir um novo endereço
    INSERT INTO Endereco (logradouro, numero, complemento, bairro, cidade, cep, estado, pais)
    VALUES (p_logradouro, p_numero, p_complemento, p_bairro, p_cidade, p_cep, p_estado, p_pais)
    RETURNING idEndereco INTO v_enderecoId;
    
    -- Inserir uma nova empresa
    INSERT INTO Empresa (usuarioId, cnpj, nome, telefone, enderecoId, nomeEmpresa, ramoAtuacao, site)
    VALUES (v_usuarioId, p_cnpj, p_nome, p_telefone, v_enderecoId, p_nomeEmpresa, p_ramoAtuacao, p_site)
    RETURNING idEmpresa INTO v_empresaId;
    
    RAISE NOTICE 'Empresa cadastrada com sucesso. ID: %', v_empresaId;
END;
$BODY$;
ALTER PROCEDURE public.cadastrar_empresa(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO postgres;
