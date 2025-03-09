const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  mode: 'jit',
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/decorators/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,html,turbo_stream,js}',
    './app/components/**/*.html.erb',
    './app/components/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './config/initializers/**/*.rb',
    './node_modules/flowbite/**/*.js',
  ],
  theme: {
    fontFamily: {
      serif: ['DM Serif Display', ...defaultTheme.fontFamily.serif],
      sans: ['DM Sans', ...defaultTheme.fontFamily.sans],
    },
    extend: {
       colors: {
        'light-sky': "#f0f9ff",
        'main-sky': "#0ea5e9",
        'orange-accent': "#FFC533",
        'dark-blue': "#02263c"
      },
      spacing: {
        '8xl': '96rem',
        '9xl': '128rem',
      },
      borderRadius: {
        '4xl': '2rem',
      }
    }
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('flowbite/plugin'),
    require('daisyui')
  ],
  daisyui: {
    darkTheme: false, // Disable auto dark mode
    themes: ["light"],
  },
}
