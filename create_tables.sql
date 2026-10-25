USE MusicStoreSQL;

CREATE TABLE dbo.artist (
    artist_id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(150) NOT NULL
);

CREATE TABLE dbo.genre (
    genre_id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(80) NOT NULL
);

CREATE TABLE dbo.media_type (
    media_type_id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(80) NOT NULL
);

CREATE TABLE dbo.playlist (
    playlist_id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.employee (
    employee_id INT NOT NULL PRIMARY KEY,
    last_name NVARCHAR(80) NOT NULL,
    first_name NVARCHAR(80) NOT NULL,
    title NVARCHAR(250) NULL,
    reports_to INT NULL,
    levels NVARCHAR(10) NULL,
    birth_date DATETIME2(0) NULL,
    hire_date DATETIME2(0) NULL,
    address NVARCHAR(150) NULL,
    city NVARCHAR(80) NULL,
    state NVARCHAR(80) NULL,
    country NVARCHAR(80) NULL,
    postal_code NVARCHAR(40) NULL,
    phone NVARCHAR(40) NULL,
    fax NVARCHAR(40) NULL,
    email NVARCHAR(120) NULL
);

CREATE TABLE dbo.album (
    album_id INT NOT NULL PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    artist_id INT NOT NULL
);

CREATE TABLE dbo.track (
    track_id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(300) NOT NULL,
    album_id INT NOT NULL,
    media_type_id INT NOT NULL,
    genre_id INT NOT NULL,
    composer NVARCHAR(300) NULL,
    milliseconds BIGINT NOT NULL,
    bytes BIGINT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    CHECK (milliseconds >= 0),
    CHECK (bytes >= 0),
    CHECK (unit_price >= 0)
);

CREATE TABLE dbo.customer (
    customer_id INT NOT NULL PRIMARY KEY,
    first_name NVARCHAR(80) NOT NULL,
    last_name NVARCHAR(80) NOT NULL,
    company NVARCHAR(200) NULL,
    address NVARCHAR(300) NULL,
    city NVARCHAR(80) NULL,
    state NVARCHAR(80) NULL,
    country NVARCHAR(80) NOT NULL,
    postal_code NVARCHAR(40) NULL,
    phone NVARCHAR(40) NULL,
    fax NVARCHAR(40) NULL,
    email NVARCHAR(120) NOT NULL,
    support_rep_id INT NOT NULL
);

CREATE TABLE dbo.invoice (
    invoice_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    invoice_date DATETIME2(0) NOT NULL,
    billing_address NVARCHAR(300) NULL,
    billing_city NVARCHAR(80) NOT NULL,
    billing_state NVARCHAR(80) NULL,
    billing_country NVARCHAR(80) NOT NULL,
    billing_postal_code NVARCHAR(40) NULL,
    total DECIMAL(12, 2) NOT NULL,
    CHECK (total >= 0)
);

CREATE TABLE dbo.invoice_line (
    invoice_line_id INT NOT NULL PRIMARY KEY,
    invoice_id INT NOT NULL,
    track_id INT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    quantity INT NOT NULL,
    CHECK (unit_price >= 0),
    CHECK (quantity > 0)
);

CREATE TABLE dbo.playlist_track (
    playlist_id INT NOT NULL,
    track_id INT NOT NULL,
    PRIMARY KEY (playlist_id, track_id)
);
