import { NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export async function GET() {
  try {
    const orders = await prisma.orders.findMany({
      select: {
        id: true,
        user_id: true,
        total_amount: true,
        status: true,
        created_at: true,
        users: {
          select: {
            email: true,
            first_name: true,
            last_name: true,
          },
        },
      },
      orderBy: {
        created_at: "desc",
      },
    })

    // Transform snake_case to camelCase and convert Decimal to number
    const serializedOrders = orders.map((order) => ({
      id: order.id,
      userId: order.user_id,
      total: Number(order.total_amount),
      status: order.status,
      createdAt: order.created_at?.toISOString() || new Date().toISOString(),
      user: order.users ? {
        email: order.users.email,
        firstName: order.users.first_name,
        lastName: order.users.last_name,
      } : null,
    }))

    return NextResponse.json(serializedOrders)
  } catch (error) {
    console.error("Error fetching orders:", error)
    return NextResponse.json({ error: "Failed to fetch orders" }, { status: 500 })
  }
}
