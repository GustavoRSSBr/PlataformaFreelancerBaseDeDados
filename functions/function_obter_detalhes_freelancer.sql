
BEGIN
    -- Verifica se o freelancer existe
    IF NOT EXISTS (SELECT 1 FROM Freelancer WHERE idFreelancer = freelancer_id) THEN
        RAISE EXCEPTION 'ID de Freelancer % não encontrada', freelancer_id;
    END IF;

    RETURN QUERY
    SELECT
        f.idFreelancer,
        u.email,
        f.nome,
        f.cpf,
        f.dataNascimento,
        f.telefone,
        en.logradouro,
        en.numero,
        en.complemento,
        en.bairro,
        en.cidade,
        en.cep,
        en.estado,
        en.pais,
        f.descricao,
        f.disponibilidade,
        f.dataCriacao,
        f.status,
        COALESCE(AVG(a.nota), 0) AS nota_media,
        (SELECT json_agg(h.habilidade) FROM HabilidadeFreelancer h WHERE h.freelancerId = f.idFreelancer) AS habilidades,
        (SELECT json_agg(
            json_build_object(
                'idAvaliacao', a.idAvaliacao,
                'empresaId', a.empresaId,
                'freelancerId', a.freelancerId,
                'projetoId', a.projetoId,
                'avaliado', a.avaliado,
                'nota', a.nota,
                'comentario', a.comentario,
                'dataAvaliacao', a.dataAvaliacao
            )
        ) FROM Avaliacao a WHERE a.freelancerId = f.idFreelancer AND a.avaliado = 'FREELANCER') AS avaliacoes,
        (SELECT json_agg(
            json_build_object(
                'idProjeto', p.idProjeto,
                'titulo', p.titulo,
                'descricao', p.descricao,
                'orcamento', p.orcamento,
                'prazo', p.prazo,
                'statusProjeto', p.status,
                'dataCriacao', p.dataCriacao,
                'empresaId', p.empresaId,
                'freelancerId', p.freelancerId,
                'habilidades', (
                    SELECT json_agg(h.habilidade)
                    FROM HabilidadeProjeto h
                    WHERE h.projetoId = p.idProjeto
                )
            )
        ) FROM Projeto p WHERE p.freelancerId = f.idFreelancer) AS projetos
    FROM Freelancer f
    JOIN Usuario u ON f.usuarioId = u.idUsuario
    LEFT JOIN Endereco en ON f.enderecoId = en.idEndereco
    LEFT JOIN Avaliacao a ON f.idFreelancer = a.freelancerId AND a.avaliado = 'FREELANCER'
    WHERE f.idFreelancer = freelancer_id
    GROUP BY f.idFreelancer, u.email, en.logradouro, en.numero, en.complemento, en.bairro, en.cidade, en.cep, en.estado, en.pais;
END;
