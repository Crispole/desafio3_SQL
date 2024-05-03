CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100),
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    rol VARCHAR(50) CHECK (rol IN ('administrador', 'usuario'))
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('camila@example.com', 'Camila', 'Baez', 'administrador'),
('pedro@example.com', 'Pedro', 'Latorre', 'usuario'),
('carolina@example.com', 'Carolina', 'Carrasco', 'usuario'),
('javier@example.com', 'Javier', 'de la Rivera', 'usuario'),
('emilia@example.com', 'Emilia', 'Morales', 'usuario');

select * from usuarios;

CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255),
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

INSERT INTO Posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Título Post 1', 'Contenido Post 1', '2020-01-10','2021-02-01', true, 1),
('Título Post 2', 'Contenido Post 2', '2022-01-06','2022-02-01', false, 1),
('Título Post 3', 'Contenido Post 3', '2023-01-07','2024-02-01', true, 2),
('Título Post 4', 'Contenido Post 4', '2023-01-03','2023-02-23', false, 3),
('Título Post 5', 'Contenido Post 5', '2021-09-01','2021-11-11', true, NULL);

select * from Posts;

CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Contenido Comentario 1', '2021-06-03', 1, 1),
('Contenido Comentario 2', '2022-06-07', 2, 1),
('Contenido Comentario 3', '2023-02-08', 3, 1),
('Contenido Comentario 4', '2023-06-10', 1, 2),
('Contenido Comentario 5', '2021-10-12', 2, 2);

select * from Comentarios;

-- REQUERIMIENTOS

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
-- nombre y email del usuario junto al título y contenido del post.

SELECT u.nombre, u.email, p.titulo, p.contenido
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
--    a. El administrador puede ser cualquier id.

SELECT p.id, p.titulo, p.contenido
FROM Posts as p
JOIN Usuarios as u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
--    a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM Usuarios as u
LEFT JOIN Posts as p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 5. Muestra el email del usuario que ha creado más posts.
--    a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT u.email
FROM Usuarios as u
JOIN Posts as p ON u.id = p.usuario_id
GROUP BY u.id
ORDER BY COUNT(p.id) DESC
LIMIT 1;

-- 6.  Muestra la fecha del último post de cada usuario.
-- No sabía si desde la fecha de creación o actualización, así que hice ambos y añadí el correo de cada usuario

SELECT u.id, u.nombre, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM Usuarios as u
LEFT JOIN Posts as p ON u.id = p.usuario_id
GROUP BY u.id;

SELECT u.id, u.nombre, MAX(p.fecha_actualizacion) AS fecha_ultimo_post
FROM Usuarios as u
LEFT JOIN Posts as p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT p.titulo, p.contenido
FROM Posts as p
JOIN Comentarios as c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a 
--    los posts mostrados, junto con el email del usuario que lo escribió.

SELECT 
    p.titulo AS titulo_post,
    p.contenido AS contenido_post,
    c.contenido AS contenido_comentario,
    u.email AS email_usuario
FROM 
    Posts as p
LEFT JOIN 
    Comentarios as c ON p.id = c.post_id
LEFT JOIN 
    Usuarios as u ON c.usuario_id = u.id
ORDER BY 
    p.id, c.id;
	
-- 9. Muestra el contenido del último comentario de cada usuario.

SELECT DISTINCT on (usuario_id)
    usuario_id as id_usuario,
    email as email_usuario,
    contenido as contenido_ultimo_comentario
FROM 
    Comentarios
JOIN 
    Usuarios on Comentarios.usuario_id = Usuarios.id
ORDER BY 
    usuario_id, fecha_creacion desc;
	
-- 10.  Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT u.email
FROM Usuarios as u
LEFT JOIN Comentarios as c ON u.id = c.usuario_id
WHERE c.usuario_id IS NULL;