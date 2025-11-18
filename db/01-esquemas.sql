BEGIN;

--Tipos de usuario
CREATE TABLE tipoUsuario (
  id      SERIAL PRIMARY KEY,
  nombre  VARCHAR(50) NOT NULL UNIQUe
);

--Usuarios del sistema
CREATE TABLE usuario (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  correo      VARCHAR(150) NOT NULL UNIQUE,
  contrasena  VARCHAR(255) NOT NULL,     
  direccion   TEXT,
  telefono    VARCHAR(20),
  descripcion TEXT,
  urlImagen   TEXT,
  tipo        INTEGER NOT NULL REFERENCES tipoUsuario(id)
);

-- listas de reproducción de un usuario
CREATE TABLE lista (
  id         SERIAL PRIMARY KEY,
  nombre     VARCHAR(150) NOT NULL,
  urlImagen  TEXT,
  idUsuario  INTEGER NOT NULL REFERENCES usuario(id) ON DELETE CASCADE
);

-- Relación N:M entre lista y canción
CREATE TABLE lista_canciones (
  idLista    INTEGER NOT NULL REFERENCES lista(id) ON DELETE CASCADE,
  idCancion  INTEGER NOT NULL,
  PRIMARY KEY (idLista, idCancion)
);


-- Canciones favoritas de un usuario
CREATE TABLE fav_cancion (
  idUsuario  INTEGER NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
  idCancion  INTEGER NOT NULL,
  PRIMARY KEY (idUsuario, idCancion)
);

-- Álbumes favoritos
CREATE TABLE fav_album (
  idUsuario  INTEGER NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
  idAlbum    INTEGER NOT NULL ,
  PRIMARY KEY (idUsuario, idAlbum)
);

-- Álbumes en lista de deseos
CREATE TABLE deseo_album (
  idUsuario  INTEGER NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
  idAlbum    INTEGER NOT NULL ,
  PRIMARY KEY (idUsuario, idAlbum)
);

-- Artistas favoritos
CREATE TABLE fav_artista (
  idUsuario  INTEGER NOT NULL REFERENCES usuario(id)  ON DELETE CASCADE,
  idArtista  INTEGER NOT NULL REFERENCES usuario(id)  ON DELETE CASCADE,
  PRIMARY KEY (idUsuario, idArtista)
);

-- Comunidad de artistas
CREATE TABLE postComunidad (
  id          SERIAL PRIMARY KEY,
  comentario  TEXT NOT NULL,
  postPadre   INTEGER REFERENCES postComunidad(id) ON DELETE CASCADE, -- permite hilos/respuestas
  idUsuario   INTEGER NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
  idComunidad INTEGER NOT NULL REFERENCES usuario(id) ON DELETE CASCADE
);


COMMIT;
