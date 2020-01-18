import React from 'react'

const style = {
  backgroundColor: 'rgba(27, 31, 35, 0.1)',
  padding: '2.8px 5.5px',
  fontFamily: 'SFMono-Regular, Dank Mono, Hack, Fira Code, monospace',
  textRendering: 'optimizeLegibility',
  borderRadius: '3px'
}

export default function InlineCode({ children }) {
  return <code style={style}>{children}</code>
}