"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"

interface Seller {
  id: number
  email: string
  firstName: string | null
  lastName: string | null
  businessName: string | null
  rating: number | null
  totalSales: number
  createdAt: string
}

export default function SellersPage() {
  const router = useRouter()
  const [sellers, setSellers] = useState<Seller[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState("")
  const [error, setError] = useState("")

  useEffect(() => {
    fetchSellers()
  }, [])

  const fetchSellers = async () => {
    try {
      const response = await fetch('/api/sellers')
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || 'Failed to fetch sellers')
      }

      if (Array.isArray(data)) {
        setSellers(data)
      } else {
        console.error("Unexpected data format:", data)
        setSellers([])
      }
    } catch (error) {
      console.error("Error fetching sellers:", error)
      setError(error instanceof Error ? error.message : 'An error occurred')
      setSellers([])
    } finally {
      setLoading(false)
    }
  }

  const filteredSellers = sellers.filter(
    (seller) =>
      seller.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      `${seller.firstName} ${seller.lastName}`.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (seller.businessName && seller.businessName.toLowerCase().includes(searchTerm.toLowerCase()))
  )

  const getRatingStars = (rating: number | null) => {
    if (!rating) return "N/A"
    const fullStars = Math.floor(rating)
    const hasHalfStar = rating % 1 >= 0.5
    return "⭐".repeat(fullStars) + (hasHalfStar ? "✨" : "")
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#1c1d21]">Sellers Management</h1>
          <p className="text-sm text-[#8181a5] mt-1">
            Manage and monitor all sellers on the platform
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">🏪</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">{sellers.length}</p>
              <p className="text-xs text-[#8181a5]">Total Sellers</p>
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
                {sellers
                  .reduce((acc, s) => acc + s.totalSales, 0)
                  .toLocaleString()}
              </p>
              <p className="text-xs text-[#8181a5]">Total Sales</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">⭐</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">
                {sellers.length > 0
                  ? (
                      sellers.reduce((acc, s) => acc + (s.rating || 0), 0) / sellers.length
                    ).toFixed(1)
                  : "0"}
              </p>
              <p className="text-xs text-[#8181a5]">Avg Rating</p>
            </div>
          </div>
        </div>
      </div>

      {/* Search */}
      <div className="bg-white rounded-lg p-4 border border-gray-200">
        <input
          type="text"
          placeholder="Search sellers by name, email, or business..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
        />
      </div>

      {/* Sellers Grid */}
      {loading ? (
        <div className="bg-white rounded-lg p-8 text-center text-[#8181a5] border border-gray-200">
          Loading sellers...
        </div>
      ) : error ? (
        <div className="bg-white rounded-lg p-8 text-center border border-gray-200">
          <span className="text-4xl mb-4 block">⚠️</span>
          <p className="text-red-600 font-medium">Error loading sellers</p>
          <p className="text-sm text-[#8181a5] mt-1">{error}</p>
        </div>
      ) : filteredSellers.length === 0 ? (
        <div className="bg-white rounded-lg p-8 text-center border border-gray-200">
          <span className="text-4xl mb-4 block">🏪</span>
          <p className="text-[#1c1d21] font-medium">No sellers found</p>
          <p className="text-sm text-[#8181a5] mt-1">
            {searchTerm ? "Try adjusting your search" : "Sellers will appear here once they register"}
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredSellers.map((seller) => (
            <div
              key={seller.id}
              className="bg-white rounded-lg border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow"
            >
              <div className="p-6">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center text-purple-600 font-bold text-lg">
                      {(seller.firstName || seller.lastName || "S").charAt(0).toUpperCase()}
                    </div>
                    <div>
                      <h3 className="text-lg font-semibold text-[#1c1d21]">
                        {seller.firstName && seller.lastName
                          ? `${seller.firstName} ${seller.lastName}`
                          : "Unnamed Seller"}
                      </h3>
                      {seller.businessName && (
                        <p className="text-xs text-[#8181a5]">{seller.businessName}</p>
                      )}
                    </div>
                  </div>
                </div>

                <div className="space-y-3 mb-4">
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-[#8181a5]">Email</span>
                    <span className="text-[#1c1d21] font-medium">{seller.email}</span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-[#8181a5]">Rating</span>
                    <span className="text-[#1c1d21] font-medium">
                      {getRatingStars(seller.rating)}
                      {seller.rating && <span className="text-xs ml-1">({seller.rating.toFixed(1)})</span>}
                    </span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-[#8181a5]">Total Sales</span>
                    <span className="text-[#1c1d21] font-semibold">
                      ${seller.totalSales.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-[#8181a5]">Joined</span>
                    <span className="text-[#1c1d21]">
                      {new Date(seller.createdAt).toLocaleDateString()}
                    </span>
                  </div>
                </div>

                <div className="flex gap-2">
                  <button
                    onClick={() => router.push(`/dashboard/sellers/${seller.id}`)}
                    className="flex-1 px-4 py-2 bg-[#5e81f4] text-white rounded-lg text-sm font-semibold hover:bg-[#4a6ad4] transition-colors"
                  >
                    View Details
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
