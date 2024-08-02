
BEGIN
    RETURN QUERY
    SELECT f.idFreelancer, u.email, f.nome, f.cpf, f.dataNascimento, f.telefone,
           e.cidade, e.estado, f.descricao, f.disponibilidade, f.dataCriacao, f.status,
           string_agg(hf.habilidade, ',')::VARCHAR as habilidades
    FROM Freelancer f
    JOIN Usuario u ON f.usuarioId = u.idUsuario
    JOIN Endereco e ON f.enderecoId = e.idEndereco
    LEFT JOIN HabilidadeFreelancer hf ON f.idFreelancer = hf.freelancerId
    GROUP BY f.idFreelancer, u.email, f.nome, f.cpf, f.dataNascimento, f.telefone,
             e.cidade, e.estado, f.descricao, f.disponibilidade, f.dataCriacao, f.status;
END;
