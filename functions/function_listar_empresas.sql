-- FUNCTION: public.listar_empresas()

-- DROP FUNCTION IF EXISTS public.listar_empresas();

CREATE OR REPLACE FUNCTION public.listar_empresas(
	)
    RETURNS TABLE(id_empresa integer, email character varying, cnpj character varying, nome character varying, telefone character varying, logradouro character varying, numero character varying, complemento character varying, bairro character varying, cidade character varying, cep character varying, estado character varying, pais character varying, nome_empresa character varying, ramo_atuacao character varying, site character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
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
$BODY$;

ALTER FUNCTION public.listar_empresas()
    OWNER TO postgres;
