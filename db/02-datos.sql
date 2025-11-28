-- tipos de usuario
INSERT INTO tipoUsuario (nombre) VALUES
('Administrador'),
('Artista'),
('Usuario Premium'),
('Usuario Básico');

-- usuarios del sistema
INSERT INTO usuario (nombre, correo, contrasena, direccion, telefono, descripcion, urlImagen, tipo) VALUES
('Laura Sánchez', 'laura@example.com', 'hash_contra_1', 'Calle Real 12, Madrid', '611223344',
 'Amante de la música pop y creadora de playlists.', 'https://img.com/laura.jpg', 4),

('Carlos Ruiz', 'carlos@example.com', 'hash_contra_2', 'Av. Central 45, Sevilla', '622334455',
 'Fan del rock clásico y guitarrista aficionado.', 'https://img.com/carlos.jpg', 3),

('Ana López', 'ana@example.com', 'hash_contra_3', 'Plaza Mayor 10, Valencia', '633445566',
 'Le encanta descubrir nuevos artistas indie.', 'https://img.com/ana.jpg', 4),

('Pablo Torres', 'pablo@example.com', 'hash_contra_4', 'Calle Luna 8, Barcelona', '644556677',
 'Administrador del sistema y soporte técnico.', 'https://img.com/pablo.jpg', 1),

('Marta Gómez', 'marta@example.com', 'hash_contra_5', 'Calle Sol 20, Bilbao', '655667788',
 'Cantante y productora musical (Artista).', 'https://img.com/marta.jpg', 2),

('Lucía Fernández', 'lucia@example.com', 'hash_contra_6', 'Calle Norte 23, Granada', '666778899',
 'Apasionada del jazz y la música acústica (Artista).', 'https://img.com/lucia.jpg', 2),

('Sergio Morales', 'sergio@example.com', 'hash_contra_7', 'Av. del Mar 17, Cádiz', '677889900',
 'Batería en un grupo de rock local (Artista).', 'https://img.com/sergio.jpg', 2),

('Nuria Ramos', 'nuria@example.com', 'hash_contra_8', 'Paseo del Prado 11, Madrid', '688990011',
 'Le encantan los conciertos en vivo.', 'https://img.com/nuria.jpg', 4),

('David Alonso', 'david@example.com', 'hash_contra_9', 'Calle Esperanza 34, Zaragoza', '699001122',
 'Coleccionista de vinilos antiguos.', 'https://img.com/david.jpg', 3),

('Elena Navarro', 'elena@example.com', 'hash_contra_10', 'Calle Verde 90, Málaga', '610112233',
 'Descubridora de nuevos talentos.', 'https://img.com/elena.jpg', 4);

-- Canciones favoritas
INSERT INTO fav_cancion (idUsuario, idCancion) VALUES
(1, 1), (1, 10),
(2, 5), (2, 7),
(3, 15), (3, 17),
(4, 6), (4, 8),
(5, 18), (5, 19),
(6, 3), (6, 15),
(7, 7), (7, 9),
(8, 4), (8, 14),
(9, 11), (9, 12),
(10, 2), (10, 16);

-- Álbumes favoritos
INSERT INTO fav_album (idUsuario, idAlbum) VALUES
(1, 1), (1, 3),
(2, 2), (2, 4),
(3, 4), (3, 5),
(4, 1), (4, 2),
(5, 5), (6, 3),
(7, 4), (8, 5),
(9, 2), (10, 1);

-- Artistas favoritos
INSERT INTO fav_artista (idUsuario, idArtista) VALUES
(1, 5), (1, 6),
(2, 5), (2, 7),
(3, 6), (3, 7),
(4, 5), (4, 6),
(8, 7), (9, 6),
(10, 5);

INSERT INTO postComunidad (comentario, postPadre, idUsuario, idComunidad) VALUES
-- Comunidad de Marta (id 5)
('¡Hola a todos! Me encanta la nueva canción de Marta.', NULL, 1, 5),
('Totalmente de acuerdo, tiene una voz increíble.', 1, 2, 5),
('¿Sabéis cuándo sale su nuevo álbum?', 1, 3, 5),

-- Comunidad de Lucía (id 6)
('Lucía tiene un estilo de jazz impresionante.', NULL, 6, 6),
('La vi en directo en Granada, fue brutal.', 4, 8, 6),

-- Comunidad de Sergio (id 7)
('La batería de Sergio es una locura en los conciertos.', NULL, 9, 7),
('Sí, su grupo suena genial en vivo.', 6, 10, 7);
