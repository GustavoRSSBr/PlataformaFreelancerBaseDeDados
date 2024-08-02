
BEGIN
    -- Verifica se o projeto existe
    IF NOT EXISTS (SELECT 1 FROM Projeto WHERE idProjeto = projeto_id) THEN
        RAISE EXCEPTION 'Projeto com ID % não encontrado', projeto_id;
    END IF;

    -- Retorna as propostas relacionadas ao projeto
    RETURN QUERY
    SELECT 
        p.propostaId,
        f.nome AS freelancerNome,
        f.telefone AS freelancerTelefone,
        u.email AS freelancerEmail,
        p.projetoId,
        p.valor,
        p.dataCriacao,
        p.status,
        p.observacao
    FROM Proposta p
    JOIN Freelancer f ON p.freelancerId = f.idFreelancer
    JOIN Usuario u ON f.usuarioId = u.idUsuario
    WHERE p.projetoId = projeto_id;

    -- Caso não haja propostas, retorna null
    IF NOT FOUND THEN
        RETURN;
    END IF;
END;
