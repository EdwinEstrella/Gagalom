import { NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export async function GET() {
  try {
    // Count users (customers + sellers only, exclude staff/admin)
    const totalUsers = await prisma.users.count({
      where: {
        role: {
          in: ["customer", "seller"],
        },
      },
    })

    // Count total products
    const totalProducts = await prisma.products.count()

    // Count total orders
    const totalOrders = await prisma.orders.count()

    // Calculate total revenue from completed orders
    const orders = await prisma.orders.findMany({
      where: {
        status: "completed",
      },
      select: {
        total_amount: true,
      },
    })

    const totalRevenue = orders.reduce(
      (sum, order) => sum + Number(order.total_amount),
      0
    )

    return NextResponse.json({
      totalUsers,
      totalProducts,
      totalOrders,
      totalRevenue,
    })
  } catch (error) {
    console.error("Error fetching stats:", error)
    return NextResponse.json(
      { error: "Failed to fetch statistics" },
      { status: 500 }
    )
  }
}
