import { auth } from "@/auth"
import { NextResponse } from "next/server"

export default auth((req) => {
  const { pathname } = req.nextUrl
  const isLoggedIn = !!req.auth
  const userRole = (req.auth?.user as { role?: string } | undefined)?.role

  // Public routes
  const isPublicRoute = pathname === "/login" || pathname === "/"

  // Allow public routes
  if (isPublicRoute) {
    // If user is logged in and tries to access login page, redirect to dashboard
    if (isLoggedIn && pathname === "/login") {
      return NextResponse.redirect(new URL("/dashboard", req.url))
    }
    return NextResponse.next()
  }

  // Protect all other routes - require authentication
  if (!isLoggedIn) {
    const loginUrl = new URL("/login", req.url)
    loginUrl.searchParams.set("callbackUrl", pathname)
    return NextResponse.redirect(loginUrl)
  }

  // Check if user has CRM role (admin or staff)
  const isCrmUser = userRole === "admin" || userRole === "staff"

  if (!isCrmUser) {
    // User doesn't have CRM access, redirect to login with error
    return NextResponse.redirect(new URL("/login?error=access_denied", req.url))
  }

  return NextResponse.next()
})

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    "/((?!api|_next/static|_next/image|favicon.ico).*)",
  ],
}
