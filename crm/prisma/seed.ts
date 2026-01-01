import { PrismaClient } from "@prisma/client"
import bcrypt from "bcryptjs"

const prisma = new PrismaClient()

async function main() {
  // Create CRM admin user
  const hashedPassword = await bcrypt.hash("admin123", 10)

  const admin = await prisma.crm_users.upsert({
    where: { email: "admin@sepzy.com" },
    update: {},
    create: {
      id: crypto.randomUUID(),
      email: "admin@sepzy.com",
      name: "Admin Sepzy",
      password_hash: hashedPassword,
      role: "admin",
      is_active: true,
      updated_at: new Date(),
    },
  })

  console.log("✅ CRM Admin user created:", admin.email)
  console.log("📧 Email: admin@sepzy.com")
  console.log("🔑 Password: admin123")
  console.log("👤 Role:", admin.role)

  // Create a staff user
  const staffPassword = await bcrypt.hash("staff123", 10)

  const staff = await prisma.crm_users.upsert({
    where: { email: "staff@sepzy.com" },
    update: {},
    create: {
      id: crypto.randomUUID(),
      email: "staff@sepzy.com",
      name: "Staff User",
      password_hash: staffPassword,
      role: "staff",
      is_active: true,
      updated_at: new Date(),
    },
  })

  console.log("\n✅ CRM Staff user created:", staff.email)
  console.log("📧 Email: staff@sepzy.com")
  console.log("🔑 Password: staff123")
  console.log("👤 Role:", staff.role)
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
