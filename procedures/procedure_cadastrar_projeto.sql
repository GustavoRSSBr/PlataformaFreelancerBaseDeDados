
DECLARE
    v_projeto_id INT;
    habilidade VARCHAR;
    v_empresa_exists BOOLEAN;
BEGIN
    -- Verificar se o idEmpresa existe
    SELECT EXISTS (SELECT 1 FROM Empresa WHERE idEmpresa = p_empresaId) INTO v_empresa_exists;
    IF NOT v_empresa_exists THEN
        RAISE EXCEPTION 'ID de Empresa % não existe', p_empresaId;
    END IF;

    -- Inserir um novo projeto
    INSERT INTO Projeto (titulo, descricao, orcamento, prazo, status, dataCriacao, empresaId)
    VALUES (p_titulo, p_descricao, p_orcamento, p_prazo, p_status, p_dataCriacao, p_empresaId)
    RETURNING idProjeto INTO v_projeto_id;

    -- Inserir habilidades do projeto
    IF p_habilidades IS NOT NULL THEN
        FOREACH habilidade IN ARRAY p_habilidades
        LOOP
            INSERT INTO HabilidadeProjeto (habilidade, projetoId)
            VALUES (habilidade, v_projeto_id);
        END LOOP;
    END IF;
END;
