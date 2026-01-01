import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Enable standalone output for Docker deployments
  output: 'standalone',

  // Optimize images
  images: {
    unoptimized: true, // Required for standalone output
  },
};

export default nextConfig;
