
BEGIN
    -- Verifica se a empresa existe
    IF NOT EXISTS (SELECT 1 FROM Empresa WHERE idEmpresa = empresa_id) THEN
        RAISE EXCEPTION 'ID de Empresa % não encontrada', empresa_id;
    END IF;

    RETURN QUERY
    SELECT
        e.idEmpresa,
        u.email,
        e.cnpj,
        e.nome,
        e.telefone,
        en.logradouro,
        en.numero,
        en.complemento,
        en.bairro,
        en.cidade,
        en.cep,
        en.estado,
        en.pais,
        e.nomeEmpresa,
        e.ramoAtuacao,
        e.site,
        COALESCE(AVG(a.nota), 0) AS nota_media,
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
        ) FROM Avaliacao a WHERE a.empresaId = e.idEmpresa AND a.avaliado = 'EMPRESA') AS avaliacoes,
        (SELECT json_agg(
            json_build_object(
                'idProjeto', p.idProjeto,
                'titulo', p.titulo,
                'descricao', p.descricao,
                'orcamento', p.orcamento,
                'prazo', p.prazo,
                'statusProjeto', p.status,  -- use o campo status e mapeie para statusProjeto
                'dataCriacao', p.dataCriacao,
                'empresaId', p.empresaId,
                'freelancerId', p.freelancerId,
                'habilidades', (
                    SELECT json_agg(h.habilidade)
                    FROM HabilidadeProjeto h
                    WHERE h.projetoId = p.idProjeto
                )
            )
        ) FROM Projeto p WHERE p.empresaId = e.idEmpresa) AS projetos
    FROM Empresa e
    JOIN Usuario u ON e.usuarioId = u.idUsuario
    LEFT JOIN Endereco en ON e.enderecoId = en.idEndereco
    LEFT JOIN Avaliacao a ON e.idEmpresa = a.empresaId AND a.avaliado = 'EMPRESA'
    WHERE e.idEmpresa = empresa_id
    GROUP BY e.idEmpresa, u.email, en.logradouro, en.numero, en.complemento, en.bairro, en.cidade, en.cep, en.estado, en.pais;
END;
