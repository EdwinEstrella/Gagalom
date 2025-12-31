import pkg from 'pg';
const { Pool } = pkg;
import dotenv from 'dotenv';

dotenv.config();

// Configuración mejorada del Pool con SSL
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
  // SSL para producción (según mejores prácticas de Context7)
  ssl: process.env.NODE_ENV === 'production' ? {
    rejectUnauthorized: false, // Ajustar según tu proveedor de BD
  } : undefined,
});

// Event listeners para monitoreo del pool
pool.on('connect', (client) => {
  console.log('🔌 Nuevo cliente conectado al pool');
});

pool.on('error', (err) => {
  console.error('❌ Unexpected error on idle client', err);
  // En producción, no hacer process.exit, solo loggear
  if (process.env.NODE_ENV !== 'production') {
    process.exit(-1);
  }
});

pool.on('acquire', (client) => {
  console.log('🔄 Cliente adquirido del pool');
});

pool.on('remove', (client) => {
  console.log('🗑️ Cliente removido del pool');
});

/**
 * Wrapper con retry logic para queries (según mejores prácticas de Context7)
 * @param {string} text - Query SQL
 * @param {Array} params - Parámetros de la query
 * @param {number} maxRetries - Máximo número de reintentos (default: 3)
 */
export async function queryWithRetry(text, params, maxRetries = 3) {
  let lastError;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const result = await pool.query(text, params);
      return result;
    } catch (err) {
      lastError = err;

      // Verificar si el error es retryable
      if (err.code === 'ECONNREFUSED' ||
          err.code === 'ETIMEDOUT' ||
          err.code === '57P03') { // cannot_connect_now

        console.log(`⚠️ Intento ${attempt} falló: ${err.message}`);

        if (attempt < maxRetries) {
          // Exponential backoff: 1s, 2s, 4s, etc.
          const delay = Math.min(1000 * Math.pow(2, attempt - 1), 10000);
          console.log(`🔄 Reintentando en ${delay}ms...`);
          await new Promise(resolve => setTimeout(resolve, delay));
          continue;
        }
      }

      // Error no retryable o max reintentos alcanzados
      throw err;
    }
  }

  throw lastError;
}

/**
 * Query con timeout individual (según mejores prácticas de Context7)
 * @param {string} text - Query SQL
 * @param {Array} params - Parámetros
 * @param {number} timeoutMs - Timeout en milisegundos (default: 5000)
 */
export async function queryWithTimeout(text, params, timeoutMs = 5000) {
  const client = await pool.connect();

  try {
    // Establecer statement timeout para esta conexión
    await client.query(`SET statement_timeout = ${timeoutMs}`);

    const result = await client.query(text, params);
    return result;
  } catch (err) {
    if (err.code === '57014') {
      console.error(`⏱️ Query timeout después de ${timeoutMs}ms`);
      throw new Error(`Query timeout: ${err.message}`);
    }
    throw err;
  } finally {
    // Reset timeout y liberar conexión
    try {
      await client.query('SET statement_timeout = 0');
    } catch (e) {
      // Ignorar error al resetear
    }
    client.release();
  }
}

/**
 * Manejo mejorado de errores PostgreSQL (según mejores prácticas de Context7)
 */
export function handleDatabaseError(err) {
  if (err.code === '23505') {
    return {
      type: 'UNIQUE_VIOLATION',
      message: 'Registro duplicado',
      detail: err.detail
    };
  } else if (err.code === '23503') {
    return {
      type: 'FOREIGN_KEY_VIOLATION',
      message: 'Violación de clave foránea',
      detail: err.detail
    };
  } else if (err.code === '42P01') {
    return {
      type: 'TABLE_NOT_FOUND',
      message: 'Tabla no existe',
      detail: err.message
    };
  } else if (err.code === '42703') {
    return {
      type: 'COLUMN_NOT_FOUND',
      message: 'Columna no existe',
      detail: err.message
    };
  } else if (err.code === 'ECONNREFUSED') {
    return {
      type: 'CONNECTION_ERROR',
      message: 'No se puede conectar a la base de datos',
      detail: err.message
    };
  } else {
    return {
      type: 'UNKNOWN_ERROR',
      message: 'Error de base de datos',
      detail: err.message,
      code: err.code
    };
  }
}

export default pool;
