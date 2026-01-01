"use client"

import { useState } from "react"
import { useSession } from "next-auth/react"

export default function SettingsPage() {
  const { data: session } = useSession()
  const [activeTab, setActiveTab] = useState("profile")
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState("")

  const tabs = [
    { id: "profile", name: "Profile", icon: "👤" },
    { id: "security", name: "Security", icon: "🔒" },
    { id: "notifications", name: "Notifications", icon: "🔔" },
    { id: "appearance", name: "Appearance", icon: "🎨" },
  ]

  const handleProfileUpdate = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setMessage("")

    // Simulate API call
    setTimeout(() => {
      setMessage("Profile updated successfully!")
      setLoading(false)
    }, 1000)
  }

  const handlePasswordChange = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setMessage("")

    // Simulate API call
    setTimeout(() => {
      setMessage("Password changed successfully!")
      setLoading(false)
    }, 1000)
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl font-bold text-[#1c1d21]">Settings</h1>
        <p className="text-sm text-[#8181a5] mt-1">
          Manage your account settings and preferences
        </p>
      </div>

      <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
        {/* Tabs */}
        <div className="border-b border-gray-200">
          <nav className="flex">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`px-6 py-4 text-sm font-medium transition-colors border-b-2 ${
                  activeTab === tab.id
                    ? "border-[#5e81f4] text-[#5e81f4]"
                    : "border-transparent text-[#8181a5] hover:text-[#1c1d21] hover:border-gray-300"
                }`}
              >
                <span className="mr-2">{tab.icon}</span>
                {tab.name}
              </button>
            ))}
          </nav>
        </div>

        <div className="p-6">
          {/* Profile Tab */}
          {activeTab === "profile" && (
            <form onSubmit={handleProfileUpdate} className="max-w-2xl space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-[#1c1d21] mb-1">Profile Information</h3>
                <p className="text-sm text-[#8181a5]">Update your account&apos;s profile information</p>
              </div>

              <div className="flex items-center gap-6">
                <div className="w-20 h-20 bg-[#5e81f4] rounded-full flex items-center justify-center text-white text-2xl font-bold">
                  {(session?.user?.name || "A").charAt(0).toUpperCase()}
                </div>
                <div>
                  <button
                    type="button"
                    className="px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium hover:bg-gray-50 transition-colors"
                  >
                    Change Photo
                  </button>
                  <p className="text-xs text-[#8181a5] mt-1">JPG, GIF or PNG. Max size 1MB</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-[#1c1d21] mb-1">
                    First Name
                  </label>
                  <input
                    type="text"
                    defaultValue={session?.user?.name?.split(" ")[0] || ""}
                    className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-[#1c1d21] mb-1">
                    Last Name
                  </label>
                  <input
                    type="text"
                    defaultValue={session?.user?.name?.split(" ").slice(1).join(" ") || ""}
                    className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-1">
                  Email
                </label>
                <input
                  type="email"
                  defaultValue={session?.user?.email || ""}
                  className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
                />
              </div>

              {message && (
                <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg text-sm">
                  {message}
                </div>
              )}

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={loading}
                  className="px-6 py-2 bg-[#5e81f4] text-white rounded-lg text-sm font-semibold hover:bg-[#4a6ad4] transition-colors disabled:opacity-50"
                >
                  {loading ? "Saving..." : "Save Changes"}
                </button>
              </div>
            </form>
          )}

          {/* Security Tab */}
          {activeTab === "security" && (
            <form onSubmit={handlePasswordChange} className="max-w-2xl space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-[#1c1d21] mb-1">Change Password</h3>
                <p className="text-sm text-[#8181a5]">Ensure your account is using a strong password</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-1">
                  Current Password
                </label>
                <input
                  type="password"
                  required
                  className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-1">
                  New Password
                </label>
                <input
                  type="password"
                  required
                  minLength={8}
                  className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
                />
                <p className="text-xs text-[#8181a5] mt-1">Must be at least 8 characters</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-1">
                  Confirm Password
                </label>
                <input
                  type="password"
                  required
                  minLength={8}
                  className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm"
                />
              </div>

              {message && (
                <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg text-sm">
                  {message}
                </div>
              )}

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={loading}
                  className="px-6 py-2 bg-[#5e81f4] text-white rounded-lg text-sm font-semibold hover:bg-[#4a6ad4] transition-colors disabled:opacity-50"
                >
                  {loading ? "Updating..." : "Update Password"}
                </button>
              </div>
            </form>
          )}

          {/* Notifications Tab */}
          {activeTab === "notifications" && (
            <div className="max-w-2xl space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-[#1c1d21] mb-1">
                  Email Notifications
                </h3>
                <p className="text-sm text-[#8181a5]">Manage the email notifications you receive</p>
              </div>

              <div className="space-y-4">
                {[
                  { label: "New user registrations", description: "Receive an email when a new user signs up" },
                  { label: "New orders", description: "Get notified about new orders" },
                  { label: "Low stock alerts", description: "Alert when products are running low on stock" },
                  { label: "Weekly summary", description: "Receive a weekly summary of activities" },
                ].map((setting, i) => (
                  <div key={i} className="flex items-center justify-between p-4 border border-gray-200 rounded-lg">
                    <div>
                      <p className="text-sm font-medium text-[#1c1d21]">{setting.label}</p>
                      <p className="text-xs text-[#8181a5]">{setting.description}</p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input type="checkbox" defaultChecked={i < 2} className="sr-only peer" />
                      <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#5e81f4]"></div>
                    </label>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Appearance Tab */}
          {activeTab === "appearance" && (
            <div className="max-w-2xl space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-[#1c1d21] mb-1">Appearance</h3>
                <p className="text-sm text-[#8181a5]">Customize how your CRM looks</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-3">
                  Theme
                </label>
                <div className="grid grid-cols-3 gap-4">
                  {[
                    { name: "Light", value: "light", icon: "☀️" },
                    { name: "Dark", value: "dark", icon: "🌙" },
                    { name: "System", value: "system", icon: "💻" },
                  ].map((theme) => (
                    <button
                      key={theme.value}
                      className="p-4 border-2 border-gray-200 rounded-lg hover:border-[#5e81f4] transition-colors text-center"
                    >
                      <span className="text-2xl mb-2 block">{theme.icon}</span>
                      <span className="text-sm font-medium text-[#1c1d21]">{theme.name}</span>
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-3">
                  Accent Color
                </label>
                <div className="flex gap-3">
                  {["#5e81f4", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6"].map((color) => (
                    <button
                      key={color}
                      className="w-12 h-12 rounded-full border-4 border-gray-200 hover:border-gray-400 transition-colors"
                      style={{ backgroundColor: color }}
                    />
                  ))}
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-[#1c1d21] mb-3">
                  Language
                </label>
                <select className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#5e81f4] text-sm">
                  <option value="es">Español</option>
                  <option value="en">English</option>
                  <option value="pt">Português</option>
                </select>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
