import type { Metadata } from "next"
import "./globals.css"

export const metadata: Metadata = {
  title: "Sepzy CRM - Admin Dashboard",
  description: "Admin dashboard for Sepzy",
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="es">
      <body className="antialiased">
        {children}
      </body>
    </html>
  )
}
