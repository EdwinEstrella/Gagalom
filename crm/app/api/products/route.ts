import { NextResponse } from "next/server"
import { prisma } from "@/lib/prisma"

export async function GET() {
  try {
    const products = await prisma.products.findMany({
      select: {
        id: true,
        name: true,
        description: true,
        price: true,
        stock: true,
        category: true,
        image_url: true,
        created_at: true,
      },
      orderBy: {
        created_at: "desc",
      },
    })

    // Transform snake_case to camelCase and convert Decimal to number
    const serializedProducts = products.map((product) => ({
      id: product.id,
      name: product.name,
      description: product.description,
      price: Number(product.price),
      stock: product.stock,
      category: product.category,
      imageUrl: product.image_url,
      createdAt: product.created_at?.toISOString() || new Date().toISOString(),
    }))

    return NextResponse.json(serializedProducts)
  } catch (error) {
    console.error("Error fetching products:", error)
    return NextResponse.json({ error: "Failed to fetch products" }, { status: 500 })
  }
}
