import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import pool from '../database/db.js';

// Generar tokens JWT
const generateTokens = (userId, email) => {
  const accessToken = jwt.sign(
    { userId, email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );

  return { accessToken };
};

// Registro de usuario
export const register = async (req, res) => {
  const { email, password, firstName, lastName, gender, ageRange } = req.body;

  const client = await pool.connect();

  try {
    // Verificar si el usuario ya existe
    const existingUser = await client.query(
      'SELECT id FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'El email ya está registrado' });
    }

    // Hashear contraseña
    const saltRounds = 12;
    const passwordHash = await bcrypt.hash(password, saltRounds);

    // Crear cliente en Stripe (opcional, puedes hacerlo más tarde)
    // const stripeCustomer = await stripe.customers.create({
    //   email,
    //   name: `${firstName} ${lastName}`,
    // });

    // Insertar usuario en la base de datos
    const result = await client.query(
      `INSERT INTO users (email, password_hash, first_name, last_name, gender, age_range)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id, email, first_name, last_name, gender, age_range, created_at`,
      [email.toLowerCase(), passwordHash, firstName, lastName, gender, ageRange]
    );

    const user = result.rows[0];

    // Generar tokens
    const { accessToken } = generateTokens(user.id, user.email);

    res.status(201).json({
      message: 'Usuario registrado exitosamente',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        gender: user.gender,
        ageRange: user.age_range,
      },
      accessToken,
    });

  } catch (error) {
    console.error('Error en registro:', error);
    res.status(500).json({ error: 'Error al registrar usuario' });
  } finally {
    client.release();
  }
};

// Login de usuario
export const login = async (req, res) => {
  const { email, password } = req.body;

  const client = await pool.connect();

  try {
    // Buscar usuario por email
    const result = await client.query(
      'SELECT * FROM users WHERE email = $1 AND is_active = true',
      [email.toLowerCase()]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const user = result.rows[0];

    // Verificar contraseña
    const isValidPassword = await bcrypt.compare(password, user.password_hash);

    if (!isValidPassword) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    // Actualizar último login
    await client.query(
      'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1',
      [user.id]
    );

    // Generar tokens
    const { accessToken } = generateTokens(user.id, user.email);

    res.json({
      message: 'Login exitoso',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        gender: user.gender,
        ageRange: user.age_range,
      },
      accessToken,
    });

  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({ error: 'Error al iniciar sesión' });
  } finally {
    client.release();
  }
};

// Obtener perfil de usuario
export const getProfile = async (req, res) => {
  const client = await pool.connect();

  try {
    const result = await client.query(
      'SELECT id, email, first_name, last_name, gender, age_range, created_at FROM users WHERE id = $1',
      [req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const user = result.rows[0];

    res.json({
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        gender: user.gender,
        ageRange: user.age_range,
        createdAt: user.created_at,
      },
    });

  } catch (error) {
    console.error('Error al obtener perfil:', error);
    res.status(500).json({ error: 'Error al obtener perfil' });
  } finally {
    client.release();
  }
};

// Actualizar perfil
export const updateProfile = async (req, res) => {
  const { firstName, lastName, gender, ageRange } = req.body;
  const client = await pool.connect();

  try {
    const result = await client.query(
      `UPDATE users
       SET first_name = COALESCE($1, first_name),
           last_name = COALESCE($2, last_name),
           gender = COALESCE($3, gender),
           age_range = COALESCE($4, age_range),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $5
       RETURNING id, email, first_name, last_name, gender, age_range`,
      [firstName, lastName, gender, ageRange, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const user = result.rows[0];

    res.json({
      message: 'Perfil actualizado exitosamente',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        gender: user.gender,
        ageRange: user.age_range,
      },
    });

  } catch (error) {
    console.error('Error al actualizar perfil:', error);
    res.status(500).json({ error: 'Error al actualizar perfil' });
  } finally {
    client.release();
  }
};

// Logout (opcional, ya que JWT es stateless)
export const logout = async (req, res) => {
  // En una implementación más robusta, podrías invalidar el token en una blacklist
  res.json({ message: 'Logout exitoso' });
};

// Cambiar contraseña
export const changePassword = async (req, res) => {
  const { currentPassword, newPassword } = req.body;
  const client = await pool.connect();

  try {
    // Obtener usuario
    const result = await client.query(
      'SELECT password_hash FROM users WHERE id = $1',
      [req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const user = result.rows[0];

    // Verificar contraseña actual
    const isValidPassword = await bcrypt.compare(currentPassword, user.password_hash);

    if (!isValidPassword) {
      return res.status(401).json({ error: 'Contraseña actual incorrecta' });
    }

    // Hashear nueva contraseña
    const saltRounds = 12;
    const newPasswordHash = await bcrypt.hash(newPassword, saltRounds);

    // Actualizar contraseña
    await client.query(
      'UPDATE users SET password_hash = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [newPasswordHash, req.user.userId]
    );

    res.json({ message: 'Contraseña actualizada exitosamente' });

  } catch (error) {
    console.error('Error al cambiar contraseña:', error);
    res.status(500).json({ error: 'Error al cambiar contraseña' });
  } finally {
    client.release();
  }
};
