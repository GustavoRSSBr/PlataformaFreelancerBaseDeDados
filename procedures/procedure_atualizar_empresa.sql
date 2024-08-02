
BEGIN
    -- Verifica se a empresa com o id fornecido existe
    IF EXISTS (SELECT 1 FROM Empresa WHERE idEmpresa = in_idEmpresa) THEN
        -- Atualiza os dados da empresa
        UPDATE Empresa
        SET nome = in_nome,
            telefone = in_telefone,
            ramoAtuacao = in_ramo,
            site = in_site
        WHERE idEmpresa = in_idEmpresa;
        RAISE NOTICE 'Empresa de id % atualizada com sucesso.', in_idEmpresa;
    ELSE
        -- Caso a empresa não exista, lança um erro com o formato solicitado
        RAISE EXCEPTION 'ID de Empresa % não encontrada.', in_idEmpresa;
    END IF;
END;
