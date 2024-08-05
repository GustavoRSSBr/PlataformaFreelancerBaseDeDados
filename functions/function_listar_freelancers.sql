-- FUNCTION: public.listar_freelancers()

-- DROP FUNCTION IF EXISTS public.listar_freelancers();

CREATE OR REPLACE FUNCTION public.listar_freelancers(
	)
    RETURNS TABLE(idfreelancer integer, email character varying, nome character varying, cpf character varying, datanascimento character varying, telefone character varying, cidade character varying, estado character varying, descricao character varying, disponibilidade character varying, datacriacao character varying, status character varying, habilidades character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
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
$BODY$;

ALTER FUNCTION public.listar_freelancers()
    OWNER TO postgres;
