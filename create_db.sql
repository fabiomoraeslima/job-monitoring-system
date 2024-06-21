CREATE TABLE cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    job_nome VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    responsavel TEXT,
    ativo boolean NOT NULL,
    data_cadastro DATETIME NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
);

CREATE TABLE scheduler (
    scheduller_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    frequencia_execucao text NOT NULL,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);

CREATE TABLE log_execucao (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim DATETIME NULL,
    status VARCHAR(255) NOT NULL,
    mensagem TEXT,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);

CREATE TABLE log_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);