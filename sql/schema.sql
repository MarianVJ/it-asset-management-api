CREATE TABLE angajati (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nume NVARCHAR(100) NOT NULL,
    prenume NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    departament NVARCHAR(100),
    activ BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME
);

CREATE TABLE magazii (
    id INT IDENTITY(1,1) PRIMARY KEY,
    denumire NVARCHAR(150) NOT NULL,
    locatie NVARCHAR(200),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME
);

CREATE TABLE echipamente (
    id INT IDENTITY(1,1) PRIMARY KEY,
    serie NVARCHAR(100) NOT NULL UNIQUE,
    denumire NVARCHAR(150) NOT NULL,
    marca NVARCHAR(100),
    model NVARCHAR(100),
    status NVARCHAR(50) NOT NULL DEFAULT 'Activ',
    proprietar_curent_id INT,
    magazie_id INT,
    data_achizitie DATE NOT NULL,
    casat_la DATETIME,
    observatii NVARCHAR(500),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME,
    CONSTRAINT FK_echipamente_angajat FOREIGN KEY (proprietar_curent_id) REFERENCES angajati(id),
    CONSTRAINT FK_echipamente_magazie FOREIGN KEY (magazie_id) REFERENCES magazii(id),
    CONSTRAINT CHK_locatie_exclusiva CHECK (
        NOT (proprietar_curent_id IS NOT NULL AND magazie_id IS NOT NULL)
    ),
    CONSTRAINT CHK_status_echipament CHECK (
        status IN ('Activ', 'Defect', 'In Service', 'In curs de transfer', 'Casat')
    )
);

-- serie_componenta: optional, nu toate componentele au serie fizica (ex: cabluri, accesorii)
CREATE TABLE componente_echipamente (
    id INT IDENTITY(1,1) PRIMARY KEY,
    echipament_id INT NOT NULL,
    denumire NVARCHAR(150) NOT NULL,
    tip NVARCHAR(100),
    serie_componenta NVARCHAR(100),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME,
    CONSTRAINT FK_componente_echipament FOREIGN KEY (echipament_id) REFERENCES echipamente(id)
);


-- Transfer angajat->angajat: validarea sursa != destinatie se face in cod, nu in DB
CREATE TABLE operatiuni (
    id INT IDENTITY(1,1) PRIMARY KEY,
    echipament_id INT NOT NULL,
    tip NVARCHAR(50) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT 'in_curs',
    angajat_sursa_id INT,
    angajat_destinatie_id INT,
    magazie_sursa_id INT,
    magazie_destinatie_id INT,
    initiat_la DATETIME NOT NULL DEFAULT GETDATE(),
    finalizat_la DATETIME,
    observatii NVARCHAR(500),
    CONSTRAINT CHK_tip_operatiune CHECK (
        tip IN ('alocare', 'transfer', 'returnare', 'casare')
    ),
    CONSTRAINT CHK_status_operatiune CHECK (
        status IN ('in_curs', 'finalizata', 'anulata')
    ),
    CONSTRAINT FK_operatiuni_echipament FOREIGN KEY (echipament_id) REFERENCES echipamente(id),
    CONSTRAINT FK_operatiuni_ang_sursa FOREIGN KEY (angajat_sursa_id) REFERENCES angajati(id),
    CONSTRAINT FK_operatiuni_ang_dest FOREIGN KEY (angajat_destinatie_id) REFERENCES angajati(id),
    CONSTRAINT FK_operatiuni_mag_sursa FOREIGN KEY (magazie_sursa_id) REFERENCES magazii(id),
    CONSTRAINT FK_operatiuni_mag_dest FOREIGN KEY (magazie_destinatie_id) REFERENCES magazii(id)
);

CREATE TABLE qr_tokens (
    id INT IDENTITY(1,1) PRIMARY KEY,
    echipament_id INT NOT NULL,
    token NVARCHAR(100) NOT NULL UNIQUE,
    activ BIT NOT NULL DEFAULT 1,
    generat_la DATETIME NOT NULL DEFAULT GETDATE(),
    invalidat_la DATETIME,
    CONSTRAINT FK_qr_echipament FOREIGN KEY (echipament_id) REFERENCES echipamente(id)
);
