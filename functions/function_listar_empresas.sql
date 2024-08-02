
BEGIN
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
        e.site
    FROM Empresa e
    JOIN Usuario u ON e.usuarioId = u.idUsuario
    LEFT JOIN Endereco en ON e.enderecoId = en.idEndereco;
END;
