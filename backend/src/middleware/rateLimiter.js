import rateLimit from 'express-rate-limit';

// Rate limiter para login (más estricto)
export const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // máximo 5 intentos
  message: {
    error: 'Demasiados intentos de login. Por favor, intenta de nuevo más tarde.'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limiter para registro
export const registerLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hora
  max: 3, // máximo 3 registros por hora
  message: {
    error: 'Demasiados intentos de registro. Por favor, intenta de nuevo más tarde.'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limiter general para APIs
export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // máximo 100 peticiones
  message: {
    error: 'Demasiadas peticiones. Por favor, intenta de nuevo más tarde.'
  },
  standardHeaders: true,
  legacyHeaders: false,
});
