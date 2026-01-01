"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"

interface Order {
  id: number
  userId: number
  total: number
  status: string
  createdAt: string
  user?: {
    email: string
    firstName: string | null
    lastName: string | null
  }
}

export default function OrdersPage() {
  const router = useRouter()
  const [orders, setOrders] = useState<Order[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState("")
  const [statusFilter, setStatusFilter] = useState("all")
  const [error, setError] = useState("")

  useEffect(() => {
    fetchOrders()
  }, [])

  const fetchOrders = async () => {
    try {
      const response = await fetch('/api/orders')
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || 'Failed to fetch orders')
      }

      if (Array.isArray(data)) {
        setOrders(data)
      } else {
        console.error("Unexpected data format:", data)
        setOrders([])
      }
    } catch (error) {
      console.error("Error fetching orders:", error)
      setError(error instanceof Error ? error.message : 'An error occurred')
      setOrders([])
    } finally {
      setLoading(false)
    }
  }

  const filteredOrders = orders.filter((order) => {
    const matchesSearch =
      order.id.toString().includes(searchTerm) ||
      (order.user?.email && order.user.email.toLowerCase().includes(searchTerm.toLowerCase()))
    const matchesStatus = statusFilter === "all" || order.status === statusFilter
    return matchesSearch && matchesStatus
  })

  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case "completed":
        return "bg-green-100 text-green-700"
      case "pending":
        return "bg-yellow-100 text-yellow-700"
      case "cancelled":
        return "bg-red-100 text-red-700"
      case "processing":
        return "bg-blue-100 text-blue-700"
      default:
        return "bg-gray-100 text-gray-700"
    }
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#1c1d21]">Orders Management</h1>
          <p className="text-sm text-[#8181a5] mt-1">
            Track and manage all customer orders
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">🛒</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">{orders.length}</p>
              <p className="text-xs text-[#8181a5]">Total Orders</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">⏳</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">
                {orders.filter((o) => o.status === "pending").length}
              </p>
              <p className="text-xs text-[#8181a5]">Pending</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">✅</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">
                {orders.filter((o) => o.status === "completed").length}
              </p>
              <p className="text-xs text-[#8181a5]">Completed</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">💰</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">
                $
                {orders
                  .filter((o) => o.status === "completed")
                  .reduce((acc, o) => acc + o.total, 0)
                  .toLocaleString()}
              </p>
              <p className="text-xs text-[#8181a5]">Revenue</p>
            </div>
          </div>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg p-4 border border-gray-200">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1">
            <input
              type="text"
              placeholder="Search by order ID or customer email..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
            />
          </div>
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
          >
            <option value="all">All Status</option>
            <option value="pending">Pending</option>
            <option value="processing">Processing</option>
            <option value="completed">Completed</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </div>
      </div>

      {/* Orders Table */}
      <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-[#8181a5]">Loading orders...</div>
        ) : error ? (
          <div className="p-8 text-center">
            <span className="text-4xl mb-4 block">⚠️</span>
            <p className="text-red-600 font-medium">Error loading orders</p>
            <p className="text-sm text-[#8181a5] mt-1">{error}</p>
          </div>
        ) : filteredOrders.length === 0 ? (
          <div className="p-8 text-center">
            <span className="text-4xl mb-4 block">🛒</span>
            <p className="text-[#1c1d21] font-medium">No orders found</p>
            <p className="text-sm text-[#8181a5] mt-1">
              {searchTerm || statusFilter !== "all"
                ? "Try adjusting your filters"
                : "Orders will appear here when customers make purchases"}
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Order ID
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Customer
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Date
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Status
                  </th>
                  <th className="text-right px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Total
                  </th>
                  <th className="text-right px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {filteredOrders.map((order) => (
                  <tr key={order.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-6 py-4">
                      <p className="text-sm font-medium text-[#1c1d21]">#{order.id}</p>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-sm text-[#1c1d21]">
                        {order.user?.firstName && order.user?.lastName
                          ? `${order.user.firstName} ${order.user.lastName}`
                          : order.user?.email || "Unknown"}
                      </p>
                      {order.user?.email && (
                        <p className="text-xs text-[#8181a5]">{order.user.email}</p>
                      )}
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-sm text-[#1c1d21]">
                        {new Date(order.createdAt).toLocaleDateString()}
                      </p>
                      <p className="text-xs text-[#8181a5]">
                        {new Date(order.createdAt).toLocaleTimeString()}
                      </p>
                    </td>
                    <td className="px-6 py-4">
                      <span
                        className={`px-2 py-1 text-xs rounded-full font-medium ${getStatusColor(
                          order.status
                        )}`}
                      >
                        {order.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <p className="text-sm font-semibold text-[#1c1d21]">
                        ${order.total.toFixed(2)}
                      </p>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => router.push(`/dashboard/orders/${order.id}`)}
                          className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                          title="View Details"
                        >
                          <span>👁️</span>
                        </button>
                        <button
                          onClick={() => router.push(`/dashboard/orders/${order.id}/edit`)}
                          className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                          title="Update Status"
                        >
                          <span>✏️</span>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
