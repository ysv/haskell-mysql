DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS resources;
CREATE TABLE resources (
    id SERIAL PRIMARY KEY,
    author_id INT(11) NOT NULL,
    catalog_id INT(11) NOT NULL,
    title VARCHAR(20) NOT NULL,
    annotation VARCHAR(50) DEFAULT '',
    kind VARCHAR(20) DEFAULT '',
    usage_cond VARCHAR(100) DEFAULT '',
    link VARCHAR(100) DEFAULT ''
);

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    date_of_birth DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS activities;
CREATE TABLE activities (
    id SERIAL PRIMARY KEY,
    user_id INT(11) NOT NULL,
    resource_id INT(11) NOT NULL
);

INSERT INTO authors(id, name, surname) VALUES(1, 'John', 'Doe');
INSERT INTO authors(id, name, surname) VALUES(2, 'Will', 'Stack');

INSERT INTO catalogs(id, name) VALUES(1, 'Catalog 1');
INSERT INTO catalogs(id, name) VALUES(2, 'Catalog 2');

INSERT INTO resources(id, author_id, catalog_id, title, annotation, kind, usage_cond, link)
VALUES(1, 1, 1, 'Title 1', 'Annotate 1', 'Kind 1', 'Usage Cond 1', 'http://some-link.com')