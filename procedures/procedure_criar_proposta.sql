
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
