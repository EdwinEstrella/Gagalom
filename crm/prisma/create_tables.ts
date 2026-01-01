import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

async function createTables() {
  const sql = `
    -- CRM Users table
    CREATE TABLE IF NOT EXISTS crm_users (
      id TEXT PRIMARY KEY,
      name TEXT,
      email TEXT UNIQUE,
      "emailVerified" TIMESTAMP,
      image TEXT,
      password TEXT,
      role TEXT DEFAULT 'admin',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- CRM Accounts table
    CREATE TABLE IF NOT EXISTS crm_accounts (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      type TEXT NOT NULL,
      provider TEXT NOT NULL,
      "provider_account_id" TEXT NOT NULL,
      refresh_token TEXT,
      access_token TEXT,
      expires_at INTEGER,
      token_type TEXT,
      scope TEXT,
      id_token TEXT,
      session_state TEXT,
      UNIQUE(provider, "provider_account_id")
    );

    CREATE INDEX IF NOT EXISTS crm_accounts_user_id_idx ON crm_accounts(user_id);

    -- CRM Sessions table
    CREATE TABLE IF NOT EXISTS crm_sessions (
      id TEXT PRIMARY KEY,
      "session_token" TEXT UNIQUE NOT NULL,
      user_id TEXT NOT NULL,
      expires TIMESTAMP NOT NULL
    );

    CREATE INDEX IF NOT EXISTS crm_sessions_user_id_idx ON crm_sessions(user_id);

    -- CRM Verification Tokens table
    CREATE TABLE IF NOT EXISTS crm_verification_tokens (
      identifier TEXT NOT NULL,
      token TEXT NOT NULL,
      expires TIMESTAMP NOT NULL,
      UNIQUE(identifier, token)
    );
  `

  try {
    await prisma.$executeRawUnsafe(sql)
    console.log("✅ CRM tables created successfully")
  } catch (error) {
    console.error("❌ Error creating CRM tables:", error)
  } finally {
    await prisma.$disconnect()
  }
}

createTables()
