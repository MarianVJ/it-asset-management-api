-- Angajati
INSERT INTO angajati (nume, prenume, email, departament) VALUES
    ('Popescu',     'Ion',    'ion.popescu@firma.ro',    'IT'),
    ('Ionescu',     'Maria',  'maria.ionescu@firma.ro',  'HR'),
    ('Dumitrescu',  'Andrei', 'andrei.dumitrescu@firma.ro', 'Financiar');

-- Magazii
INSERT INTO magazii (denumire, locatie) VALUES
    ('Depozit Central', 'Parter, camera 01'),
    ('Depozit Nord',    'Etaj 2, camera 12');

-- Echipamente
-- id 1: la angajat 1,       Activ
-- id 2: la angajat 2,       In curs de transfer (operatiune activa)
-- id 3: in magazie 1,       Activ
-- id 4: nealocat,           Activ
INSERT INTO echipamente (serie, denumire, marca, model, status, proprietar_curent_id, magazie_id, data_achizitie) VALUES
    ('SN-DELL-001', 'Laptop',      'Dell',     'Latitude 5520',   'Activ',              1,    NULL, '2020-03-10'),
    ('SN-SAM-002',  'Monitor',     'Samsung',  'C27F396',         'In curs de transfer', 2,    NULL, '2021-07-22'),
    ('SN-HP-003',   'Imprimanta',  'HP',       'LaserJet M404dn', 'Activ',              NULL,  1,   '2019-05-14'),
    ('SN-LOG-004',  'Tastatura',   'Logitech', 'MX Keys',        'Activ',              NULL,  NULL, '2023-09-01');

-- Componente (pe echipamentul 1)
INSERT INTO componente_echipamente (echipament_id, denumire, tip, serie_componenta) VALUES
    (1, 'RAM 16GB DDR4',   'Memorie',  NULL),
    (1, 'SSD 512GB NVMe',  'Stocare',  'SSD-KXG60ZNV512G');

-- Operatiuni
-- id 1: alocare echipament 1 -> angajat 1          (finalizata)
-- id 2: alocare echipament 2 -> angajat 2          (finalizata)
-- id 3: returnare echipament 2, angajat 2 -> magazie 1  (in_curs)
INSERT INTO operatiuni (echipament_id, tip, status, angajat_sursa_id, angajat_destinatie_id, magazie_sursa_id, magazie_destinatie_id, initiat_la, finalizat_la) VALUES
    (1, 'alocare',    'finalizata', NULL, 1,    NULL, NULL, '2020-03-11', '2020-03-11'),
    (2, 'alocare',    'finalizata', NULL, 2,    NULL, NULL, '2021-07-23', '2021-07-23'),
    (2, 'returnare',  'in_curs',    2,    NULL, NULL, 1,    '2026-05-14', NULL);

-- QR tokens (1 activ per echipament)
INSERT INTO qr_tokens (echipament_id, token, activ) VALUES
    (1, 'tok-a1b2c3d4-echip-1', 1),
    (2, 'tok-b2c3d4e5-echip-2', 1),
    (3, 'tok-c3d4e5f6-echip-3', 1),
    (4, 'tok-d4e5f6a7-echip-4', 1);
