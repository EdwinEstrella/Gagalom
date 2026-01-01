"use client"

import { useEffect, useState } from "react"

interface User {
  id: number
  email: string
  firstName: string | null
  lastName: string | null
  role: string
  gender: string | null
  ageRange: string | null
  createdAt: string
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState("")
  const [error, setError] = useState("")

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      // Fetch only customers by default
      const response = await fetch('/api/users?role=customer')
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || 'Failed to fetch users')
      }

      // Ensure data is an array
      if (Array.isArray(data)) {
        setUsers(data)
      } else {
        console.error("Unexpected data format:", data)
        setUsers([])
      }
    } catch (error) {
      console.error("Error fetching users:", error)
      setError(error instanceof Error ? error.message : 'An error occurred')
      setUsers([])
    } finally {
      setLoading(false)
    }
  }

  const filteredUsers = users.filter((user) => {
    const matchesSearch =
      user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      `${user.firstName} ${user.lastName}`.toLowerCase().includes(searchTerm.toLowerCase())
    return matchesSearch
  })

  const getRoleColor = (role: string) => {
    switch (role.toLowerCase()) {
      case "admin":
        return "bg-purple-100 text-purple-700"
      case "seller":
        return "bg-green-100 text-green-700"
      case "customer":
        return "bg-blue-100 text-blue-700"
      default:
        return "bg-gray-100 text-gray-700"
    }
  }

  const getRoleBadge = (role: string) => {
    switch (role.toLowerCase()) {
      case "admin":
        return "Admin"
      case "seller":
        return "Seller"
      case "customer":
        return "Customer"
      default:
        return role
    }
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#1c1d21]">Customers Management</h1>
          <p className="text-sm text-[#8181a5] mt-1">
            Manage and monitor all customers in the system
          </p>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="bg-white rounded-lg p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
              <span className="text-xl">🛒</span>
            </div>
            <div>
              <p className="text-2xl font-bold text-[#1c1d21]">{users.length}</p>
              <p className="text-xs text-[#8181a5]">Total Customers</p>
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
                {users.filter((u) => u.is_active !== false).length}
              </p>
              <p className="text-xs text-[#8181a5]">Active Customers</p>
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
              placeholder="Search customers by name or email..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
            />
          </div>
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-[#8181a5]">Loading users...</div>
        ) : error ? (
          <div className="p-8 text-center">
            <span className="text-4xl mb-4 block">⚠️</span>
            <p className="text-red-600 font-medium">Error loading users</p>
            <p className="text-sm text-[#8181a5] mt-1">{error}</p>
          </div>
        ) : filteredUsers.length === 0 ? (
          <div className="p-8 text-center">
            <span className="text-4xl mb-4 block">🛒</span>
            <p className="text-[#1c1d21] font-medium">No customers found</p>
            <p className="text-sm text-[#8181a5] mt-1">
              {searchTerm
                ? "Try adjusting your search"
                : "No customers registered yet"}
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    User
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Role
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Gender
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Age
                  </th>
                  <th className="text-left px-6 py-3 text-xs font-semibold text-[#8181a5] uppercase tracking-wider">
                    Joined
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {filteredUsers.map((user) => (
                  <tr key={user.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-[#5e81f4] rounded-full flex items-center justify-center text-white font-semibold">
                          {(user.firstName || user.lastName || "U").charAt(0).toUpperCase()}
                        </div>
                        <div>
                          <p className="text-sm font-medium text-[#1c1d21]">
                            {user.firstName && user.lastName
                              ? `${user.firstName} ${user.lastName}`
                              : "Unnamed User"}
                          </p>
                          <p className="text-xs text-[#8181a5]">{user.email}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span
                        className={`px-2 py-1 text-xs rounded-full font-medium ${getRoleColor(user.role)}`}
                      >
                        {getRoleBadge(user.role)}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-sm text-[#1c1d21]">
                        {user.gender || "N/A"}
                      </p>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-sm text-[#1c1d21]">
                        {user.ageRange || "N/A"}
                      </p>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-sm text-[#1c1d21]">
                        {new Date(user.createdAt).toLocaleDateString()}
                      </p>
                      <p className="text-xs text-[#8181a5]">
                        {new Date(user.createdAt).toLocaleTimeString()}
                      </p>
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
