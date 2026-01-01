"use client"

import { useState } from "react"
import { signIn } from "next-auth/react"
import { useRouter } from "next/navigation"

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState("")

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    setError("")

    try {
      const result = await signIn("credentials", {
        email,
        password,
        redirect: false,
      })

      if (result?.error) {
        setError("Invalid credentials")
      } else {
        router.push("/dashboard")
        router.refresh()
      }
    } catch (error) {
      setError("An error occurred. Please try again.")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-[#5e81f4] flex">
      {/* Left Side - Login Form */}
      <div className="w-full lg:w-1/2 bg-white flex items-center justify-center p-8 lg:p-16 rounded-tr-2xl rounded-br-2xl">
        <div className="w-full max-w-md">
          {/* Header */}
          <div className="mb-16">
            <h1 className="text-3xl font-bold text-[#1c1d21] mb-2 leading-tight">
              Welcome to our CRM.
              <br />
              Sign In to see latest updates.
            </h1>
            <p className="text-[14px] text-[#8181a5]">
              Enter your details to proceed further
            </p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-8">
            <div className="space-y-8">
              {/* Email Input */}
              <div className="relative">
                <label className="block text-[14px] text-[#8181a5] mb-1">
                  Email
                </label>
                <div className="relative">
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full pb-2 border-b border-[#ececf2] text-[14px] text-[#1c1d21] outline-none focus:border-[#5e81f4] transition-colors"
                    placeholder="Start typing…"
                    required
                  />
                  <span className="absolute right-0 top-1/2 -translate-y-1/2 text-[18px] text-[#1c1d21]">
                    ✉
                  </span>
                </div>
              </div>

              {/* Password Input */}
              <div className="relative">
                <label className="block text-[14px] text-[#8181a5] mb-1">
                  Password
                </label>
                <div className="relative">
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="w-full pb-2 border-b border-[#ececf2] text-[14px] text-[#8181a5] outline-none focus:border-[#5e81f4] transition-colors"
                    placeholder="Start typing…"
                    required
                  />
                  <span className="absolute right-0 top-1/2 -translate-y-1/2 text-[18px] text-[#8181a5]">
                    🔒
                  </span>
                </div>
              </div>

              {/* Remember Me & Forgot Password */}
              <div className="flex items-center justify-between">
                <label className="flex items-center gap-2 cursor-pointer">
                  <div className="relative w-5 h-5">
                    <input
                      type="checkbox"
                      className="peer appearance-none w-5 h-5 border-2 border-[#5e81f4] rounded-md checked:bg-[#5e81f4]"
                    />
                    <svg
                      className="absolute w-3 h-3 text-white top-1 left-1 pointer-events-none peer-checked:block hidden"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={3}
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                  </div>
                  <span className="text-[14px] text-[#1c1d21] font-semibold">
                    Remember me
                  </span>
                </label>
                <button
                  type="button"
                  className="text-[14px] text-[#5e81f4] font-semibold hover:underline"
                >
                  Recover password
                </button>
              </div>
            </div>

            {/* Error Message */}
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-lg text-sm">
                {error}
              </div>
            )}

            {/* Buttons */}
            <div className="flex gap-2">
              <button
                type="submit"
                disabled={isLoading}
                className="flex-1 h-12 bg-[#5e81f4] text-white rounded-lg font-semibold text-[14px] hover:bg-[#4a6ad4] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isLoading ? "Signing in..." : "Sign In"}
              </button>
              <button
                type="button"
                className="flex-1 h-12 bg-white border border-[#5e81f4] text-[#5e81f4] rounded-lg font-semibold text-[14px] hover:bg-[#5e81f4] hover:text-white transition-colors"
              >
                Sign Up
              </button>
            </div>
          </form>

          {/* Social Login */}
          <div className="mt-12 text-center">
            <p className="text-[14px] text-[#8181a5] mb-4">Or sign in with</p>
            <div className="flex justify-center gap-2">
              <button className="w-12 h-12 border border-gray-200 rounded-lg flex items-center justify-center hover:bg-gray-50 transition-colors">
                <span className="text-2xl">G</span>
              </button>
              <button className="w-12 h-12 border border-gray-200 rounded-lg flex items-center justify-center hover:bg-gray-50 transition-colors">
                <span className="text-2xl">in</span>
              </button>
              <button className="w-12 h-12 border border-gray-200 rounded-lg flex items-center justify-center hover:bg-gray-50 transition-colors">
                <span className="text-2xl">𝕏</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Right Side - Illustration */}
      <div className="hidden lg:block lg:w-1/2 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-[#5e81f4] to-[#7ba3ff]" />
        <div className="absolute inset-0 flex items-center justify-center">
          {/* Decorative elements matching the Figma design */}
          <div className="relative w-full h-full">
            <div className="absolute top-20 right-20 w-96 h-96 bg-white/10 rounded-full blur-3xl" />
            <div className="absolute bottom-20 left-20 w-64 h-64 bg-white/10 rounded-full blur-3xl" />
            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-white text-center">
              <h2 className="text-4xl font-bold mb-4">CRM Dashboard</h2>
              <p className="text-lg opacity-90">Manage your business efficiently</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
