CREATE database akademik;
use akademik;

CREATE TABLE dosen (
  Nip varchar(12) NOT NULL,
  Nama_Dosen varchar(25) NOT NULL,
  PRIMARY KEY (Nip)
);

INSERT INTO Dosen(NIP, Nama_Dosen) 
VALUES 
('0429038801', 'Mariana,S.Kom.,MMSI.'),
('0429038802', 'Mariana,S.If.,MMSI.'),
('0429038803', 'Mariana,S.H.,MMSI.'),
('0429038804', 'Mariana,S.Ag.,MMSI.'),
('0429038805', 'Mariana,S.Pd.,MMSI.');

 select * from dosen;
SELECT * FROM Dosen
WHERE Nip = '0429038801';

UPDATE Dosen set Nama_Dosen = 'Nurita, S.Kom., MMSI.' 
WHERE Nip = '0429038801';

DELETE FROM Dosen
WHERE Nip = '0429038801';
-- menghapus seluruh database
DROP DATABASE akademik;


CREATE TABLE mahasiswa (
  Nim varchar(9) NOT NULL,
  Nama_Mhs varchar(25) NOT NULL,
  Tgl_Lahir date NOT NULL,
  Alamat varchar(50) NOT NULL,
  Jenis_Kelamin enum('Laki-laki','Perempuan') NOT NULL,
  IPK decimal (10,2),
  PRIMARY KEY (Nim)
);

INSERT INTO mahasiswa (Nim, Nama_Mhs, Tgl_Lahir, Alamat, Jenis_Kelamin, IPK)
VALUES 
('202307004', 'Lisa Kim', '2000-07-20', 'Jl. Anggrek No. 10', 'Perempuan', 3.95),
('202307001', 'Kiki', '2001-01-21', 'Jl. Anggrek No. 11', 'Laki-Laki', 3.50);

 select * from mahasiswa;

CREATE TABLE matakuliah (
  Kode_MK varchar(6) NOT NULL,
  Nama_MK varchar(20) NOT NULL,
  Sks int(2) NOT NULL,
  PRIMARY KEY (Kode_MK)
);

