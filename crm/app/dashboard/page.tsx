"use client"

import { useEffect, useState } from "react"

interface Stats {
  totalUsers: number
  totalProducts: number
  totalOrders: number
  totalRevenue: number
}

export default function DashboardPage() {
  const [stats, setStats] = useState<Stats>({
    totalUsers: 0,
    totalProducts: 0,
    totalOrders: 0,
    totalRevenue: 0,
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Fetch real stats from API
    const fetchStats = async () => {
      try {
        const response = await fetch('/api/stats')
        const data = await response.json()

        if (response.ok) {
          setStats({
            totalUsers: data.totalUsers || 0,
            totalProducts: data.totalProducts || 0,
            totalOrders: data.totalOrders || 0,
            totalRevenue: data.totalRevenue || 0,
          })
        } else {
          console.error("API error:", data.error)
        }
      } catch (error) {
        console.error("Error fetching stats:", error)
      } finally {
        setLoading(false)
      }
    }

    fetchStats()
  }, [])

  const statCards = [
    {
      title: "Total Users",
      value: stats.totalUsers,
      icon: "👥",
      color: "bg-blue-100",
      trend: "+12% from last month",
    },
    {
      title: "Products",
      value: stats.totalProducts,
      icon: "📦",
      color: "bg-green-100",
      trend: "+5% from last month",
    },
    {
      title: "Orders",
      value: stats.totalOrders,
      icon: "🛒",
      color: "bg-purple-100",
      trend: "+8% from last month",
    },
    {
      title: "Revenue",
      value: `$${stats.totalRevenue.toLocaleString()}`,
      icon: "💰",
      color: "bg-yellow-100",
      trend: "+23% from last month",
    },
  ]

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl font-bold text-[#1c1d21]">Dashboard Overview</h1>
        <p className="text-sm text-[#8181a5] mt-1">
          Welcome to your CRM dashboard. Here&apos;s what&apos;s happening today.
        </p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {statCards.map((card) => (
          <div
            key={card.title}
            className="bg-white rounded-xl shadow-sm p-6 border border-gray-200 hover:shadow-md transition-shadow"
          >
            <div className="flex items-center justify-between mb-4">
              <div className={`w-12 h-12 ${card.color} rounded-lg flex items-center justify-center`}>
                <span className="text-2xl">{card.icon}</span>
              </div>
              <span className="text-xs text-green-600 font-medium">+12%</span>
            </div>
            <p className="text-sm text-[#8181a5]">{card.title}</p>
            <p className="text-2xl font-bold text-[#1c1d21] mt-1">
              {loading ? "..." : card.value}
            </p>
            <p className="text-xs text-[#8181a5] mt-2">{card.trend}</p>
          </div>
        ))}
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-200">
        <h2 className="text-lg font-semibold text-[#1c1d21] mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <button className="p-4 border border-gray-200 rounded-lg hover:border-[#5e81f4] hover:bg-blue-50 transition-all text-left group">
            <span className="text-2xl mb-2 block">➕</span>
            <span className="font-semibold text-[#1c1d21]">Add New User</span>
            <p className="text-sm text-[#8181a5] mt-1">Create a new user account</p>
          </button>

          <button className="p-4 border border-gray-200 rounded-lg hover:border-[#5e81f4] hover:bg-blue-50 transition-all text-left group">
            <span className="text-2xl mb-2 block">📦</span>
            <span className="font-semibold text-[#1c1d21]">Add Product</span>
            <p className="text-sm text-[#8181a5] mt-1">Add a new product to catalog</p>
          </button>

          <button className="p-4 border border-gray-200 rounded-lg hover:border-[#5e81f4] hover:bg-blue-50 transition-all text-left group">
            <span className="text-2xl mb-2 block">📊</span>
            <span className="font-semibold text-[#1c1d21]">View Reports</span>
            <p className="text-sm text-[#8181a5] mt-1">Analytics and insights</p>
          </button>
        </div>
      </div>

      {/* Charts and Tables Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Orders */}
        <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-[#1c1d21]">Recent Orders</h2>
            <button className="text-sm text-[#5e81f4] hover:underline font-medium">
              View All
            </button>
          </div>
          <div className="space-y-4">
            {[1, 2, 3, 4, 5].map((i) => (
              <div key={i} className="flex items-center justify-between p-3 hover:bg-gray-50 rounded-lg transition-colors">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center">
                    <span>🛒</span>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-[#1c1d21]">Order #{1000 + i}</p>
                    <p className="text-xs text-[#8181a5]">Today, {10 + i}:00 AM</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-sm font-semibold text-[#1c1d21]">${(50 * i).toFixed(2)}</p>
                  <p className="text-xs text-green-600">Completed</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Users */}
        <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-[#1c1d21]">Recent Users</h2>
            <button className="text-sm text-[#5e81f4] hover:underline font-medium">
              View All
            </button>
          </div>
          <div className="space-y-4">
            {["John Doe", "Jane Smith", "Bob Johnson", "Alice Brown", "Charlie Wilson"].map((name, i) => (
              <div key={i} className="flex items-center justify-between p-3 hover:bg-gray-50 rounded-lg transition-colors">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-[#5e81f4] rounded-full flex items-center justify-center text-white font-semibold">
                    {name.charAt(0)}
                  </div>
                  <div>
                    <p className="text-sm font-medium text-[#1c1d21]">{name}</p>
                    <p className="text-xs text-[#8181a5]">user{i + 1}@example.com</p>
                  </div>
                </div>
                <span className="text-xs px-2 py-1 bg-green-100 text-green-700 rounded-full font-medium">
                  Active
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Activity Feed */}
      <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-200">
        <h2 className="text-lg font-semibold text-[#1c1d21] mb-4">Recent Activity</h2>
        <div className="space-y-4">
          {[
            { action: "New order received", user: "John Doe", time: "2 minutes ago", icon: "🛒" },
            { action: "Product updated", user: "Jane Smith", time: "15 minutes ago", icon: "📦" },
            { action: "New user registered", user: "Bob Johnson", time: "1 hour ago", icon: "👤" },
            { action: "Order completed", user: "Alice Brown", time: "2 hours ago", icon: "✅" },
            { action: "Payment received", user: "Charlie Wilson", time: "3 hours ago", icon: "💳" },
          ].map((activity, i) => (
            <div key={i} className="flex items-start gap-4 p-3 hover:bg-gray-50 rounded-lg transition-colors">
              <div className="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                <span>{activity.icon}</span>
              </div>
              <div className="flex-1">
                <p className="text-sm text-[#1c1d21]">
                  <span className="font-medium">{activity.user}</span> {activity.action}
                </p>
                <p className="text-xs text-[#8181a5] mt-1">{activity.time}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
