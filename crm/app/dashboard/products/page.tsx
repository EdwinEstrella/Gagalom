"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import Image from "next/image"

interface Product {
  id: number
  name: string
  description: string | null
  price: number
  stock: number
  category: string | null
  imageUrl: string | null
  createdAt: string
}

export default function ProductsPage() {
  const router = useRouter()
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState("")
  const [error, setError] = useState("")

  useEffect(() => {
    fetchProducts()
  }, [])

  const fetchProducts = async () => {
    try {
      const response = await fetch('/api/products')
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || 'Failed to fetch products')
      }

      if (Array.isArray(data)) {
        setProducts(data)
      } else {
        console.error("Unexpected data format:", data)
        setProducts([])
      }
    } catch (error) {
      console.error("Error fetching products:", error)
      setError(error instanceof Error ? error.message : 'An error occurred')
      setProducts([])
    } finally {
      setLoading(false)
    }
  }

  const filteredProducts = products.filter(
    (product) =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (product.category && product.category.toLowerCase().includes(searchTerm.toLowerCase()))
  )

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#1c1d21]">Products Management</h1>
          <p className="text-sm text-[#8181a5] mt-1">
            Manage and monitor your product catalog
          </p>
        </div>
        <button
          onClick={() => router.push("/dashboard/products/new")}
          className="px-4 py-2 bg-[#5e81f4] text-white rounded-lg text-sm font-semibold hover:bg-[#4a6ad4] transition-colors flex items-center gap-2"
        >
          <span>➕</span>
          Add Product
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">📦</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">{products.length}</p>
              <p className="text-xs text-[#8181a5]">Total Products</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">💰</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">
                $
                {products
                  .reduce((acc, p) => acc + p.price, 0)
                  .toLocaleString()}
              </p>
              <p className="text-xs text-[#8181a5]">Total Value</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">⚠️</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">
                {products.filter((p) => p.stock < 10).length}
              </p>
              <p className="text-xs text-[#8181a5]">Low Stock</p>
            </div>
          </div>
        </div>
      </div>

      {/* Search */}
      <div className="bg-white rounded-lg p-4 border border-gray-200">
        <input
          type="text"
          placeholder="Search products by name or category..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
        />
      </div>

      {/* Products Grid */}
      {loading ? (
        <div className="bg-white rounded-lg p-8 text-center text-[#8181a5] border border-gray-200">
          Loading products...
        </div>
      ) : error ? (
        <div className="bg-white rounded-lg p-8 text-center border border-gray-200">
          <span className="text-4xl mb-4 block">⚠️</span>
          <p className="text-red-600 font-medium">Error loading products</p>
          <p className="text-sm text-[#8181a5] mt-1">{error}</p>
        </div>
      ) : filteredProducts.length === 0 ? (
        <div className="bg-white rounded-lg p-8 text-center border border-gray-200">
          <span className="text-4xl mb-4 block">📦</span>
          <p className="text-[#1c1d21] font-medium">No products found</p>
          <p className="text-sm text-[#8181a5] mt-1">
            {searchTerm ? "Try adjusting your search" : "Get started by adding your first product"}
          </p>
          {!searchTerm && (
            <button
              onClick={() => router.push("/dashboard/products/new")}
              className="mt-4 px-4 py-2 bg-[#5e81f4] text-white rounded-lg text-sm font-semibold hover:bg-[#4a6ad4] transition-colors"
            >
              Add First Product
            </button>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredProducts.map((product) => (
            <div
              key={product.id}
              className="bg-white rounded-lg border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow"
            >
              {product.imageUrl ? (
                <div className="relative w-full h-48">
                  <Image
                    src={product.imageUrl}
                    alt={product.name}
                    fill
                    className="object-cover"
                    sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
                  />
                </div>
              ) : (
                <div className="w-full h-48 bg-gray-100 flex items-center justify-center">
                  <span className="text-4xl">📦</span>
                </div>
              )}
              <div className="p-4">
                <div className="flex items-start justify-between mb-2">
                  <h3 className="text-lg font-semibold text-[#1c1d21] flex-1">
                    {product.name}
                  </h3>
                  {product.stock < 10 && (
                    <span className="px-2 py-1 bg-red-100 text-red-700 text-xs rounded-full font-medium ml-2">
                      Low Stock
                    </span>
                  )}
                </div>
                {product.category && (
                  <p className="text-xs text-[#8181a5] mb-2">{product.category}</p>
                )}
                {product.description && (
                  <p className="text-sm text-[#8181a5] mb-4 line-clamp-2">
                    {product.description}
                  </p>
                )}
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xl font-bold text-[#5e81f4]">
                      ${product.price.toFixed(2)}
                    </p>
                    <p className="text-xs text-[#8181a5]">{product.stock} in stock</p>
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => router.push(`/dashboard/products/${product.id}`)}
                      className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                      title="View"
                    >
                      <span>👁️</span>
                    </button>
                    <button
                      onClick={() => router.push(`/dashboard/products/${product.id}/edit`)}
                      className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                      title="Edit"
                    >
                      <span>✏️</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
