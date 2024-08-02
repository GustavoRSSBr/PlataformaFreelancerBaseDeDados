
BEGIN
    RETURN QUERY
    SELECT
        p.idProjeto,
        p.titulo,
        p.descricao,
        p.orcamento,
        p.prazo,
        p.status,
        p.dataCriacao,
        p.empresaId,
        p.freelancerId,
        COALESCE(
            STRING_AGG(hp.habilidade, ','), ''
        ) AS habilidades
    FROM Projeto p
    LEFT JOIN HabilidadeProjeto hp ON p.idProjeto = hp.projetoId
    GROUP BY p.idProjeto;
END;