INSERT INTO matakuliah (Kode_MK, Nama_MK, Sks)
VALUES 
('INF001', 'DAA', 3),
('INF002', 'Komputasi', 3),
('INF003', 'English', 2),
('INF004', 'Matematika', 3),
 ('INF005', 'Basis Data', 3);
 
 select * from matakuliah;
 
 CREATE TABLE perkuliahan (
  Nim varchar(9) DEFAULT NULL,
  Kode_MK varchar(6) DEFAULT NULL, 
  Nip varchar(12) DEFAULT NULL,
  Kehadiran decimal(6,2), 
  Nilai_Bobot char(1) NOT NULL,
  Nilai_Angka decimal(6,2), 
  Poin varchar(1),
  KEY Nip (Nip),
  KEY Nim (Nim),
  KEY Kode_MK (Kode_MK),
  CONSTRAINT perkuliahan_ibfk_1 FOREIGN KEY (Nip) REFERENCES dosen (Nip) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT perkuliahan_ibfk_2 FOREIGN KEY (Nim) REFERENCES mahasiswa (Nim) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT perkuliahan_ibfk_3 FOREIGN KEY (Kode_MK) REFERENCES matakuliah (Kode_MK) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO perkuliahan (Nim, Kode_MK, Nip, Kehadiran, Nilai_Bobot, Nilai_Angka, Poin)
VALUES 
('202307001', 'INF005', '0429038801', 80.00, 'B', 75.00, '3'),
('202307001', 'INF004', '0429038802', 70.00, 'D', 85.00, '1'),
('202307001', 'INF003', '0429038803', 75.00, 'C', 90.00, '2'),
('202307001', 'INF002', '0429038804', 65.00, 'D', 82.71, '1'),
('202307001', 'INF001', '0429038805', 90.00, 'B', 93.59, '3');

 select * from perkuliahan;

CREATE TABLE kriteria_nilai (
    Nilai_Bobot CHAR(1) NOT NULL,
    Poin INT NOT NULL,
    Kriteria VARCHAR(20) NOT NULL,
    PRIMARY KEY (Nilai_Bobot)
);

INSERT INTO kriteria_nilai (Nilai_Bobot, Poin, Kriteria)
VALUES 
('A', 4, 'Istimewa'),
('B', 3, 'Baik'),
('C', 2, 'Cukup'),
('D', 1, 'Kurang'),
('E', 0, 'Tidak Lulus');

SELECT * FROM kriteria_nilai;

SET SQL_SAFE_UPDATES = 0;

UPDATE perkuliahan
SET Nilai_Bobot = 
    CASE
        WHEN Nilai_Angka >= 91 AND Nilai_Angka <= 100 THEN 'A'
        WHEN Nilai_Angka >= 81 AND Nilai_Angka <= 90 THEN 'B'
        WHEN Nilai_Angka >= 71 AND Nilai_Angka <= 80 THEN 'C'
        WHEN Nilai_Angka >= 61 AND Nilai_Angka <= 70 THEN 'D'
        ELSE 'E'
    END;
    
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE dosen 
ADD COLUMN Email varchar(50) DEFAULT NULL;

UPDATE dosen 
SET Email = 'mariana@example.com' 
WHERE Nip = '0429038801';

-- insert
DELIMITER //
CREATE PROCEDURE SP_Tambah_Dosen(IN p_Nip VARCHAR(12), IN p_Nama VARCHAR(25))
BEGIN
    INSERT INTO dosen (Nip, Nama_Dosen) VALUES (p_Nip, p_Nama);
END //
DELIMITER ;

-- select
DELIMITER //
CREATE PROCEDURE SP_Query_Dosen(IN p_Nip VARCHAR(12))
BEGIN
    SELECT * FROM dosen WHERE Nip = p_Nip;
END //
DELIMITER ;

-- update
DELIMITER //
CREATE PROCEDURE SP_Update_Dosen(IN p_Nip VARCHAR(12), IN p_Nama VARCHAR(25))
BEGIN
    UPDATE dosen SET Nama_Dosen = p_Nama WHERE Nip = p_Nip;
END //
DELIMITER ;

-- delete
DELIMITER //
CREATE PROCEDURE SP_Delete_Dosen(IN p_Nip VARCHAR(12))
BEGIN
    DELETE FROM dosen WHERE Nip = p_Nip;
END //
DELIMITER ;

CALL SP_Query_Dosen('0429038801');

ALTER TABLE mahasiswa 
ADD COLUMN No_Telepon varchar(15) DEFAULT NULL;

UPDATE mahasiswa 
SET No_Telepon = '081234567890' 
WHERE Nim = '202307004';

select * from mahasiswa;
-- insert
DELIMITER //
CREATE PROCEDURE SP_Tambah_Mahasiswa(
    IN p_Nim VARCHAR(9),
    IN p_Nama VARCHAR(25),
    IN p_Tgl_Lahir DATE,
    IN p_Alamat VARCHAR(50),
    IN p_Jenis_Kelamin ENUM('Laki-laki','Perempuan'),
    IN p_IPK DECIMAL(10,2)
)
BEGIN
    INSERT INTO mahasiswa (Nim, Nama_Mhs, Tgl_Lahir, Alamat, Jenis_Kelamin, IPK)
    VALUES (p_Nim, p_Nama, p_Tgl_Lahir, p_Alamat, p_Jenis_Kelamin, p_IPK);
END //
DELIMITER ;

-- select
DELIMITER //
CREATE PROCEDURE SP_Query_Mahasiswa(IN p_Nim VARCHAR(9))
BEGIN
    SELECT * FROM mahasiswa WHERE Nim = p_Nim;
END //
DELIMITER ;

-- update
DELIMITER //
CREATE PROCEDURE SP_Update_Mahasiswa(IN p_Nim VARCHAR(9), IN p_IPK DECIMAL(10,2))
BEGIN
    UPDATE mahasiswa SET IPK = p_IPK WHERE Nim = p_Nim;
END //
DELIMITER ;

-- delete
DELIMITER //
CREATE PROCEDURE SP_Delete_Mahasiswa(IN p_Nim VARCHAR(9))
BEGIN
    DELETE FROM mahasiswa WHERE Nim = p_Nim;
END //
DELIMITER ;


ALTER TABLE matakuliah 
ADD COLUMN Deskripsi varchar(100) DEFAULT NULL;

UPDATE matakuliah 
SET Deskripsi = 'Mata kuliah mengenai database.' 
WHERE Kode_MK = 'INF005';

-- insert
DELIMITER //
CREATE PROCEDURE SP_Tambah_Matakuliah(
    IN p_Kode_MK VARCHAR(6),
    IN p_Nama_MK VARCHAR(20),
    IN p_Sks INT
)
BEGIN
    INSERT INTO matakuliah (Kode_MK, Nama_MK, Sks)
    VALUES (p_Kode_MK, p_Nama_MK, p_Sks);
END //
DELIMITER ;

-- select
DELIMITER //
CREATE PROCEDURE SP_Delete_Mahasiswa(IN p_Nim VARCHAR(9))
BEGIN
    DELETE FROM mahasiswa WHERE Nim = p_Nim;
END //
DELIMITER ;

-- update
DELIMITER //
CREATE PROCEDURE SP_Update_Matakuliah(IN p_Kode_MK VARCHAR(6), IN p_Nama_MK VARCHAR(20))
BEGIN
    UPDATE matakuliah SET Nama_MK = p_Nama_MK WHERE Kode_MK = p_Kode_MK;
END //
DELIMITER ;

-- delete
DELIMITER //
CREATE PROCEDURE SP_Delete_Matakuliah(IN p_Kode_MK VARCHAR(6))
BEGIN
    DELETE FROM matakuliah WHERE Kode_MK = p_Kode_MK;
END //
DELIMITER ;


ALTER TABLE perkuliahan 
ADD COLUMN Semester int(2) DEFAULT NULL;

UPDATE perkuliahan 
SET Semester = 1 
WHERE Nim = '202307001' AND Kode_MK = 'INF005';

-- insert
DELIMITER //
CREATE PROCEDURE SP_Tambah_Perkuliahan(
    IN p_Nim VARCHAR(9),
    IN p_Kode_MK VARCHAR(6),
    IN p_Nip VARCHAR(12),
    IN p_Kehadiran DECIMAL(6,2),
    IN p_Nilai_Bobot CHAR(1),
    IN p_Nilai_Angka DECIMAL(6,2),
    IN p_Poin VARCHAR(1)
)
BEGIN
    INSERT INTO perkuliahan (Nim, Kode_MK, Nip, Kehadiran, Nilai_Bobot, Nilai_Angka, Poin)
    VALUES (p_Nim, p_Kode_MK, p_Nip, p_Kehadiran, p_Nilai_Bobot, p_Nilai_Angka, p_Poin);
END //
DELIMITER ;

-- select
DELIMITER //
CREATE PROCEDURE SP_Query_Perkuliahan(IN p_Nim VARCHAR(9))
BEGIN
    SELECT * FROM perkuliahan WHERE Nim = p_Nim;
END //
DELIMITER ;

-- update
DELIMITER //
CREATE PROCEDURE SP_Update_Perkuliahan(IN p_Nim VARCHAR(9), IN p_Nilai_Bobot CHAR(1))
BEGIN
    UPDATE perkuliahan SET Nilai_Bobot = p_Nilai_Bobot WHERE Nim = p_Nim;
END //
DELIMITER ;

-- delete
DELIMITER //
CREATE PROCEDURE SP_Delete_Perkuliahan(IN p_Nim VARCHAR(9))
BEGIN
    DELETE FROM perkuliahan WHERE Nim = p_Nim;
END //
DELIMITER ;


