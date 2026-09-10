CREATE DATABASE IF NOT EXISTS wellbe_desafio
    DEFAULT CHARACTER SET utf8mb4;
USE wellbe_desafio;

CREATE TABLE Departamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Funcionario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    identificacao VARCHAR(100) NOT NULL DEFAULT '',
    eh_lider BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Atestado (
    id INT PRIMARY KEY,
    funcionario_id INT NOT NULL,
    departamento_id INT NULL,
    lider_funcionario_id INT NULL,
    data_atestado DATE NOT NULL,
    especialidade VARCHAR(150) NOT NULL DEFAULT '',
    motivo VARCHAR(150) NOT NULL DEFAULT '',
    custo_afastamento DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(id),
    FOREIGN KEY (departamento_id) REFERENCES Departamento(id),
    FOREIGN KEY (lider_funcionario_id) REFERENCES Funcionario(id),
    INDEX idx_data_atestado (data_atestado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
