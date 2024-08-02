CREATE TABLE Projeto (
    idProjeto SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    orcamento VARCHAR(255),
    prazo VARCHAR(255),
    status VARCHAR(50),
    dataCriacao VARCHAR(20),
    empresaId INT NOT NULL,
    freelancerId INT
);

CREATE TABLE Proposta (
    propostaId SERIAL PRIMARY KEY,
    freelancerId INT NOT NULL,
    projetoId INT NOT NULL,
    valor VARCHAR(255),
    dataCriacao VARCHAR(20),
    status VARCHAR(255),
    observacao TEXT
);

CREATE TABLE HabilidadeProjeto (
    idHabilidadeProjeto SERIAL PRIMARY KEY,
    habilidade VARCHAR(255),
    projetoId INT NOT NULL
);

CREATE TABLE Empresa (
    idEmpresa SERIAL PRIMARY KEY,
    usuarioId INT UNIQUE,
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    enderecoId INT,
    nomeEmpresa VARCHAR(255),
    ramoAtuacao VARCHAR(255),
    site VARCHAR(255)
);

CREATE TABLE Usuario (
    idUsuario SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipoUsuario VARCHAR(20) NOT NULL
);

CREATE TABLE Endereco (
    idEndereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(255) NOT NULL,
    complemento VARCHAR(255),
    bairro VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    cep VARCHAR(20) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    pais VARCHAR(255) NOT NULL
);

CREATE TABLE Avaliacao (
    idAvaliacao SERIAL PRIMARY KEY,
    empresaId INT NOT NULL,
    freelancerId INT NOT NULL,
    projetoId INT NOT NULL,
    avaliado VARCHAR(20),
    nota INT NOT NULL,
    comentario TEXT,
    dataAvaliacao VARCHAR(20) NOT NULL
);

CREATE TABLE Freelancer (
    idFreelancer SERIAL PRIMARY KEY,
    usuarioId INT UNIQUE,
    nome VARCHAR(255),
    cpf VARCHAR(20) UNIQUE,
    dataNascimento VARCHAR(20),
    telefone VARCHAR(255),
    enderecoId INT,
    descricao VARCHAR(255),
    disponibilidade VARCHAR(255),
    dataCriacao VARCHAR(20),
    status VARCHAR(255)
);

CREATE TABLE HabilidadeFreelancer (
    idHabilidadeFreelancer SERIAL PRIMARY KEY,
    habilidade VARCHAR(255),
    freelancerId INT
);

ALTER TABLE Projeto
ADD FOREIGN KEY (empresaId) REFERENCES Empresa(idEmpresa),
ADD FOREIGN KEY (freelancerId) REFERENCES Freelancer(idFreelancer);

ALTER TABLE Proposta
ADD FOREIGN KEY (freelancerId) REFERENCES Freelancer(idFreelancer),
ADD FOREIGN KEY (projetoId) REFERENCES Projeto(idProjeto);

ALTER TABLE HabilidadeProjeto
ADD FOREIGN KEY (projetoId) REFERENCES Projeto(idProjeto);

ALTER TABLE Empresa
ADD FOREIGN KEY (usuarioId) REFERENCES Usuario(idUsuario),
ADD FOREIGN KEY (enderecoId) REFERENCES Endereco(idEndereco);

ALTER TABLE Avaliacao
ADD FOREIGN KEY (empresaId) REFERENCES Empresa(idEmpresa),
ADD FOREIGN KEY (freelancerId) REFERENCES Freelancer(idFreelancer),
ADD FOREIGN KEY (projetoId) REFERENCES Projeto(idProjeto);

ALTER TABLE Freelancer
ADD FOREIGN KEY (usuarioId) REFERENCES Usuario(idUsuario),
ADD FOREIGN KEY (enderecoId) REFERENCES Endereco(idEndereco);

ALTER TABLE HabilidadeFreelancer
ADD FOREIGN KEY (freelancerId) REFERENCES Freelancer(idFreelancer);