-- PROCEDURE: public.excluir_projeto_se_nao_associado(integer)

-- DROP PROCEDURE IF EXISTS public.excluir_projeto_se_nao_associado(integer);

CREATE OR REPLACE PROCEDURE public.excluir_projeto_se_nao_associado(
	IN in_idprojeto integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    projeto_existe BOOLEAN;
    freelancer_associado BOOLEAN;
BEGIN
    -- Verifica se o projeto com o id fornecido existe
    SELECT EXISTS(SELECT 1 FROM Projeto WHERE idProjeto = in_idProjeto) INTO projeto_existe;

    IF NOT projeto_existe THEN
        RAISE EXCEPTION 'ID de Projeto % não encontrado.', in_idProjeto;
    END IF;

    -- Verifica se o projeto está associado a algum freelancer
    SELECT EXISTS(SELECT 1 FROM Projeto WHERE idProjeto = in_idProjeto AND freelancerId IS NOT NULL) 
    INTO freelancer_associado;

    IF freelancer_associado THEN
        RAISE EXCEPTION 'Projeto com id % não pode ser excluído porque está associado a um freelancer.', in_idProjeto;
    ELSE
        -- Excluir habilidades associadas ao projeto
        DELETE FROM HabilidadeProjeto WHERE projetoId = in_idProjeto;

        -- Excluir o projeto
        DELETE FROM Projeto WHERE idProjeto = in_idProjeto;

        RAISE NOTICE 'Projeto com id % excluído com sucesso.', in_idProjeto;
    END IF;
END;
$BODY$;
ALTER PROCEDURE public.excluir_projeto_se_nao_associado(integer)
    OWNER TO postgres;
