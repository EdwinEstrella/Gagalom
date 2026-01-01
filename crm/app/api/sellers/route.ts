import { NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export async function GET() {
  try {
    const sellers = await prisma.users.findMany({
      where: {
        role: "seller",
      },
      select: {
        id: true,
        email: true,
        first_name: true,
        last_name: true,
        created_at: true,
        products: {
          select: {
            sales_count: true,
          },
        },
      },
      orderBy: {
        created_at: "desc",
      },
    })

    // Calculate total sales and add business name from seller requests
    const sellersWithStats = await Promise.all(
      sellers.map(async (seller) => {
        // Get seller request for business name
        const sellerRequest = await prisma.seller_requests.findFirst({
          where: {
            user_id: seller.id,
          },
          select: {
            business_name: true,
          },
        })

        // Calculate total sales from products
        const totalSales = seller.products.reduce((sum: number, p: { sales_count: number }) => sum + p.sales_count, 0)

        return {
          id: seller.id,
          email: seller.email,
          firstName: seller.first_name,
          lastName: seller.last_name,
          businessName: sellerRequest?.business_name || null,
          rating: null, // TODO: Implement rating system
          totalSales,
          createdAt: seller.created_at?.toISOString() || new Date().toISOString(),
        }
      })
    )

    return NextResponse.json(sellersWithStats)
  } catch (error) {
    console.error("Error fetching sellers:", error)
    return NextResponse.json({ error: "Failed to fetch sellers" }, { status: 500 })
  }
}
