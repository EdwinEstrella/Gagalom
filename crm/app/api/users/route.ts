import { NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export async function GET() {
  try {
    const users = await prisma.users.findMany({
      select: {
        id: true,
        email: true,
        first_name: true,
        last_name: true,
        role: true,
        gender: true,
        age_range: true,
        created_at: true,
      },
      orderBy: {
        created_at: "desc",
      },
    })

    // Transform snake_case to camelCase for frontend
    const transformedUsers = users.map((user) => ({
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      role: user.role,
      gender: user.gender,
      ageRange: user.age_range,
      createdAt: user.created_at?.toISOString() || new Date().toISOString(),
    }))

    return NextResponse.json(transformedUsers)
  } catch (error) {
    console.error("Error fetching users:", error)
    return NextResponse.json({ error: "Failed to fetch users" }, { status: 500 })
  }
}
