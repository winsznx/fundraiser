/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    transpilePackages: ['@fundraiser/shared', '@fundraiser/base-adapter', '@fundraiser/stacks-adapter'],
};

export default nextConfig;
