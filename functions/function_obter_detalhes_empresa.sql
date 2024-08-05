-- FUNCTION: public.obter_detalhes_empresa(integer)

-- DROP FUNCTION IF EXISTS public.obter_detalhes_empresa(integer);

CREATE OR REPLACE FUNCTION public.obter_detalhes_empresa(
	empresa_id integer)
    RETURNS TABLE(id_empresa integer, email character varying, cnpj character varying, nome character varying, telefone character varying, logradouro character varying, numero character varying, complemento character varying, bairro character varying, cidade character varying, cep character varying, estado character varying, pais character varying, nome_empresa character varying, ramo_atuacao character varying, site character varying, nota_media numeric, avaliacoes json, projetos json) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
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
$BODY$;

ALTER FUNCTION public.obter_detalhes_empresa(integer)
    OWNER TO postgres;
