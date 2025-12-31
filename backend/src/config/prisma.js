import { PrismaClient } from '@prisma/client';

// Instancia global de Prisma Client
const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  errorFormat: 'pretty',
});

// Manejo de shutdown graceful
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

export default prisma;
