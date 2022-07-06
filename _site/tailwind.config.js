module.exports = {
  darkMode: 'media',
  content: [
    './_includes/**/*.html',
    './_layouts/**/*.html',
    './_posts/*.md',
    './*.html',
  ],
  theme: {
    extend: {}
  },
  variants: {},
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
