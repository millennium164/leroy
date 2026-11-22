/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        leroy: {
          50: '#f3fbe8',
          100: '#e3f5c8',
          200: '#c8ea93',
          300: '#a6d85a',
          400: '#8cc92e',
          500: '#78BE20',
          600: '#5f9916',
          700: '#487612',
          800: '#3b5d14',
          900: '#334f16',
        },
      },
      animation: {
        'fade-in': 'fadeIn 0.4s ease forwards',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
  plugins: [],
}
