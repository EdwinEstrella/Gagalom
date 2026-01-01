import { PrismaClient } from "@prisma/client"
import bcrypt from "bcryptjs"

const prisma = new PrismaClient()

async function main() {
  // Create admin user in the existing users table
  const hashedPassword = await bcrypt.hash("admin123", 10)

  const admin = await prisma.user.upsert({
    where: { email: "admin@sepzy.com" },
    update: {},
    create: {
      email: "admin@sepzy.com",
      firstName: "Admin",
      lastName: "User",
      passwordHash: hashedPassword,
      role: "admin",
      isActive: true,
    },
  })

  console.log("✅ Admin user created:", admin.email)
  console.log("📧 Email: admin@sepzy.com")
  console.log("🔑 Password: admin123")
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
